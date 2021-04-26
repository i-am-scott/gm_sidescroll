AddCSLuaFile 'loader.lua'
AddCSLuaFile 'color.lua'
AddCSLuaFile 'shared.lua'
AddCSLuaFile 'cl_init.lua'
include 'shared.lua'

util.AddNetworkString 'PlayerLoaded'

loader.AddWorkshopItems({
    757604550, -- wOS Base
    1655743290, -- wOS Familiar
})

function GM:PlayerInitialSpawn(pl)
	pl:SetTeam(TEAM_PLAYER)
	pl:SetModel 'models/player/p2_chell.mdl'
end

function GM:PlayerSpawn(pl)
    pl:SetPos(Vector(-547, 0, 64))
	pl:SetTeam(1)
	pl:SetNoCollideWithTeammates(true)
    self:PlayerLoadout(pl)
end

function GM:DoPlayerDeath(pl, attacker, dmg)
    pl.nextspawn = CurTime() + 2
    pl.lastdeath = CurTime()
end

function GM:PlayerDeathThink(pl)
    if not pl.nextspawn or pl.nextspawn < CurTime() then
        pl:Spawn()
    end
end

function GM:GetFallDamage(pl)
    return 0
end

function GM:PlayerLoadout(pl)
end

function GM:OnPlayerLoaded(pl)
	print(pl, 'fully loaded')
end

function GM:PlayerNoClip(pl, dis)
	return true
end

function GM:PlayerDeathSound(pl)
    return false
end

net.Receive('PlayerLoaded', function(_, pl)
	hook.Call('OnPlayerLoaded', GAMEMODE, pl)
end)

local weps = {
	'weapon_crowbar',
	'weapon_pistol'
}

concommand.Add('giveweps', function(pl)
	pl:StripWeapons()

	for _, id in pairs(weps) do
		local wep = pl:Give(id)
		if IsValid(wep) and (wep.Primary and wep.Primary.Ammo) then
			pl:GiveAmmo(999, wep.Primary.Ammo)
		end
	end
end)