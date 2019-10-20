local PANEL = {}
local close_col = col.red_dark:Copy()
close_col.a = 180

DEFINE_BASECLASS( "EditablePanel" )

AccessorFunc(PANEL, 'm_bDeleteOnClose', 'DeleteOnClose', FORCE_BOOL)
AccessorFunc(PANEL, 'm_bSizable', 'Sizable', FORCE_BOOL)
AccessorFunc(PANEL, 'm_bScreenLock','ScreenLock', FORCE_BOOL)

function PANEL:Init()
	self.ribbon = false
    self.loading = false
    self.loadalpha = 0

	self:DockPadding(self.ribbon and 20 or 5, 30 + 5, 5, 5)

	self:SetDeleteOnClose(true)
	self:SetSizable(false)
	self:SetScreenLock(false)

	self:AddPanel('ss_label', function(s)
		s:SetText 'Window'
		s:SetFont 'ui_title.r'
		s:SetWide(400)
		s:SetPos(self.ribbon and 20 or 10, 5)
		s:SetMouseInputEnabled(false)
		self.title = s
	end)
	
	self:AddPanel('ss_button', function(btn) 
        btn:DockMargin(0,0,0,0)
        btn:SetSize(30,30)
        btn:SetBackgroundColor(close_col)
        btn:SetHoverColor(close_col)
        btn:SetClose()
        self.close = btn
	end)
end

function PANEL:SetBlur(b, sampleCount)
	self.blur = b
	self.blurdepth = sampleCount or 5
	return self
end

function PANEL:SetDeleteOnClose(b)
	self.deleteonclose = b
	return self
end

function PANEL:GetDeleteOnClose(b)
	return self.deleteonclose
end

function PANEL:RemoveTitle() 
	self.title:Remove()
	return self
end

function PANEL:SetTitle(text)
	self.title:SetText(text)
	return self
end

function PANEL:SetTitleFont(text)
	self.title:SetFont(text)
	return self
end

function PANEL:SetTitleColor(col)
	self.title:SetTextColor(col)
	return self
end

function PANEL:SetBorderColor(c)
	self.outline = true
	self.m_bdrColor = c
	return self
end

function PANEL:AddPanel(p,b)
	local ret = ss.ui.Create(p)
	if not IsValid(ret) then
		return self
	end 

	ret:SetParent(self)
	if self.stacked then
		ret:Dock(TOP)
		ret:InvalidateLayout(true)
	end

	if isfunction(b) then
		b(ret,self)
	else
		return b and self or ret
	end
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

function PANEL:SetStacked()
	self.stacked = true 
	return self
end

function PANEL:SetSize(w, h)
	BaseClass.SetSize(self, w, h)
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
	return self
end

function PANEL:IsLoading()
	self:SetCursor 'hourglass'
	return self.loading
end

function PANEL:SetLoadingTimer(time)
    self.loadendtime = time + CurTime()
    self.loadtimeout = time
    
	timer.Simple(time, function() 
		if IsValid(self) then 
			self.loading = false
			self:SetCursor 'none'
		end
	end)
end

function PANEL:Popup()
	BaseClass.MakePopup(self)
	return self
end

function PANEL:OnMousePressed()
	if self.nodrag then 
		return 
	end

	if gui.MouseY() < (self.y + 30) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture(true)
		return
	end
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self:MouseCapture(false)
end

function PANEL:PerformLayout(w, h)
	if IsValid(self.close) then
		self.close:SetPos(w - 30, 0)
	end
end

function PANEL:Think()
	local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
	local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

	if self.Dragging then
		local x = math.Clamp(mousex - self.Dragging[1], 0, ScrW() - self:GetWide())
		local y = math.Clamp(mousey - self.Dragging[2], 0, ScrH() - self:GetTall())
		self:SetPos(x, y)
	end
end

function PANEL:SetBackgroundColor(col)
	self.m_bgColor = col
	return self
end

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'Frame', self, w, h)
end

function PANEL:PaintOver(w,h)
	derma.SkinHook('Paint', 'FrameLoading', self, w, h)
end

function PANEL:Finish()
	return self
end
vgui.Register('ss_window', table.Copy(PANEL), 'EditablePanel')