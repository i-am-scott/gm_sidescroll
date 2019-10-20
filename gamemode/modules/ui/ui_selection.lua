local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor(col.transparent)
    self:DockMargin(0,0,0,0)
    self.options = {}

    self:AddPanel('ss_label', function(lbl) 
        lbl:SetText 'Options'
        lbl:Dock(LEFT)
        lbl:SetWide(145)
        self.title = lbl
    end)

    self:AddPanel('ss_panel', function(pnl) 
        pnl:Dock(FILL)
        pnl:SetBackgroundColor(col.transparent)
        pnl:DockPadding(0,0,0,0)
        pnl:DockMargin(0,0,0,0)
        self.container = pnl
    end)
end

function PANEL:SetText(str)
    self.title:SetText(str)
    return self
end

function PANEL:AddRange(start, finish, data)
    local finish = math.max(start, finish)
    for i = 1, ((finish+1) - start) do
        self:AddOption(tostring(start + i - 1), data)
    end
end

function PANEL:AddOption(name, data)
    self.container:AddPanel('ss_button', function(btn)
        btn.id = table.insert(self.options, btn)
        btn:Dock(LEFT)
        btn:SetText(name)
        btn:SetSelectedBackgroundColor(name == "0" and col.blue or col.green)
        btn:DockPadding(0,0,0,0)
        btn:DockMargin(0,0,0,0)
        btn:LeftClick(function(b)
            self:Select(b.id)
        end)
        btn:OnSelected(function(b) 
            self:Selected(b.id, b.data, b)
        end)
    end)
    return self
end

function PANEL:Select(id)
    for i = 1, #self.options do
        if i == id then
            self.options[i]:Select(true)
        else
            self.options[i]:Select(false)
        end
    end
end

function PANEL:OnSelected(func)
    self.Selected = func
    return self
end

function PANEL:Selected(id, data, button)
end

function PANEL:PerformLayout(w, h)
    if IsValid(self.container) then
        local bw = self.container:GetWide()/#self.options
        for i = 1, #self.options do
            self.options[i]:SetWide(bw)
        end
    end
end
vgui.Register('ss_select', PANEL, 'ss_panel')

local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor(col.transparent)
    self:DockPadding(0,0,0,0)
    self:DockMargin(0,0,0,0)

    self:AddPanel('ss_panel', function(pnl) 
        pnl:DockPadding(0,0,0,0)
        pnl:DockMargin(0,0,0,0)
        pnl:Dock(TOP)
        pnl:SetTall(20)
        pnl:AddPanel('ss_label', function(lbl) 
            lbl:Dock(FILL)
            self.title = lbl
        end)
    end)
end

function PANEL:SetTitle(str)
    self.title:SetText(str)
    return self
end
vgui.Register('ss_selectpanel', PANEL, 'ss_panel')