local PANEL = {}
local barColor = Color(25,25,25,200)

function PANEL:Init()
	self:SetSize(ScrH(), ScrW())
	self:SetPos(0,0)
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	self:Populate()
end

function PANEL:Paint()
end
vgui.Register('ss_hud', PANEL, 'ss_base')

RunConsoleCommand('ss_hud')