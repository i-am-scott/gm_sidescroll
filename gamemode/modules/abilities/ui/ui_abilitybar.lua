local PANEL = {}
local barColor = Color(25,25,25,200)

function PANEL:Init()
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

function PANEL:PopulateAbilities()
end
vgui.Register('ss_abilities', PANEL, 'ss_window')

local PANEL = {}
function PANEL:Init()
	self:SetBackgroundColor(col.transparent)
	self:SetBorderColor(col.grey)
end
vgui.Register('ss_ability', PANEL, 'ss_panel')

RunConsoleCommand('ss_abilities')