ss.abilities = ss.abilities or {}

local ABILITY = {}
ABILITY.__index = ABILITY

local abilities = {}
local abilities_mapped = {}

function ABILITY:SetName(str)
    self.name = str
    return self
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

function ABILITY:Think(func)
    self.Think = func
    return self
end

function ss.abilities.Create(id)
    local t = setmetatable({id = id}, ABILITY)

    t.internalid = table.insert(abilities_mapped, t)
    abilities[id] = t
    return t
end

function ss.abilities.Get(id, internal)
    return internal and abilities_mapped[id] or abilities[id]
end