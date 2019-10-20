local movedir = Angle(0,0,0)
local right, offset, camangle, pitch, aimx, aimy = movedir:Right(), Vector(0,0, 50), Angle(0,90,0), 0, 0, 0
local crosshair = Material('materials/gui/lmb.png', 'smooth noclamp nomip')

local function getRotationBetweenPoints(x1, y1, x2, y2)
	local scrh = ScrH()
	local y = (scrh-y2) - (scrh-y1)
	local x =  math.abs(x2 - x1)
	return -1 * ((math.atan2(y, x) / math.pi) * 180)
end

hook('InputMouseApply', function(cmd, x, y, ang)
    aimx = math.Clamp(aimx + x/10, 1, ScrW()-1)
    aimy = math.Clamp(aimy + y/10, 1, ScrH()-1)

	local screenShootPos = LocalPlayer():GetShootPos():ToScreen()
	local pitch = getRotationBetweenPoints(screenShootPos.x, screenShootPos.y, aimx, aimy)
	local yaw = screenShootPos.x > aimx and 180 or 0

	local aim = Angle(pitch, yaw, 0):SnapTo('y', 180)
	cmd:SetViewAngles(aim)
    return true
end)

hook('ShouldCollide', function(e1, e2)
    return (e1:IsPlayer() and e2:IsPlayer()) and false
end)

hook('Think', function()
    local vel = LocalPlayer():GetVelocity():Length2D()
    local maxspeed = LocalPlayer():GetRunSpeed()
    local zoom = (vel/maxspeed) * 50
    local pos = LocalPlayer():GetPos() + offset + right * (400 + zoom)

    camera.Move(pos, camangle)
end)

local function drawCorsshair(x, y)
	surface.DrawLine(x, y-4, x, y-10)
	surface.DrawLine(x, y+4, x, y+10)
	surface.DrawLine(x-4, y, x-10, y)
	surface.DrawLine(x+4, y, x+10, y)
end

local function drawSlantedCorsshair(x, y)
	surface.DrawLine(x-4, y-4, x-12, y-12)
	surface.DrawLine(x+4, y+4, x+12, y+12)
	surface.DrawLine(x-4, y+4, x-12, y+12)
	surface.DrawLine(x+4, y-4, x+12, y-12)
end

hook('HUDPaint', function()
	local pos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
	if math.abs(aimx-pos.x) < 35 and math.abs(aimy-pos.y) < 35 then
		surface.SetDrawColor(255, 255, 255, 255)
		drawCorsshair(aimx, aimy)
	else
		surface.SetDrawColor(255, 255, 255, 100)
		drawSlantedCorsshair(aimx, aimy)

		surface.SetDrawColor(255, 255, 255, 255)
		drawCorsshair(pos.x, pos.y)

		surface.SetDrawColor(255, 255, 255, 55)
		if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
			surface.DrawLine(pos.x, pos.y, aimx, aimy)
		end
	end
end)