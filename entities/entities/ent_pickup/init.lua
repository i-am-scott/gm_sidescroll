AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

ENT.PickupSound = Sound 'passtime/ball_smack.wav'
ENT.Cooldown = 5

function ENT:StartTouch(pl)
	if self:GetNoDraw() then
		return
	end

    if IsValid(pl) and pl:IsPlayer() then
        if self:PlayerPickup(pl) then
            self:EmitSound(self.PickupSound)
            self:SetNoDraw(true)
			self.NextShowTime = CurTime() + self.Cooldown
        end
    end
end

function ENT:PlayerPickup(pl)
    return true
end

function ENT:Think()
	if self:GetNoDraw() and self.NextShowTime < CurTime() then
		self:SetNoDraw(false)
	end
end