local PANEL = {}

DEFINE_BASECLASS 'DLabel'

function PANEL:Init() 
	self:SetFont 'ui_label.r'
	self:SetTextColor(col.white)
	self:DockMargin(5,1,5,1)
end

function PANEL:DockMargin(l,t,r,b)
	BaseClass.DockMargin(self, l, t, r, b)
	return self
end

function PANEL:DockPadding(l,t,r,b)
	BaseClass.DockPadding(self, l, t, r, b)
	return self
end

function PANEL:SetWide(i)
	BaseClass.SetWide(self, i)
	return self
end

function PANEL:SetPos(x, y)
	BaseClass.SetPos(self, x, y)
	return self
end

function PANEL:SetFont(f)
	BaseClass.SetFont(self, f)
	return self
end

function PANEL:SetText(t)
	BaseClass.SetText(self, t)
	return self
end

function PANEL:SetTextColor(c)
	BaseClass.SetTextColor(self, c)
	return self
end

function PANEL:SizeToContents(s)
	BaseClass.SizeToContents(self, s)
	return self
end

function PANEL:SizeToContentsX(s)
	BaseClass.SizeToContentsX(self, s)
	return self
end

function PANEL:SizeToContentsY(s)
	BaseClass.SizeToContentsY(self, s)
	return self
end

function PANEL:SetContentAlignment(i)
	BaseClass.SetContentAlignment(self, i)
	return self
end

function PANEL:SetWrap(b)
	BaseClass.SetWrap(self, b)
	return self
end

function PANEL:SetAutoStretchVertical(b)
	BaseClass.SetWrap(self, b)
	return self
end

function PANEL:Dock(t)
	BaseClass.Dock(self,t)
	return self
end

function PANEL:Finish()
	return self:GetParent()
end
vgui.Register("ss_label", table.Copy(PANEL), "DLabel")

derma.DefineControl("ss_header", "", {
	Init = function(self)
		self:SetFont 'ui_header.l'
		self:SetTall(30)
		self:DockMargin(5,15,5,5)
	end
}, "ss_label")

derma.DefineControl("ss_subheader", "", {
	Init = function(self)
		self:SetFont 'ui_header.r'
		self:DockMargin(5,5,5,2)
	end
}, "ss_label")

derma.DefineControl("ss_label_small", "", {
	Init = function(self)
		self:SetFont 'ui_label.s'
	end
}, "ss_label")