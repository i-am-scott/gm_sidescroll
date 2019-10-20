ss.hud = ss.hud or {}
ss.hud.ui = ss.hud.ui

function ss.hud.Display()
	if IsValid(ss.hud.ui) then
		ss.hud.ui:Remove()
	end

	ss.ui.Create('ss_hud', function(ui)
		ss.hud.ui = ui
	end)
end
hook('PlayerLoaded', ss.hud.Display)

concommand.Add('ss_hud', function() 
	ss.hud.Display()
end)