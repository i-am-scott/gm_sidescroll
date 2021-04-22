ss.abilities = ss.abilities or {}
ss.abilities.ui = ss.abilities.ui

function ss.abilities.Add(pl, id, internal)
	local ability = srp.abilities.Get(id, internal)
	if not ability then
		return
	end

	ability:AddPlayer(pl)

	if pl == LocalPlayer() then
		ss.abilities.ui:AddAbility(abilitiy)
	end

	hook.Run('OnAbilityAdded', pl, ability)
	return true
end

function ss.abilities.Remove(pl, id, internal)
	local ability = srp.abilities.Get(id, internal)
	if not ability then
		return
	end

	if pl == LocalPlayer() then
		ss.abilities.ui:RemoveAbility(ability)
	end

	ability:RemovePlayer(pl)
	hook.Run('OnAbilityRemoved', pl, ability)
end

function ss.abilities.RequestActivate(pl, id, internal)
	local ability = srp.abilities.Get(id, internal)
	if not ability then
		return
	end

	if not ability:IsActive(pl) then
		if pl.ActiveAbility then
			pl.ActiveAbility:SetActive(pl, false)
		end

		ability:SetActive(pl, false)

		if pl == LocalPlayer() then
			ss.abilities.ui:SetActive(ability)
		end
	end
end

function ss.abilities.Display()
	if IsValid(ss.abilities.ui) then
		ss.abilities.ui:Remove()
	end

	ss.ui.Create('ss_abilities', function(ui)
		ss.abilities.ui = ui
	end)
end
hook('OnPlayerLoaded', ss.abilities.Display)

net('ss.abilities.SetActive', function()
	ss.abilities.SetActive(LocalPlayer(), net.ReadUInt(8), true)
end)

net('ss.abilities.AddAbility', function()
	ss.abilities.Add(LocalPlayer(), net.ReadUInt(8), true)
end)

net('ss.abilities.RemoveAbility', function()
	ss.abilities.Remove(LocalPlayer(), net.ReadUInt(8), true)
end)