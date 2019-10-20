local PANEL = {}

function PANEL:Init()
    self:DockPadding(0,0,0,0)
    self:SetTall(150)
    
    self:AddPanel('ss_panel', function(pnl) 
        pnl:Dock(TOP)
        pnl:DockPadding(0,0,0,0)
        pnl:DockMargin(0,0,0,0)
        pnl:AddPanel('ss_button', function(btn) 
            btn:DockMargin(0,0,0,0)
            btn:SetText '+'
            btn:Dock(RIGHT)
            btn:SetBackgroundColor(col.green)
            btn:SetHoverColor(col.green_dark)
            btn:LeftClick(function() 
                if #self.scroll:GetCanvas():GetChildren() < 10 then
                    self:AddOption()
                end
            end)
        end)
    end)

    self:AddPanel('ui_scrollpanel', function(scroll) 
        scroll:Dock(FILL)
        self.scroll = scroll
    end)
end

function PANEL:AddOption(str, data)
    local canvas = self.scroll:GetCanvas()

    ss.ui.Create('ss_textlistopt', function(tl)
        tl:SetParent(canvas) 
        tl:Dock(TOP)
        tl:SetTall(25)
    end)
end

function PANEL:Clear()
    self.scroll:GetCanvas():Clear()
end

function PANEL:GetValue()
    local data = {}
    for _, pnl in pairs(self.scroll:GetCanvas():GetChildren()) do
        table.insert(data, pnl:GetText())
    end
    return data
end
vgui.Register('ss_textlist', PANEL, 'ss_panel')

local PANEL = {}

function PANEL:Init()
    self:DockPadding(0,0,0,0)

    self:AddPanel('ss_textbox', function(txt) 
        txt:Dock(FILL)
        txt:DockMargin(0,0,0,0)
        self.txt = txt
    end)

    self:AddPanel('ss_button', function(btn) 
        btn:Dock(RIGHT)
        btn:DockMargin(0,0,0,0)
        btn:SetText 'X'
        btn:SetBackgroundColor(col.red)
        btn:LeftClick(function(s) 
            self:Remove()
        end)
    end)
end

function PANEL:GetText()
    return self.txt:GetText()
end
vgui.Register('ss_textlistopt', PANEL, 'ss_panel')