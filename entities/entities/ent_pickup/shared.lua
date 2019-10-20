DEFINE_BASECLASS 'base_anim'

ENT.PrintName = 'Item Pickup'
ENT.Type = 'anim'
ENT.Category = 'Sidescroll'
ENT.Spawnable = true 
ENT.Model = Model 'models/props_farm/haypile001.mdl'

function ENT:Initialize()
    self:SetModel(self.Model)

	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	if SERVER then 
        self:SetCollisionBounds(Vector(-20, -20, 0), Vector(20, 20, 35))
        self:SetTrigger(true)
    end
end