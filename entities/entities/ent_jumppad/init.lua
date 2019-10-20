AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

ENT.JumpSound = Sound 'passtime/ball_smack.wav'

function ENT:StartTouch(pl)
    if not IsValid(pl) or not pl:IsPlayer() then
        return
    end

    local obj = pl:GetPhysicsObject()
    if IsValid(obj) then
        local movevel = obj:GetVelocity()
        pl:SetVelocity(self.PulseVelocity + Vector(0,0, movevel.z < 0 and (-1 * movevel.z) or 0))
        pl:EmitSound(self.JumpSound)
    end
end

function ENT:Setup(data)
    self.PulseVelocity = data.PulseVelocity or self.PulseVelocity
end