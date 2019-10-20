local PANEL = {}
DEFINE_BASECLASS 'EditablePanel'

function PANEL:Init()
	self.ribbon = false
	self:DockPadding(5,5,5,5)
end

function PANEL:AddPanel(p,b)
	local ret = ss.ui.Create(p)
	if not IsValid(ret) then
		return self
	end

	ret:SetParent(self)
	if self.stacked then
		ret:Dock(TOP)
	end

	if isfunction(b) then
		b(ret,self)
	else
		return b and self or ret
	end
end

function PANEL:DockPadding(l, t, r, b)
	BaseClass.DockPadding(self, l, t, r, b)
	return self
end

function PANEL:DockMargin(l, t, r, b)
	BaseClass.DockMargin(self, l, t, r, b)
	return self
end

function PANEL:SetBorderColor(c)
	self.outline = true
	self.m_bdrColor = c
	return self
end

function PANEL:SetStacked()
	self.stacked = true 
	return self
end

function PANEL:SetBackgroundColor(c)
	self.m_bgColor = c
	return self
end

function PANEL:SetHoverColor(c)
	self.m_bghColor = c
	return self
end

function PANEL:SetSize(w, h)
	BaseClass.SetSize(self, w, h)
	return self
end

function PANEL:SetWide(w)
	BaseClass.SetWidth(self,w)
	return self
end

function PANEL:SetTall(t)
	BaseClass.SetHeight(self,t)
	return self
end

function PANEL:Dock(t)
	BaseClass.Dock(self,t)
	return self
end

function PANEL:SetPos(x, y)
	BaseClass.SetPos(self, x, y)
	return self
end

function PANEL:SetParent(p)
	BaseClass.SetParent(self, p)
	return self
end

function PANEL:Center()
	BaseClass.Center(self)
	return self
end

function PANEL:SetLoading(b, dur, str)
	self.loading = b
    self.loadingtext = str
	if dur then 
		self:SetLoadingTimer(dur)
	end
	self:SetCursor(b and 'hourglass' or 'none')
	return self
end

function PANEL:IsLoading()
	return self.loading
end

function PANEL:SetLoadingTimer(time)
    self.loadendtime = time + CurTime()
    self.loadtimeout = time
	timer.Simple(time, function() 
		if IsValid(self) then 
			self:SetLoading(false)
		end
	end)
end

function PANEL:AddSpacer()
	self:AddPanel('DPanel', function(s) 
		s:Dock(TOP)
		s:SetTall(1)
		s:DockMargin(5,10,5,10)
		s.Paint = function(sp, w, h)
			derma.SkinHook('Paint', 'Spacer', self, w, h)
		end
	end)
	return self
end

function PANEL:Popup()
	BaseClass.MakePopup(self)
	return self
end

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'Panel', self, w, h)
end

function PANEL:PaintOver(w,h)
	derma.SkinHook('Paint', 'FrameLoading', self, w, h)
end

function PANEL:Finish()
	return self:GetParent()
end
vgui.Register('ss_base', table.Copy(PANEL), 'EditablePanel')