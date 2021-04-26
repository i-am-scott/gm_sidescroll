ss.abilities = ss.abilities or {}
local pinfo = {}

util.AddNetworkString 'ss.abilities.AddAbility'
util.AddNetworkString 'ss.abilities.RemoveAbility'

function ss.abilities.Add(pl, id, internal)
	local ability = ss.abilities.Get(id, internal)
	if not ability then
		return
	end

	ability:AddPlayer(pl)

	net.Start 'ss.abilities.AddAbility'
		net.WritePlayer(pl)
		net.WriteUInt(ability.internal, 8)
	net.Broadcast()

	return true
end

function ss.abilities.Remove(pl, id, internal)
	local ability = ss.abilities.Get(id, internal)
	if not ability then
		return
	end

	ability:RemovePlayer(pl)

	net.Start 'ss.abilities.RemoveAbility'
		net.WritePlayer(pl)
		net.WriteUInt(ability.internal, 8)
	net.Broadcast()
end

function ss.abilities.RequestActivate(pl, id, internal)
	local ability = ss.abilities.Get(id, internal)
	if not ability then
		return
	end

	if not ability:IsActive(pl) then
		if pl.ActiveAbility then
			pl.ActiveAbility:SetActive(pl, false)
		end

		ability:SetActive(pl, false)

		net.Start 'ss.abilities.SetActive'
			net.WritePlayer(pl)
			net.WriteUInt(ability.internal, 8)
		net.Broadcast()
	end
end