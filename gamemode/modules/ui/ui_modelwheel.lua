local PANEL = {
	Paint = function(s)
	end
}

local click = 'common/talk.wav'
local orb = Material 'materials/galactic/ui/character_orb.png'
local orb_inner = Material 'materials/galactic/ui/character_orb_inner.png'
local alpha_white = Color(255,255,255,20)

function PANEL:Init()
	self.ents = {}

	self.selected = 1
	self.distance = 100
	self.lerp_pos = 0
	self.selected_lerpto = 0

	self:AddPanel('ss_modelpanel', function(mdl) 
		self.mdl = mdl
		mdl:Dock(FILL)
		mdl:SetCamPos(Vector(240, 0, 60))
		mdl:SetLookAt(Vector(0, 0, 60))
		mdl.PreDrawModel = function(s, ent)
			self:PreDrawModel(s, ent)
		end
		mdl.PostDrawModel = function(s, ent)
			self:PostDrawModel(s, ent)
		end
	end)

	self:AddPanel('ss_button', function(btn) 
		btn:SetFont 'ui_button_direction'
		btn:SetText ''
		btn:SetSize(40, 40)
		btn:SetVisible(false)
		btn.m_bgColor = col.transparent
		btn.m_bghColor = col.transparent
		btn:LeftClick(function()
			surface.PlaySound(click)
			self:Previous()
		end)
		self.previous = btn
	end)

	self:AddPanel('ss_button', function(btn) 
		btn:SetFont 'ui_button_direction'
		btn:SetText ''
		btn:SetSize(40, 40)
		btn:SetVisible(false)
		btn.m_bgColor = col.transparent
		btn.m_bghColor = col.transparent
		btn:LeftClick(function() 
			surface.PlaySound(click)
			self:Next()
		end)
		self.next = btn
	end)
end

function PANEL:PreDrawModel(mdl_pnl, ent)
	if 	not IsValid(ent) or 
		not ent.data or 
		not orb or 
		not orb_inner then 
		return
	end

	local selected = self.selected == ent.id
	ent.cur_spin = (ent.cur_spin or math.random(0, 100)) + (FrameTime()/1 * (selected and 100 or 20))

	mdl_pnl:RunAnimation(ent)

	cam.Start3D2D(ent:GetPos() + Vector(-4,41,0), Angle(), 1)
		surface.DisableClipping(true)
			surface.SetDrawColor(col.white)
			surface.SetMaterial(orb)
			surface.DrawTexturedRectRotatedPoint(0, 0, 32, 32, ent.cur_spin, 0, 0)
			surface.SetDrawColor(col.white)
			surface.SetMaterial(orb_inner)
			surface.DrawTexturedRect(-16, -16, 32, 32)
		surface.DisableClipping(false)
	cam.End3D2D()
end

function PANEL:PostDrawModel(mdl_pnl, ent)
	if 	not IsValid(ent) or 
		not ent.data or
		not ent.data.name or
		not orb or 
		not orb_inner then 
		return
	end

	local selected = self.selected == ent.id
	local col = selected and col.white or alpha_white

	cam.Start3D2D(ent:GetPos() + Vector(0,-2,90), Angle(0, 90, 90), .2)
		surface.DisableClipping(true)
			draw.DrawText(ent.data.name, 'ui_header.l', 0, 0, col, TEXT_ALIGN_CENTER)
		surface.DisableClipping(false)
	cam.End3D2D()
end

function PANEL:Clear()
	for i = 1, #self.ents do
		if IsValid(self.ents[i]) then
			self.ents[i]:Remove()
		end
	end

	self.ents = {}
	self.selected = 1
	self.selected_lerpto = 0
	self.lerp_pos = 0
end

function PANEL:SetDistance(num)
	self.distance = num
end

function PANEL:AddModel(mdl, data, select)
	local ent = self.mdl:AddModel(mdl)
	local id = table.insert(self.ents, ent)

	ent:SetTransmitWithParent(true)
	ent:SetMoveType(MOVETYPE_NONE)
	ent.data = data
	ent.id = id

	self.previous:SetVisible(true)
	self.next:SetVisible(true)

	if select or id == 1 then 
		self:Select(id-1)
	else 
		self:UpdateCircle(self.lerp_pos)
	end

	return ent
end

function PANEL:RemoveModel(id)
	local ent = table.remove(self.ents, id)
	if not IsValid(ent) then 
		return
	end

	ent:Remove()
	self:Select(0)
end

function PANEL:Select(id)
	local c = #self.ents
	local realid = math.abs(id)%(c == 0 and 1 or c)

	self.selected_lerpto = id
	self.selected = (realid == 0 and 0 or realid) + 1

	if id < 0 then
		local id = math.abs((self.selected-c)-2)
		self.selected = id > #self.ents and 1 or id
	end

	if self.ents[self.selected] then
		self.json = string.Replace(util.TableToJSON(self.ents[self.selected].data or {}), ',', ',\n')
	end

	self:OnSelected(self.selected, self.ents[self.selected])
	return self
end

function PANEL:Change(dir)
	if #self.ents < 2 then 
		return
	end

	local id = (self.selected_lerpto or 0) + dir
	self:Select(id)
	return self
end

function PANEL:Next()
	self:Change(1)
	return self
end

function PANEL:Previous()
	self:Change(-1)
	return self
end

function PANEL:OnSelected(id, ent)
end

function PANEL:Think()
	if not self.mdl then 
		return 
	end

	if self.lerp_pos ~= self.selected_lerpto then 
		self.lerp_pos = Lerp((FrameTime()/1) * 3, self.lerp_pos, self.selected_lerpto)
		self:UpdateCircle(self.lerp_pos)
	end
end

function PANEL:UpdateCircle(offset)
	offset = offset or 0

	local count = #self.ents
	for i = 1, count do
		local ent = self.ents[i]
		if IsValid(ent) then
			local rad = math.rad(360*((i-offset-1)/count))
			local x, y = self.distance * math.cos(rad), self.distance * math.sin(rad)

			ent:SetPos(Vector(x,y,0))
		end
	end
end

function PANEL:PerformLayout(w, h)
	if self.previous then 
		self.previous:SetPos(w*.2, h*.5)
	end
	if self.next then 
		self.next:SetPos(w*.8, h*.5)
	end
end
vgui.Register('ss_modelwheel', table.Copy(PANEL), 'ss_panel')