local PANEL = {
	Paint = function()
	end
}

function PANEL:Init()
	self:DockPadding(0, 0, 0, 0)
	self:DockMargin(0, 0, 0, 0)

	self.items = {}
	self.selected = nil

	self:AddPanel('ss_panel', function(strip)
		strip:SetTall(40)
		strip:Dock(TOP)
		strip:DockPadding(0, 0, 0, 0)
		strip:DockMargin(0, 0, 0, 0)
		strip:SetBackgroundColor(col.transparent)
		self.strip = strip
	end)

	self:AddPanel('ss_panel', function(container)
		container:Dock(FILL)
		container:DockPadding(0, 0, 0, 0)
		container:DockMargin(0, 0, 0, 0)
		container.Paint = function() end
		self.container = container
	end)
end

function PANEL:ClearTabs()
	self.items = {}
	self.selected_item = nil

	self.strip:Clear()
	self.container:Clear()
end

local grey = Color(200, 200, 200)
function PANEL:AddPage(name, panel, cbk)
	if not panel then
		return
	end

	cbk = cbk or function() end

	self.strip:AddPanel('ss_button', function(btn)
		btn:Dock(LEFT)
		btn:SetTextColor(grey)
		btn:SetBackgroundColor(col.transparent)
		btn:SetText(name)
		btn:SetFont 'ui_header.r'

		surface.SetFont('ui_header.r')
		local w, h = surface.GetTextSize(name)

		btn:SetWide(w+10)
		btn:SetContentAlignment(5)
		btn.Paint = function() end
		btn:LeftClick(function(s)
			self:SelectItem(s.id)
		end)

		btn:OnSelected(function(s) 
			s:SetTextColor(col.white)
		end)

		btn:OnDeselected(function(s) 
			s:SetTextColor(col.grey)
		end)

		if ispanel(panel) then
			local id = self:AddInternal(name, btn, panel).id
			if id == 1 then
				self:SelectItem(id)
			end
			cbk(id, btn, panel)
		elseif isstring(panel) then
			ss.ui.Create(panel, function(panel)
				local id = self:AddInternal(name, btn, panel).id
				if id == 1 then
					self:SelectItem(id)
				end
				cbk(id, btn, panel)
			end)
		end
	end)
end

function PANEL:AddInternal(name, btn, panel)
	local item = {name = name, button = btn, page = panel}
	local id = table.insert(self.items, item)

	item.id = id
	item.button.id = id
	item.page.id = id

	panel:SetVisible(false)
	panel:SetAlpha(0)
	panel:SetParent(nil)

	self:OnPageAdded(id, btn, panel)
	return item
end

function PANEL:SelectItem(id)
	if self.next and self.next > CurTime() then
		return
	end

	if self.selected and self.selected.id == id then
		return
	end

	local item = self.items[id]
	if not item then
		return
	end

	local selected = self.selected
	if selected then
		selected.button:Select(false)
		selected.button:SetTextColor(grey)
		selected.page:Dock(NODOCK)
		selected.page:AlphaTo(0, .05, 0, function(_, s)
			s:SetVisible(false)
			s:SetParent(nil)
		end)
	end

	item.button:Select(true)
	item.page:SetParent(self.container)
	item.page:Dock(FILL)
	item.page:SetVisible(true)
	item.page:AlphaTo(255, .05, 0)

	self:OnSelected(item.id, item.btn, item.page)
	self.selected = item
	self.next = CurTime() + .2
end

function PANEL:RemoveTab(id)

end

function PANEL:GetSelected()
	return self.selected
end

function PANEL:OnPageAdded(id, btn, page)
end

function PANEL:OnSelected(id, btn, page)
end
vgui.Register('ss_tabs', table.Copy(PANEL), 'ss_panel')

local PANEL = {}
function PANEL:Init()
	self:DockPadding(0, 0, 0, 0)
	self:DockMargin(0, 0, 0, 0)

	self.strip:Dock(LEFT)
	self.strip:SetWide(64)
	self.strip:DockPadding(0,0,0,0)
	self.strip:DockMargin(0,0,0,0)
	self.strip:SetBackgroundColor(col.grey_dark)

	self:SetMode(LEFT, 64)
end

function PANEL:SetMode(mode, size)
	self.mode = mode == LEFT and LEFT or mode == TOP and TOP or LEFT
	self.size = size or 64
	self.strip:Dock(self.mode)

	if self.mode == LEFT then
		self.strip:SetWide(self.size)
	else
		self.strip:SetTall(self.size)
	end

	return self
end

function PANEL:AddPage(name, icon, panel, callback)
	if not panel then 
		return 
	end

	local mode = self.mode or LEFT
	self.strip:AddPanel('ss_button_image', function(btn)
		btn:DockPadding(0,0,0,0)
		btn:DockMargin(0,0,0,0)
		btn:SetMaterial(icon)
		btn:SetSelectedBackgroundColor(col.grey_light)

		if mode == LEFT then
			btn:SetTall(self.size)
			btn:Dock(TOP)
		else
			btn:SetWide(self.size)
			btn:Dock(LEFT)
		end

		if isfunction(panel) then
			btn:LeftClick(panel)
			if callback then
				callback(id, btn, panel)
			end
			return
		else
			btn:LeftClick(function(s)
				self:SelectItem(s.id)
			end)
		end

		if ispanel(panel) then
			local id = self:AddInternal(name, btn, panel).id
			if id == 1 then
				self:SelectItem(id)
			end
			if callback then
				callback(id, btn, panel)
			end
		elseif isstring(panel) then
			ss.ui.Create(panel, function(panel)
				local id = self:AddInternal(name, btn, panel).id
				if id == 1 then
					self:SelectItem(id)
				end
				if callback then
					callback(id, btn, panel)
				end
			end)
		end
	end)
end
vgui.Register('ss_tabs_icon', PANEL, 'ss_tabs')

