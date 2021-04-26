DEFINE_BASECLASS 'base_anim'

ENT.PrintName = 'Jump Pad'
ENT.Type = 'anim'
ENT.Category = 'Sidescroll'
ENT.Spawnable = true
ENT.Model = Model 'models/props_2fort/groundlight003.mdl' -- 'models/props_farm/haypile001.mdl'
ENT.PulseVelocity = Vector(0,0,700)
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    self:SetModel(self.Model)

	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	if SERVER then
        self:SetCollisionBounds(Vector(-35, -35, 0), Vector(35, 35, 35))
        self:SetTrigger(true)
    end
end