ss.hud = ss.hud or {}
ss.hud.ui = ss.hud.ui

surface.CreateFont('WeaponFont.L', {
	font = 'halflife2',
	size = 150,
	extended = true,
})

surface.CreateFont('WeaponFont.S', {
	font = 'halflife2',
	size = 25,
	extended = true,
})

local sideOffsetRight = Vector(45, 0, 90)
local sideOffsetLeft = Vector(-60, 0, 90)

local empty = Vector()
local down = Vector(0,0,-1)
local weaponColor = Color(255, 80, 0, 255)

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

function PLAYER:DrawDamage(x, y)
	camera.PaintFunc(surface.DrawCircle, x, y, 360, 255, 0, 0)
end

function PLAYER:Draw3DBelow()
	local facingRight = self:IsFacingRight()

	local pos = self:GetPos()
	self.PlayerInfoOffset = LerpVector(15 * RealFrameTime(), self.PlayerInfoOffset or pos, pos + (facingRight and sideOffsetLeft or sideOffsetRight))

	local x, y = self.PlayerInfoOffset.x, self.PlayerInfoOffset.z
	local weapon = self:GetActiveWeapon()

	camera.StartWall(1)
		camera.PaintText(self:Nick(), 'DermaDefaultBold', x, y+5, weaponColor, TEXT_ALIGN_CENTER)

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
	camera.EndWall()
end

hook('PreDrawTranslucentRenderables', 'PLAYER.DrawBelow', function()
	for _, pl in ipairs(player.GetAll()) do
		pl:Draw3DBelow()
	end
end)