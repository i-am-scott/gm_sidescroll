AddCSLuaFile()

ENT.Base = 'ent_pickup'
ENT.PrintName = 'Health Pickup'
ENT.Category = 'Sidescroll'
ENT.Spawnable = true
ENT.Model = 'models/items/medkit_small.mdl'

function ENT:PlayerPickup(pl)
    local hp, maxhp = pl:Health(), pl:GetMaxHealth()
    if hp < maxhp then
        pl:SetHealth(math.min(hp+100, maxhp))
        return true
    end
end