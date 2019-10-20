local PANEL = {}
local background, background1 = Color(30, 30, 30), Color(0, 0, 0, 100)
local headcolor = Color(255, 255, 255)
local textcolor = Color(222, 222, 222)

surface.CreateFont( 'ui_info_title.l' , {
	font = 'Clear Sans Medium',
	size = 60,
	weight = 600,
	antialias = true
})

surface.CreateFont( 'ui_info_title.r' , {
	font = 'Clear Sans Medium',
	size = 28,
	weight = 600,
	antialias = true
})

surface.CreateFont( 'ui_info_text.r' , {
	font = 'Clear Sans Medium',
	size = 18,
	weight = 400,
	antialias = true
})

function PANEL:Init()
    self:SetTitle ''
	self:SetSize(400, 100)
    self:MakePopup(true)
    self:DockPadding(0, 0, 0, 0)
    self:SetAlpha(0)
    self:AlphaTo(255, .1, 0)

    self:AddPanel('ss_panel', function(pnl) 
        pnl:DockMargin(0,0,0,0)
        pnl:DockPadding(0,0,0,0)
        pnl:Dock(TOP)
        pnl:SetTall(80)
        pnl:SetMouseInputEnabled(false)
        pnl:SetBackgroundColor(col.transparent)
        pnl:AddPanel('ss_label', function(lbl) 
            lbl:Dock(FILL)
            lbl:SetFont 'ui_info_title.l'
            lbl:SetText ''
            lbl:SetTextColor(headcolor)
            lbl:SetContentAlignment(5)
            lbl:SetMouseInputEnabled(false)
            self.header = lbl
        end)
    end)

    self:AddPanel('ui_scrollpanel', function(scrl) 
        scrl:Dock(FILL)
        self.scroll = scrl
    end)

    self.close:SetBackgroundColor(col.transparent)
    self.close:SetHoverColor(col.transparent)
    self.close:SetTextColor(col.white)
    self.close:MoveToFront()

    self.close:LeftClick(function() 
        self:AlphaTo(0, .1, 0, function() 
            if IsValid(self) then
                self:Remove()
            end
        end)
    end)
end

function PANEL:SetHeader(text, icon)
    self.header:SetText(text)
    if icon then
        self.header:SetFont 'FontAwesomeLarge'
    end
    return self
end

function PANEL:AddInfoSegment(title, desc, tall)
    ss.ui.Create('ss_simpleinfocat', function(cat) 
        cat:SetParent(self.scroll:GetCanvas())
        cat:Dock(TOP)
        cat:SetTall(tall or 200)
        cat:SetHeader(title or '')
        cat:SetInfo(desc)
    end)

    self:SetTall(self:GetTall() + (tall or 200))
    return self
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, background)
end
vgui.Register('ss_simpleinfo', PANEL, 'ss_window')

local PANEL = {}

function PANEL:Init()
    self:DockMargin(0, 0, 0, 0)
    self:DockPadding(10, 10, 10, 10)
    self:SetBackgroundColor(background1)

    self:AddPanel('ss_label', function(lbl)
        lbl:Dock(TOP)
        lbl:SetTall(25)
        lbl:SetContentAlignment(4)
        lbl:DockMargin(0, 5, 0, 5)
        lbl:SetTextColor(textcolor)
        lbl:SetFont 'ui_info_title.r'
        lbl:SetText ''
        self.header = lbl
    end)

    self:AddPanel('ss_label', function(lbl)
        lbl:Dock(FILL)
        lbl:SetContentAlignment(7)
        lbl:SetTextColor(textcolor)
        lbl:DockMargin(0, 5, 0, 5)
        lbl:SetFont 'ui_info_text.r'
        lbl:SetText ''
        self.desc = lbl
    end)
end

function PANEL:SetHeader(text)
    self.header:SetText(text)
end

function PANEL:SetInfo(desc)
    self.desc:SetText(desc)
end
vgui.Register('ss_simpleinfocat', PANEL, 'ss_panel')