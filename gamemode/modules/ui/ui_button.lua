local PANEL = {}

function PANEL:Init() 
    self.OnClick = {}
    self.LastClick = {}
    self.ClickTime = 0.2
	self.deleteonclose = true

	self.lbl = vgui.Create('DLabel', self)
	self.lbl:SetContentAlignment(5)
	self.lbl:SetColor(col.ui_button_text)
	self.lbl:SetFont 'ui_button.r'
	self.lbl:SetText 'Button'
	self.lbl:Dock(FILL)

	self:DockMargin(5,10,5,10)
	self:DockPadding(0,0,0,0)
	self:SetSize(100,30)
	self:SetCursor('hand')
end

function PANEL:SetNumerical(b, perc)
	self.numberical = b
	self.numberperc = perc or .7

	if b then
		self:AddPanel('ss_textinput', function(inp) 
			inp:Dock(LEFT)
			inp:SetWide(0)
			inp:SetText '0'
			self.numbers = inp
		end)
	elseif not b and IsValid(self.numbers) then
		self.numbers:Remove()
	end
end

function PANEL:OnMousePressed(key)
	if self.disabled then
		return
	end

	local double = self.LastClick[key] and self.LastClick[key] + self.ClickTime > CurTime() or false
	if self.numberical and input.IsKeyDown(KEY_LSHIFT) and key == MOUSE_LEFT and IsValid(self.numbers) then
		self.numbers:SizeTo(self:GetWide() * self.numberperc, self:GetTall(), .5, 0)
		return
	end

	local number = 0
	if self.OnClick[key] then
		if IsValid(self.numbers) then
			self.numbers:SizeTo(0, self.numbers:GetTall(), .2, 0)
			number = tonumber(self.numbers:GetText())
		end
		if self.snd_click then
			surface.PlaySound(self.snd_click)
		end
		self.OnClick[key](self, key, double, number)
	end

	self.LastClick[key] = CurTime()
end

function PANEL:SetContentAlignment(id)
	self.lbl:SetContentAlignment(id)
	return self
end

function PANEL:SetDoubleClickTimer( max_delay )
	self.ClickTime = max_delay
	return self
end

function PANEL:LeftClick(c)
	self.OnClick[MOUSE_LEFT] = c
	return self
end

function PANEL:RightClick(c)
	self.OnClick[MOUSE_RIGHT] = c
	return self
end

function PANEL:SetText(f)
	self.lbl:SetText(f)
	return self
end

function PANEL:SetTextColor(c)
	self.lbl:SetTextColor(c)
	return self
end

function PANEL:SetSelectedBackgroundColor(col)
	self.selectedbg = col
	return self
end

function PANEL:OnSelected(func)
	self.select = func
end

function PANEL:OnDeselected(func)
	self.deselected = func
end

function PANEL:Select(b)
	self.selected = b

	if b and self.snd_selected then
		surface.PlaySound(self.snd_selected)
	end

	if b and self.select then
		self.select(self)
	elseif not b and self.deselected then
		self.deselected(self)
	end
end

function PANEL:SetFont(f)
	self.lbl:SetFont(f)
	return self
end

function PANEL:SetDisabled(b)
	self.disabled = b
	return self
end

function PANEL:SetSoundSelected(snd)
	self.snd_selected = snd
	return self
end

function PANEL:SetSoundHover(snd)
	self.snd_hover = snd
	return self
end

function PANEL:SetSoundClicked(snd)
	self.snd_click = snd
	return self
end

function PANEL:SetDeleteOnClose(b)
	self.deleteonclose = b
	return self
end

function PANEL:GetDeleteOnClose()
	return self.deleteonclose
end

function PANEL:SetClose(p)
	self.color_bg = col.ui_close_bg
	self:SetFont 'ui_button_close'
	self:SetText ''
	self:LeftClick(function(s)
		local pnl = IsValid(p) and p or s:GetParent()
		local hide = not pnl:GetDeleteOnClose()

		if hide then 
			pnl:Hide()
		else
			pnl:Remove()
		end
	end)
	return self
end

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'Button', self, w, h)
end
vgui.Register('ss_button', PANEL, 'ss_base')

vgui.Register('ss_button_animated', {
	Paint = function(self, w, h) 
		derma.SkinHook('Paint', 'ButtonAnimated', self, w, h) 
	end
}, 'ss_button')

vgui.Register('ss_button_image', {
	Init = function(self)
		self.lbl:Remove()
		self:AddPanel('DImage', function(img)
			img:SetSize(32, 32)
			img:Center()
			img:SetKeyboardInputEnabled(false)
			img:SetMouseInputEnabled(false)
			self.img = img
		end)
	end,
	SetMaterial = function(self, img)
		self.img:SetMaterial(img)
	end,
	SetTextColor = function(self, col)
		self.img:SetBackgroundColor(col)
		return self
	end,
	PerformLayout = function(self, w, h)
		if IsValid(self.img) then
			self.img:SetPos((w - 32)/2, (h - 32)/2)
		end
	end	
}, 'ss_button')