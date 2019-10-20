local slideDuration = 1
local slideCooldown = 1
local duckTrapped = false
local slideButton = IN_DUCK
local EMPTYVEC = Vector()

sound.Add({
    name = 'player.sliding'
})

nw.Register 'ss.player.sliding'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

function PLAYER:SetCanSlide(b)
    self.CanSlide = true
end

function PLAYER:CanSlide()
    return true
end

function PLAYER:IsSliding()
    return self:GetNetVar('ss.player.sliding')
end

function PLAYER:SetSliding(b)
    if SERVER then
		self:SetNetVar('ss.player.sliding', b)
	end
end

hook('SetupMove', 'sliding', function(pl, mv, cmd)
    if not pl:CanSlide() then
		if pl:IsSliding() then
			pl:SetSliding(false)
		end
        return 
    end

	local vel = mv:GetVelocity()
	local ducking = mv:KeyDown(slideButton)
	local grounded = pl:IsOnGround()
	local sliding = pl:IsSliding()

	if vel ~= EMPTYVEC and vel:Length2D() > 225 and grounded and ducking and not duckTrapped and not sliding and (not pl.nextslide or pl.nextslide < CurTime()) then
        pl.slidevec = mv:GetMoveAngles():Forward()
		pl.sliderduration = CurTime() + slideDuration
		pl:SetSliding(true)
	elseif ((not grounded or not ducking) and sliding) or (sliding and pl.sliderduration and pl.sliderduration < CurTime()) or (sliding and not pl:Alive()) then
		pl.slidevec = nil
		pl.sliderduration = nil
		pl.nextslide = CurTime() + slideCooldown 
		pl:SetSliding(false)
	end

	if sliding then
		mv:SetButtons(IN_DUCK)
	end

	duckTrapped = ducking
end)

hook('Move', 'sliding', function(pl, mv) 
	if pl:IsSliding() and pl.slidevec then
		local ang = mv:GetMoveAngles()
		local vel = mv:GetVelocity()

		vel = vel + pl.slidevec * (pl:IsOnGround() and 100 or 0)
		mv:SetVelocity(vel)
	end
end)

hook('CalcMainActivity', 'sliding', function(pl)
	if pl:IsSliding() then
		local anim = pl:LookupSequence 'zombie_slump_idle_02'
		if anim and anim > 0 then 
			return ACT_MP_RUN, anim
		end
	end
end)