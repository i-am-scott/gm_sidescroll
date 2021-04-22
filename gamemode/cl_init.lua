include 'shared.lua'
local orange = Color(200,77,1)

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudDeathNotice = true,
	CHudCrosshair = true,
	CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudZoom = true,
    CHudSquadStatus = true,
    CHudPoisonDamageIndicator = true,
    CHudGeiger = true,
    CHudDamageIndicator = true,
}

function GM:HUDShouldDraw(name)
	if hide[name] then
		return false
	end
    return true
end

function GM:HUDDrawTargetID()
	return false
end

hook('PostDraw2DSkyBox', function()
    cam.Start2D()
        draw.Box(0, 0, ScrW(), ScrH(), orange)
    cam.End2D()
end)

hook('InitPostEntity', function()
	net.Start('PlayerLoaded')
	net.SendToServer()

	hook.Call('OnPlayerLoaded', GAMEMODE)
end)