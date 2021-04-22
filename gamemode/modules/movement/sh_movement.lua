nw.Register('ss.JumpPad')
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetLocalPlayer()

local switched
local dirright = Vector(1,0,0)

function PLAYER:InJumpPad()
	return self:GetNetVar('ss.JumpPad')
end

function PLAYER:SetJumpPad(b)
	return self:SetNetVar('ss.JumpPad', b)
end

function PLAYER:IsLookingUp()
	return self:GetForward().z > 0
end

function PLAYER:IsFacingRight()
	return self:GetForward().x > 0
end

hook('SetupMove', function(pl, mv, cmd)
    local angle = mv:GetAngles()
    local forward = mv:GetForwardSpeed()
    local sidespeed = mv:GetSideSpeed()
    local newmoveang = angle:SnapTo('y', 180)

    mv:SetMoveAngles(newmoveang)
    mv:SetForwardSpeed(newmoveang.y == -180 and -sidespeed or sidespeed)
    mv:SetSideSpeed(0)

	if pl:InJumpPad() and mv:KeyDown(IN_JUMP) and not pl:KeyDownLast(IN_JUMP) and not pl:OnGround() then
		pl:SetVelocity(pl:GetAimVector() * 500)

		if SERVER then
			pl:SetJumpPad(false)
		end

		local ef = EffectData()
		ef:SetEntity(pl)
		ef:SetOrigin(pl:GetPos())
		ef:SetScale(5)
		ef:SetMagnitude(4)

		util.Effect('TeslaZap', ef, false, true)
	end
end)

hook('ShouldCollide', function(e1, e2)
    return (e1:IsPlayer() and e2:IsPlayer()) and false
end)

if SERVER then
	hook('OnPlayerHitGround', 'ss.DisableJumpPad', function(pl)
		pl:SetJumpPad(false)
	end)
end