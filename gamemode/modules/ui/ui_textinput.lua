local PANEL = {}

function PANEL:Init()
	self.BaseClass.Init(self)

	self:SetTall(30)
	self:SetFont "ui_label.r" 
	self:DockMargin(5,2,5,2)
	self:SetAllowNonAsciiCharacters(true)
	self:SetTextColor(col.white)
	self:SetCursorColor(col.white)
	self:SetHighlightColor(col.black)

	self.m_bLoseFocusOnClickAway = true
end

function PANEL:SetBackgroundColor(col)
    self.m_bgColor = col
end

function PANEL:AddParentButton(pnl)
	self.activatebutton = pnl
	return self
end

function PANEL:SetValidation(pattern)
	if not isstring(pattern) then
		return
	end
	self.pattern = pattern
	return self
end

function PANEL:MaxLength(num)
	if not isnumber(num) then
		return self.max_len
	end

	self.max_len = num
	return self
end

function PANEL:MinLength(min)
	if not isnumber(min) then
		return self.min_len
	end

	self.min_len = min
	return self
end

function PANEL:SetMinMax(min, max)
	self:MinLength(min)
	self:MaxLength(max)
	return self
end

function PANEL:SetText(str)
	self.BaseClass.SetText(self, str)
	return self
end

function PANEL:GetValue()
	return self:GetText()
end

function PANEL:TooLong()
	if self.number_validation and tonumber(self:GetText()) then
		return tonumber(self:GetText()) > (self.max_len or 512)
	else 
		return self:GetText():len() > (self.max_len or 512)
	end
end

function PANEL:TooShort()
	if self.number_validation and tonumber(self:GetText()) then 
		return tonumber(self:GetText()) < (self.min_len or 0)
	else 
		return self:GetText():len() < (self.min_len or 0)
	end
end

function PANEL:SetNumberInput()
	self:SetValidation '%d+'
	self.number_validation = true
	return self
end

function PANEL:ResolveValidation()
	if self:TooLong() or self:TooShort() then
		self.errorText = self:TooLong() and Format("Maximum of %i characters required", self.max_len or 255) or Format("Minimum of %i characters required", self.min_len or 0)
		return false
	else
		self.errorText = nil
	end

	if not self.pattern then
		return true
	end

	local isValid = string.match(self:GetText() or "", self.pattern)
	if isValid then
		self.errorText = nil
	else
		self.errorText = Format("Text must match the pattern: %s", self.pattern)
	end

	return isValid
end

function PANEL:RemoveValidation()
	self.pattern = nil
	return self
end

function PANEL:OnKeyCode(code)
	if code == KEY_ENTER then
		if IsValid(self.activatebutton) then
			self.activatebutton.DoClick(self.activatebutton)
		end
	end
end

function PANEL:OnTextChanged()
	local valid = self:ResolveValidation()
	if valid then
		if self._OnValid then 
			self:_OnValid()
		end
	elseif self._OnInvalid then
		self:_OnInvalid()
	end
end

function PANEL:IsValid()
	return self:ResolveValidation()
end

function PANEL:OnValid(f)
	self._OnValid = f
	return self
end

function PANEL:OnInvalid(f)
	self._OnInvalid = f
	return self
end

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'TextInput', self, w, h)
	return false
end

function PANEL:PaintOver(w, h)
	derma.SkinHook('Paint', 'TextInputOver', self, w, h)
end
vgui.Register("ss_textinput", PANEL, 'DTextEntry')
