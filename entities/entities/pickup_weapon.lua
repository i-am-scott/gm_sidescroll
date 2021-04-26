AddCSLuaFile()

ENT.Base = 'ent_pickup'
ENT.PrintName = 'Weapon Pickup'
ENT.Category = 'Sidescroll'
ENT.Spawnable = true
ENT.Model = 'models/items/tf_gift.mdl'

ENT.Weapons = {
    'weapon_pistol',
    'weapon_ar2',
    'weapon_smg1',
    'weapon_rpg',
    'weapon_crossbow',
	'weapon_fists'
}

function ENT:PlayerPickup(pl)
	pl:StripWeapons()

    local class = self.Weapons[math.random(#self.Weapons)]
    pl:Give(class)
    pl:SelectWeapon(class)
    return true
end