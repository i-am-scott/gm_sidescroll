ss.abilities = ss.abilities or {}

local ABILITY = {}
ABILITY.__index = ABILITY

local abilities = {}
local abilities_mapped = {}

function ABILITY:SetName(str)
    self.name = str
    return self
end

function ABILITY:AddPlayer(pl)
	self.Players[pl] = {
		Active = false,
		NextUse = 0,
	}
end

function ABILITY:SetActive(pl, b)
	self.Players[pl].Active = b

	if b then
		self:OnSelected(self, pl)
	else
		self:OnDeselected(self, pl)
	end
end

function ABILITY:SetPlayerCooldown(pl)
	self.Players[pl].NextUse = CurTime() + self:GetCooldown()
end

function ABILITY:IsPlayerInCooldown(pl)
	return (self.Players[pl].Cooldown or 0) > CurTime()
end

function ABILITY:CanPlayerUse(pl)
	return not self:IsPlayerInCooldown(pl) // Add use times here.
end

function ABILITY:RemovePlayer(pl)
	self.Players[pl] = nil
end

function ABILITY:GetName()
    return self.name
end

function ABILITY:SetDescription(description)
    self.description = description
    return self
end

function ABILITY:GetDescription()
    return self.description
end

function ABILITY:SetCooldown(cd)
    self.cooldown = cd
    return self
end

function ABILITY:GetCooldown()
    return self.cooldown
end

function ABILITY:SetIcon(ico)
    self.icon = ico
    return self
end

function ABILITY:GetIcon()
    return self.icon
end

function ABILITY:SetResourceCost(num)
    self.resource = num
    return self
end

function ABILITY:GetResourceCost()
    return self.resource
end

function ABILITY:OnSelected(func)
    self.Selected = func
    return self
end

function ABILITY:OnDeselected(func)
    self.Deselect = func
    return self
end

function ABILITY:OnRequested(func)
    self.Requested = func
    return self
end

function ABILITY:OnExit(func)
    self.Exit = func
    return self
end

function ABILITY:OnThink(func)
    self.Think = func
    return self
end

function ABILITY:Think(pl)

end

function ss.abilities.Create(id)
    local t = setmetatable({
		id = id,
		Players = {}
	}, ABILITY)

    t.internal = table.insert(abilities_mapped, t)
    abilities[id] = t
    return t
end

function ss.abilities.Get(id, internal)
    return internal and abilities_mapped[id] or abilities[id]
end

hook('Think', 'ss.abilities.Think', function()
	for i = 1, #abilities_mapped do
		local ability = abilities_mapped[i]

		if table.Count(ability.Players) > 0 then
			for pl, _ in pairs(ability.Players) do
				ability:Think(pl)
			end
		end
	end
end)