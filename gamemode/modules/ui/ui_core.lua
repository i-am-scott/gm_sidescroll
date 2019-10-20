ss.ui = ss.ui or {}

function ss.ui.Create(i,c)
	local r = vgui.Create(i)
	if not IsValid(r) then
		return
	end

	r:SetSkin 'SS_SKIN'
	return c and c(r) or r
end

vgui.Register('ss_panel', {}, 'ss_base')