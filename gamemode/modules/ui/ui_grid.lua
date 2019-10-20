local PANEL = {}

function PANEL:Init()
	self.x_space = 2
	self.y_space = 2
	self.autoheight = false
	self.items = {}
	self.contentheight = 0
end

function PANEL:AddItem(pnl, setup)
	local id = table.insert(self.items, pnl)
	pnl.id = id

	pnl:SetParent(self)
end

function PANEL:Setup(mw, mh)
	if not mw or not mh then
		mw, mh = self:GetSize()
	end

	local col = self.x_space
	local last_height = 0
	local height = self.y_space

	for i = 1, #self.items do
		local pnl = self.items[i]
		if not IsValid(pnl) then
			continue
		end

		local w, h = pnl:GetSize()
		if (col + w + self.x_space) > mw then
			height = height + last_height + self.y_space
			last_height = 0
			col = self.x_space
		end

		self.contentheight = height + last_height
		pnl:SetPos(col, height)

		col = col + w + self.x_space
		last_height = h > last_height and h or last_height
	end

	self.contentheight = self.contentheight == height and self.contentheight + last_height or self.contentheight

	if self.autoheight then
		self:SetTall(self.contentheight)
	end

	self:OnComplete(self.contentheight)
end

function PANEL:SetAutoHeight(b)
	self.autoheight = b
	return false
end

function PANEL:GetAutoHeight()
	return self.autoheight
end

function PANEL:RemoveItems()
	for _, v in pairs(self.items) do
		v:Remove()
	end
end

function PANEL:OnComplete(h)
end

function PANEL:PerformLayout(w, h)
	self:Setup(w, h)
end

function PANEL:Paint()

end
vgui.Register('ss_grid', PANEL, 'ss_panel')