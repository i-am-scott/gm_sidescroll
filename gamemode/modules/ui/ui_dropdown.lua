local PANEL = {}
Derma_Hook(PANEL, 'Paint', 'Paint', 'Dropdown')

function PANEL:Init()
	self.outline = true
	self:Clear()
	self:LeftClick(function(s) 
		if self:IsMenuOpen() then
			self:CloseMenu()
        else  
            self:OpenMenu()
		end
	end)

	self.lbl:SetContentAlignment(4)
	self.lbl:SetTextInset(10,0)
end

function PANEL:AddOption(id, options, style, select)
	local dat = {data = options or {}}

	if not dat.data.name then 
		dat.data.name = id 
	end

	if istable(style) then 
		dat.style = style
	end

	local i = table.insert(self.options, dat)
	self.mapped_options[id] = i

	if style == true or select == true then 
		self:ChooseOption(i)
	end
	return self
end

function PANEL:Clear()
	self:SetText ''
	self.options = {}
	self.mapped_options = {}
	self.spacers = {}
	self.selected = nil

	if self.menu then
		self.menu:Remove()
		self.menu = nil
	end
end

function PANEL:GetOption(id)
	return self.options[self.mapped_options[id]]
end

function PANEL:GetOptionText( id )
	return self.options[self.mapped_options[id]].name
end

function PANEL:GetOptionData( id )
	return self.options[self.mapped_options[id]].data
end

function PANEL:GetOptionTheme(id)
	return self.options[self.mapped_options[id]].style
end

function PANEL:GetSelected()
	return self.options[self.selected] and self.options[self.selected].data
end

function PANEL:GetSelectedID()
	return self.selected
end

function PANEL:AddSpacer(id)
	self.spacers[id or table.Count(self.options)] = true
	return self
end

function PANEL:ChooseOption(index)
	if self.menu then
		self.menu:Remove()
		self.menu = nil
	end

	local info = self.options[index]

	self.selected = index
	self:SetText(info.data.name)
	self:SetTextColor(info.style and info.style.text or col.white)

	if self._OnSelect then
		self:_OnSelect(index, info.data, info.style)
	end
end

function PANEL:OnSelect(func)
	self._OnSelect = func
	return self
end

function PANEL:IsMenuOpen()
	return IsValid(self.menu) and self.menu:IsVisible()
end

function PANEL:OpenMenu()
	if #self.options == 0 then 
		return 
	end

	if IsValid(self.menu) then
		self.menu:Remove()
		self.menu = nil
	end

	self.menu = DermaMenu(false)
	self.menu:SetSkin 'SS_SKIN'

	local i = 1
	for id, option in ipairs(self.options) do
		local option_menu = self.menu:AddOption(option.data.name, function() 
			if not IsValid(self) then 
				return 
			end
			self:ChooseOption(id) 
		end)

		local style = option.style
		option_menu:SetFont(style and style.font or 'ui_button.r')
		option_menu:SetTextColor(style and style.text or col.white)

		if style then 
			option_menu.color_bg = style.bg or nil 
			option_menu.color_highlight_bg = style.highlight or nil
			if style.icon then 
				option_menu:SetIcon(style.icon)
			end
		end

		if self.spacers[i] then 
			self.menu:AddSpacer()
		end
		i = i + 1
	end

	local x, y = self:LocalToScreen(0, self:GetTall())
	self.menu:SetMinimumWidth(self:GetWide())
	self.menu:Open(x, y, false, self)
    
    timer.Simple(0, function()
        if IsValid(self.menu) then
            self.menu:RequestFocus()
        end
    end)
end

function PANEL:OnRemove()
    self:CloseMenu()
end

function PANEL:CloseMenu()
	if IsValid(self.menu) then
		self.menu:Remove()
	end
end
vgui.Register('ss_dropdown', PANEL, 'ss_button')