ss.abilities = ss.abilities or {}
ss.abilities.ui = ss.abilities.ui

function ss.abilities.Display()
	if IsValid(ss.abilities.ui) then
		ss.abilities.ui:Remove()
	end

	ss.ui.Create('ss_abilities', function(ui)
		ss.abilities.ui = ui
	end)
end
hook('PlayerLoaded', ss.abilities.Display)

concommand.Add('ss_abilities', function() 
	ss.abilities.Display()
end)