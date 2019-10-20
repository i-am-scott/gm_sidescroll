AddCSLuaFile()

ENT.Base = 'ent_pickup'
ENT.PrintName = 'Ammo Pickup'
ENT.Category = 'Sidescroll'
ENT.Spawnable = true
ENT.Model = 'models/items/ammopack_large_bday.mdl'

function ENT:PlayerPickup(pl)
    pl:GiveAmmo(100, 'ar2')
    pl:GiveAmmo(100, 'SMG1')
    pl:GiveAmmo(100, 'rockets')
    return true
end