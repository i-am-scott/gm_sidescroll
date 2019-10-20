AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

ENT.PickupSound = Sound 'passtime/ball_smack.wav'

function ENT:StartTouch(pl)
    if IsValid(pl) and pl:IsPlayer() then
        if self:PlayerPickup(pl) then
            self:EmitSound(self.PickupSound)
            self:Remove()
        end
    end
end

function ENT:PlayerPickup(pl)
    return true
end