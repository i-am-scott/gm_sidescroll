local PANEL = {}

function PANEL:Init()
	self:SetTall(30)
	self:DockPadding(0,0,0,0)
	self:DockMargin(5,5,5,5)
	self:SetBackgroundColor(col.transparent)

	self:AddPanel('ss_textinput', function(s)
		s:DockMargin(0,0,0,0)
		s:Dock(FILL)
		s:SetText(0)
		s:SetNumberInput()
		s:OnInvalid(function(me)
			local val = math.Clamp(self:GetValue(), me:MinLength() or 0, me:MaxLength() or 0)
			me:SetText(val or 0)
		end)
		s.Paint = function(pnl, w, h)
			derma.SkinHook('Paint', 'NumberInput', pnl, w, h)
			return false
		end
		self.input = s
	end)
end

function PANEL:Change(amount)
	local num = (self:GetValue() or 0) + amount
	self:SetValue(num)
end

function PANEL:SetValue(i)
	if tonumber(i) then 
		self.input:SetText(i)
	end
	return self
end

function PANEL:SetMinMax(min, max)
	self.input:SetMinMax(min, max)
	return self
end

function PANEL:MinLength(min)
	self.input:MinLength(min)
	return self
end

function PANEL:MaxLength(max)
	self.input:MaxLength(max)
	return self
end

function PANEL:GetValue()
	return tonumber(self.input:GetText()) or 0
end

function PANEL:SetInputWidth(w)
	self.input_width = w
	self.input:Dock(NODOCK)
	self.input:SetWide(w <= 1 and self:GetWide() * w or w)
	return self
end

function PANEL:PerformLayout(w, h)
	if self.input_width and IsValid(self.input) then 
		self.input:SetWide(self.input_width <= 1 and w * self.input_width or self.input_width)
	end
end
vgui.Register("ss_numberinput", table.Copy(PANEL), "ss_panel")