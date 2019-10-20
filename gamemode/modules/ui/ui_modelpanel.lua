local PANEL      = {}
PANEL.background = Material("materials/galactic/ui/starscape_bw.png", "smooth noclamp")

function PANEL:Init()
	self:SetCamPos(Vector(-50, 0, 10))
	self.aLookAngle = Angle(0, 0, 0)

	self:SetFOV(100)
	self:SetCursor("none")

	self.Entities = {}

	self.colAmbientLight = col.white
	self.lerpFactor = 0.1
end

function PANEL:PreDrawLights()
end

function PANEL:PostDrawLights()
end

function PANEL:SetCamPosLerp(lerpfactor, destination)
	self.lerpFactor = lerpfactor
	self.camposlerp = destination
end

function PANEL:SetCamAngLerp(lerpfactor, destination)
	self.lerpangFactor = lerpfactor
	self.camanglerp = destination
end

function PANEL:SetLookAt(pos)
	self.aLookAngle = (pos - (self.camposlerp and self.camposlerp ~= self.vCamPos and self.camposlerp or self.vCamPos)):Angle()
end

function PANEL:Paint(w, h)

	if  not self.Entities or #self.Entities == 0 then
		return
	end

	local x, y = self:LocalToScreen(0, 0)

	if self.camposlerp and self.vCamPos ~= self.camposlerp then
		local newpos = LerpVector(self.lerpFactor * FrameTime(), self.vCamPos, self.camposlerp)
		self.vCamPos = newpos
	end

	if self.camanglerp and self.aLookAngle ~= self.camanglerp then
		local newang = LerpAngle(self.lerpangFactor * FrameTime(), self.aLookAngle, self.camanglerp)
		self.aLookAngle = newang
	end

	cam.Start3D(self.vCamPos, self.aLookAngle, self.fFOV, x, y, w, h, 1, 25000)
		self:PreDrawLights()

		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(Vector(0,0,150))
		render.ResetModelLighting(self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255)
		render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)
		render.SetBlend((self:GetAlpha() / 255) * (self.colColor.a / 255))

        for i = 0, 6 do
			local col = self.DirectionalLight[i]
			if col then
				render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
			end
		end

		self:PostDrawLights()

		local curparent = self
		local rightx = self:GetWide()
		local leftx = 0
		local topy = 0
		local bottomy = self:GetTall()
		local previous = curparent

		while(curparent:GetParent() != nil) do
			curparent = curparent:GetParent()
			local x, y = previous:GetPos()
			topy = math.Max(y, topy + y)
			leftx = math.Max(x, leftx + x)
			bottomy = math.Min(y + previous:GetTall(), bottomy + y)
			rightx = math.Min(x + previous:GetWide(), rightx + x)
			previous = curparent
		end

		render.SetScissorRect(leftx, topy, rightx, bottomy, true)
			local size_w, size_h = ScrW(), ScrH()
			local rep_w, rep_h = 1, 1
			for _, ent in pairs(self.Entities) do
				if not IsValid(ent) then
					continue
				end

				local ret = self:PreDrawModel(ent)
				if ret ~= false then
				
					render.PushFilterMag(TEXFILTER.ANISOTROPIC)
					render.PushFilterMin(TEXFILTER.ANISOTROPIC)
						ent:DrawModel()
					render.PopFilterMag()
					render.PopFilterMin()
					
					self:PostDrawModel(ent)
				end
			end
		render.SetScissorRect(0, 0, 0, 0, false)
		render.SuppressEngineLighting(false)
	cam.End3D()

	self.LastPaint = RealTime()
end

function PANEL:RunAnimation()
	for _, ent in pairs(self.Entities) do
		if not IsValid(ent) then
			continue
		end
		ent:FrameAdvance((RealTime() - self.LastPaint) * self.m_fAnimSpeed)
	end
end

function PANEL:AddModel(modelStr, pos, angle, size, sequence, returnId)
	angle = angle or Angle()
	pos = pos or Vector()

	local ent = ClientsideModel(modelStr, RENDERGROUP_BOTH)
	if not IsValid(ent) then
		ErrorNoHalt('Failed to create clientside entity for model ' .. (modelStr or 'NOT_FOUND'))
		return
	end

	ent:SetAngles(angle)
	ent:SetNoDraw(true)
	ent:SetIK(false)
	ent:SetPos(pos)
	ent:SetModelScale(size or 1)
	ent:Spawn()

	local seq = ent:LookupSequence(sequence or "walk_all")
	if seq > 0 then
		ent:ResetSequence(seq)
	end

	local id = table.insert(self.Entities, ent)
	if returnId then
		return ent, id
	end

	return ent
end

function PANEL:AddModels(data)
	local ents = {}

	for _, modelinfo in ipairs(data) do
		if not modelinfo.model then
			continue
		end
		ents[#ents+1] = self:AddModel(modelinfo.model, modelinfo.pos, modelinfo.ang, modelinfo.scale)
	end

	return ents
end

function PANEL:AddEntity(ent, sequence)
	if not IsValid(ent) then
		return
	end

	ent:SetNoDraw(true)
	ent:SetIK(false)
	ent:Spawn()

	local seq = ent:LookupSequence(sequence or "walk_all")
	if seq > 0 then
		ent:ResetSequence(seq)
	end

	return ent, table.insert(self.Entities, ent)
end

function PANEL:GetEntity(id)
	local ent = self.Entities[id]
	if IsValid(ent) then
		return ent
	else
		return nil
	end
end

function PANEL:RemoveEntity(id)
	local ent = self.Entities[id]
	if IsValid(ent) then
		table.remove(self.Entities, id):Remove()
		return true
	end
	return false
end

function PANEL:RunAnimation(ent)
	ent:FrameAdvance((RealTime() - self.LastPaint) * self.m_fAnimSpeed)
end

function PANEL:OnRemove()
	for _, ent in pairs(self.Entities) do
		if IsValid(ent) then
			ent:Remove()
		end
	end
end
derma.DefineControl("ss_modelpanel", "Extended Model Panel", table.Copy(PANEL), "DModelPanel")
