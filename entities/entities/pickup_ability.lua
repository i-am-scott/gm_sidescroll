AddCSLuaFile()

ENT.Base = 'ent_pickup'
ENT.PrintName = 'Ability Pickup'
ENT.Category = 'Sidescroll'
ENT.Spawnable = true
ENT.Model = 'models/items/ammopack_large_bday.mdl'

function ENT:PlayerPickup(pl)
	ss.abilities.Add(pl, 'flyattack')
    return true
end