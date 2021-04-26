local PANEL = {}
local barColor = Color(25,25,25,200)

function PANEL:Init()
	self.Abilities = {}

	self:SetTitle ''
	self:SetSize(64, 64)
	self:SetPos((ScrW()-64)/2, ScrH() - 68)
	self:SetBackgroundColor(barColor)
	self:SetBorderColor(col.grey)
	self:DockPadding(0,0,0,0)

	self:AddPanel('ss_grid', function(grid)
		grid:Dock(FILL)
		grid:DockMargin(0,0,0,0)
		self.grid = grid
	end)

	self.close:Remove()
end

function PANEL:AddAbility(ability)
	if IsValid(self.Abilities[ability.id]) then
		self.Abilities[ability.id]:Populate(ability)
		return
	end

	self:AddPanel('ss_ability', function(pnl)
		pnl:Dock(LEFT)
		pnl:SetWide(64)
		pnl:DockMargin(1, 0, 1, 0)
		pnl:Populate(ability)

		self.Abilities[ability.id] = pnl
	end)

	local abilityCount = table.Count(self.Abilities)
	self:SetWide((64 * abilityCount) + (2 * abilityCount))
	self:CenterHorizontal()
end

function PANEL:RemoveAbility(ability)
	if IsValid(self.Abilities[ability.id]) then
		self.Abilities[ability.id]:Remove()
	end
end

function PANEL:Paint()
end
vgui.Register('ss_abilities', PANEL, 'ss_window')

local PANEL = {}

function PANEL:Init()
	self:SetBackgroundColor(Color(200, 200, 200, 200))
	self:SetBorderColor(col.grey)

	self.StartLetter = 'A'

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
	self.StartLetter = ability.name[1]
	self.name:SetText(ability.name)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, self.m_bgColor)
	draw.DrawText(self.StartLetter, 'ui_header.l', w/2, 5, col.white, TEXT_ALIGN_CENTER)
end

function PANEL:PerformLayout(w, h)
	if IsValid(self.image) then
		self.image:SetSize(w, h)
	end
end
vgui.Register('ss_ability', PANEL, 'ss_panel')