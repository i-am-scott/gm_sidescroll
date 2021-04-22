local PANEL = {}
local barColor = Color(25,25,25,200)

function PANEL:Init()
	self.Abilities = {}

	self:SetTitle 'Character Abilities'
	self:SetSize(400, 120)
	self:SetPos((ScrW()-400)/2, ScrH() - 125)
	self:SetBackgroundColor(barColor)
	self:SetBorderColor(col.grey)

	self:AddPanel('ss_grid', function(grid)
		grid:Dock(FILL)
		self.grid = grid
	end)

	self.close:Remove()
end

function PANEL:AddAbility(ability)
	self:RemoveAbility(ability.id)

	self:AddPanel('ss_ability', function(pnl)
		pnl:Dock(LEFT)
		pnl:DockMargin(0, 0, 0, 0)
		pnl:Populate(ability)

		self.Abilities[ability.id] = pnl
	end)
end

function PANEL:RemoveAbility(ability)
	if IsValid(self.Abilities[ability.id]) then
		self.Abilities[id]:Remove()
	end
end
vgui.Register('ss_abilities', PANEL, 'ss_window')

local PANEL = {}

function PANEL:Init()
	self:SetBackgroundColor(col.transparent)
	self:SetBorderColor(col.grey)

	self:AddPanel('DImage', function(pnl)
		self.image = pnl
	end)

	self:AddPanel('ss_label_small', function(lbl)
		lbl:SetText 'Ability Name'
		lbl:Dock(BOTTOM)
		lbl:SetContentAlignment(5)
		self.name = lbl
	end)
end

function PANEL:Populate(ability)
	self.name:SetText(ability.name)
end

function PANEL:PerformLayout(w, h)
	if IsValid(self.image) then
		self.image:SetSize(w, h)
	end
end
vgui.Register('ss_ability', PANEL, 'ss_panel')