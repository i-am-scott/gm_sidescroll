ss.hud = ss.hud or {}
ss.hud.ui = ss.hud.ui

surface.CreateFont('WeaponFont.L', {
	font = 'halflife2',
	size = 150,
	extended = true,
})

surface.CreateFont('WeaponFont.R', {
	font = 'halflife2',
	size = 100,
	extended = true,
})

surface.CreateFont('WeaponFont.S', {
	font = 'halflife2',
	size = 25,
	extended = true,
})

local sideOffsetRight = Vector(45, 0, 85)
local sideOffsetLeft = Vector(-60, 0, 85)

local empty = Vector()
local down = Vector(0,0,-1)
local weaponColor = Color(255, 80, 0, 255)
local skullTexture = surface.GetTextureID('hud/killicons/default')

local weaponNameLookup = {
	weapon_smg1 = 'SMG',
	weapon_ar2 = 'AR2',
	weapon_rpg = 'RPG',
	weapon_crowbar = 'Crowbar'
}

local weaponIcons = {
	weapon_rpg = 'i',
	weapon_smg1 = 'a',
	weapon_357 = 'e',
	weapon_ar2 = 'l',
	crossbow_bolt = '1',
	weapon_shotgun = 'b',
	rpg_missile = '3',
	npc_grenade_frag = 'k',
	weapon_pistol = 'd',
	prop_combine_ball = '8',
	grenade_ar2 = '7',
	weapon_stunstick = '!',
	npc_satchel = 'o',
	npc_tripmine = 'o',
	weapon_physcannon = 'h',
	weapon_crowbar = 'c',
	weapon_crossbow = 'g',
	weapon_stunstick = 'n',
}

local moveDir = {
	[0] = 'C',
	[LEFT] = 'D'
}


--OnPlayerChat

local duration = 1

function PLAYER:DrawDamage(x, y)
	if not self.LastDamage or CurTime() > self.LastDamage + duration then
		return
	end

	local size = 100
	surface.SetDrawColor(weaponColor)

	camera.PaintFunc(surface.DrawCircle, x, y, 100, 255, 0, 0, 255)
end

function PLAYER:DrawPlayerTarget(x, y)
	local target = self:GetEyeTraceNoCursor().Entity
	if not IsValid(target) or not target:IsPlayer() or target == self then
		return
	end

	local pos = target:GetPos()
	local facingRight = target:IsFacingRight()
	local running = target:GetVelocity():Length2D() > 55
	local offsetX = running and -42 or -32
	local offsetY = running and 45 or 20

	surface.SetFont(running and 'WeaponFont.L' or 'WeaponFont.R')
	surface.SetTextColor(255, 0, 0, 255)
	camera.PaintFunc(surface.SetTextPos, target.PlayerInfoOffset.x + offsetX, target.PlayerInfoOffset.z + offsetY)
	surface.DrawText('O')
end

function PLAYER:Draw3DBelow()
	local facingRight = self:IsFacingRight()

	local pos = self:GetPos()
	local plTr = self:GetEyeTraceNoCursor()

	self.PlayerInfoOffset = LerpVector(15 * RealFrameTime(), self.PlayerInfoOffset or pos, pos + (facingRight and sideOffsetLeft or sideOffsetRight))

	//self.PlayerInfoOffset = self:GetPos()
	//self.PlayerInfoOffset.z = self.PlayerInfoOffset.z + 82

	local x, y = self.PlayerInfoOffset.x, self.PlayerInfoOffset.z
	local weapon = self:GetActiveWeapon()

	camera.StartWall(1)
		camera.PaintText(self:Nick(), 'DermaDefaultBold', x, y+5, weaponColor, TEXT_ALIGN_CENTER)

		if not self:Alive() then
			surface.SetTexture(skullTexture)
			surface.SetDrawColor(weaponColor)
			camera.PaintScaledFunc(surface.DrawTexturedRect, x-28, y - 10, 64, 64)
		else
			surface.SetFont('WeaponFont.L')
			surface.SetTextColor(weaponColor)
			camera.PaintFunc(surface.SetTextPos, x-18, y+50)
			surface.DrawText(self:GetVelocity():Length2D() < 55 and 'C' or 'D')

			if IsValid(weapon) then
				local fontChar = weaponIcons[weapon:GetClass()]
				if fontChar then
					surface.SetFont('WeaponFont.S')
					surface.SetTextColor(weaponColor)
					camera.PaintFunc(surface.SetTextPos, x - 15, y+30)
					surface.DrawText(fontChar)
				end
			end

			self:DrawDamage(x, y)
			self:DrawPlayerTarget(x, y)
		end

	camera.EndWall()
end

local bullets = {}

local function drawBullets()
	camera.StartWall(1)

		for i, bullet in ipairs(bullets) do
			if CurTime() > bullet.dietime then
				table.remove(bullets, i)
				continue
			end

			local percent = math.Clamp(1 - (bullet.dietime - CurTime())/(bullet.dietime - bullet.startime), 0, 1)
			local pos = bullet.startpos + bullet.direction * (5000 * percent)

			camera.PaintFunc(draw.Box, pos.x, pos.z, 10, 10, weaponColor)
		end

	camera.EndWall()
end

hook('EntityFireBullets', function(ent, data)
	table.insert(bullets, {
		startime = CurTime(),
		dietime = CurTime() + 2,
		startpos = data.Src,
		direction = data.Dir
	})
end)

hook('ScalePlayerDamage', function(pl, hitgroup, dmginfo)
	pl.LastDamage = CurTime()
end)

hook('PreDrawTranslucentRenderables', 'PLAYER.DrawBelow', function()
	for _, pl in ipairs(player.GetAll()) do
		pl:Draw3DBelow()
	end

	drawBullets()
end)

--[[
	hook('PrePlayerDraw', function(pl)
		return false
	end)
]]