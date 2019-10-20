local PANEL = {}

function PANEL:Init()
	self.outline = col.black

	self:SetSize(400, 150)
	self:SetBackgroundColor(col.ui_header)
	self:DockPadding(1, 1, 1, 1)
	self:SetMouseInputEnabled(false)

	self:AddPanel('ss_label', function(pnl)
		pnl:Dock(FILL)
		pnl:SetContentAlignment(4)
		pnl:SetMouseInputEnabled(false)
		pnl:SetTextColor(Color(200, 200, 200))
		self.txt = pnl
	end)

	self:SetVisible(false)
end

function PANEL:SetText(str)
	surface.SetFont(self.txt:GetFont())
	local w, h = surface.GetTextSize(str)

    self.txt:SetText(str)
	self:SetWide(w * 1.4)
	self:SetVisible(true)
end

function PANEL:Think()
	local mx, my = gui.MousePos()

	if IsValid(self.parent) and self.parent:IsVisible() then
		local x1, y1 = self.parent:LocalToScreen(0,0)
		local x2, y2 = self.parent:GetWide() + x1, self.parent:GetTall() + y1

		if mx < x1 or mx > x2 or my < y1 or my > y2 then
			self:Remove()
			return
		end
	else
		self:Remove()
		return
	end

	self:SetPos(mx + 25, my)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(col.grey_dark)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(col.grey_light)
	surface.DrawOutlinedRect(0, 0, w, h)
end
vgui.Register('ss_tooltip', PANEL, 'ss_panel')