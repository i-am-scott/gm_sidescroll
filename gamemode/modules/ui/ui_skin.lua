local SKIN 	= {
	PrintName = 'SS_SKIN',
	Author = 'Scott'
}

local color_bg = Color(15,15,15,245) -- col.ui_bg
local color_accent = col.blue
local color_headerbg = Color(0, 0, 0, 255) -- col.ui_header
local color_outline = col.grey
local color_button = col.black
local color_button_disabled = Color(0,0,0,100)
local color_loadingbg = Color(25, 25, 25, 255)
local color_white = col.white
local color_red = col.red
local color_green = col.green
local color_black = col.black
local color_grey  = col.grey

function SKIN:PaintFrame(self, w, h)
	draw.NoTexture()

	if self.ribbon then
		draw.Box(0, 0, 10, h, self.ribbon_color or color_accent)
	end

	draw.Box(self.ribbon and 10 or 0, 0, w - (self.ribbon and 10 or 0), 30, self.m_bgHeaderColor or color_headerbg)
	draw.Box(self.ribbon and 10 or 0, 30, w - (self.ribbon and 10 or 0), h-30, self.m_bgColor or color_bg)

	if self.blur then
		draw.BlurPanel(self)
	end

	if self.outline then
		surface.SetDrawColor(self.m_bdrColor or color_outline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
end

function SKIN:PaintBackgroundFrame(self, w, h)
	SKIN:PaintFrame(self, w, h)
end

local barw, barh = 225, 8
function SKIN:PaintFrameLoading(self, w, h)
	if not self.loading then
		return
	end

	draw.Box(0, 30, w, h - 30, color_loadingbg)

    if self.loadendtime then
        local x, y = (w-barw), h/2

        draw.DrawText((self.loadingtext or 'Loading') .. string.rep('.', (math.abs(math.sin(CurTime())*3))), 'ui_header.s', x/2, y+100, col.white)
        draw.Box(x/2, y+90, barw, barh, col.grey_light)

        local perc = 1 - (self.loadendtime-CurTime())/self.loadtimeout
        draw.Box(x/2, y+90, barw*perc, barh, col.blue)
    end
end

function SKIN:PaintSpacer(self, w, h)
	draw.Box(0, 0, w, h, color_grey)
end

function SKIN:PaintPanel(self, w, h)
	draw.Box(0, 0, w, h, self.m_bgColor or color_bg)

	if self.outline then
		surface.SetDrawColor(self.m_bdrColor or color_outline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
end

function SKIN:PaintButton(self,w,h)
	local bg = self:IsHovered() and (self.m_bghColor or color_grey) or (self.selected and self.selectedbg) or (self.m_bgColor or color_button)
	draw.Box(0, 0, w, h, self.disabled and color_button_disabled or bg)

	if self.outline then
		surface.SetDrawColor(self.m_bdrColor or color_outline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
end

function SKIN:PaintButtonAnimated(self,w,h)
	SKIN:PaintButton(self,w,h)
	if not self.icon then
		return
	end

	local col = self.icon_color or col.white
	local cos = math.cos(RealTime()/1) * 30
	local sin = math.sin(RealTime()/1) * 30

	surface.SetDrawColor(col)
	surface.SetMaterial(self.icon)

	local size_w, size_h = w * 4, w * h
	surface.DrawTexturedRectUV(-w * 2 + cos, -h * 2 + (cos - sin), size_w, size_h, 0, 0, size_w/32, size_h/32)
end

function SKIN:PaintMenu(self, w, h)
	draw.OutlinedBox(0, 0, w, h, self.m_bgColor or color_button, col.black)
end

function SKIN:PaintMenuOption(self, w, h)
	local bg = self:IsHovered() and col.blue or (self.m_bgColor or color_grey)

	draw.Box(0, 0, w, h, bg)

    surface.SetDrawColor(col.grey_dark)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintDropdown(self, w, h)
	SKIN:PaintButton(self,w,h)
	draw.Box(w-5, 0, 5, h, col.grey)

    surface.SetDrawColor(color_outline)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintTextInput(self, w, h)
	if self.outline then
		draw.OutlinedBox(0, 0, w, h, self.m_bgColor or color_button, self.outline)
	else
		draw.Box(0, 0, w, h, self.m_bgColor or color_button)
	end

	self:DrawTextEntryText(self.errorText and col.red or self.m_colText, self.m_colHighlight, self.m_colCursor)

	if self.errorText then
		surface.DisableClipping(true)
		draw.DrawText(self.errorText, "ui_label.s", w - 5, -h * .5, col.red, TEXT_ALIGN_RIGHT)
		surface.DisableClipping(false)
	end
end

function SKIN:PaintNumberInput(self, w, h)
	draw.Box(0, 0, w, h, self.m_bgColor or color_button)
	self:DrawTextEntryText(self.m_colText, self.m_colHighlight, self.m_colCursor)
end

function SKIN:PaintTextInputOverlay(self, w, h)
    if self.outline then
        surface.SetDrawColor(color_outline)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
end
derma.DefineSkin('SS_SKIN', 'Sidescroller\'s derma skin', SKIN)