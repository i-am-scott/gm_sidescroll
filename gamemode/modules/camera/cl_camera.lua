camera = camera or {}
camera.enabled = camera.enabled or false
camera.cur_pos = camera.cur_pos or Vector()
camera.des_pos = camera.des_pos or Vector()
camera.cur_ang = camera.cur_ang or Angle()
camera.des_ang = camera.des_ang or Angle()
camera.speed = 4

function camera.Enable(b)
	camera.enabled = b
	if b then
		hook('Think', 'camera.Controller', camera.Logic)
		hook('CalcView', 'camera.Controller', camera.Control)
	else
		hook.Remove('Think', 'camera.Controller')
		hook.Remove('CalcView', 'camera.Controller')
	end
end

function camera.Move(pos, ang)
	camera.des_pos = pos
	if ang then
		camera.des_ang = ang
	end
end

function camera.Follow(e)
	camera.follow = e
end

function camera.Control(pl, pos, ang, fov)
	if not camera.enabled then
		return
	end

	return {
		origin = camera.cur_pos,
		angles = camera.cur_ang,
		fov = fov
	}
end

function camera.Logic()
	if camera.cur_pos ~= camera.des_pos or camera.cur_ang ~= camera.des_ang then
		camera.cur_pos = LerpVector(FrameTime() * camera.speed, camera.cur_pos, camera.des_pos)
		camera.cur_ang = LerpAngle(FrameTime() * camera.speed, camera.cur_ang, camera.des_ang)
	end
end

function camera.GetPos()
    return camera.cur_pos
end

function camera.TargetPos()
    return camera.des_pos
end

function camera.GetAngle()
    return camera.cur_ang
end

-- TODO make this change depend on cameras yaw
local camAngle = Angle(0, 0, 90)
local wallScale = 1
local wallPos = Vector()

function camera.GetWorldSizeToWall(w, h)
	return w * (1/wallScale), h * (1/wallScale)
end

function camera.GetWorldPosToWall(x, y)
	y = y * -1
	return x * (1/wallScale), y * (1/wallScale)
end

function camera.GetWorldPosToWallVec(vector)
	return camera.GetWorldPosToWall(vector.x, vector.y)
end

function camera.Start3D2DFromView(pos, scale, cbk)
	cam.Start3D2D(pos, camAngle, scale)
		cbk()
	cam.End3D2D()
end

function camera.StartWall(scale)
	wallScale = scale or 1

	local wallY = camera.QuickTrace().HitPos.y
	wallPos.y = wallY

	cam.Start3D2D(wallPos, camAngle, wallScale)
end

function camera.EndWall()
	cam.End3D2D()
end

function camera.PaintFunc(func, x, y, ...)
	local x, y = camera.GetWorldPosToWall(x, y)
	func(x, y, ...)
end

function camera.PaintScaledFunc(func, x, y, w, h)
	local x, y = camera.GetWorldPosToWall(x, y)
	local w, h = camera.GetWorldSizeToWall(w, h)

	func(x, y, w, h)
end

function camera.PaintText(text, font, x, y, color, align)
	local x, y = camera.GetWorldPosToWall(x, y)

	draw.DrawText(text, font, x, y, color, align)
end

function camera.QuickTrace(dist, mask)
	return util.TraceLine({
		start = camera.cur_pos,
		endpos = camera.cur_pos + camera.cur_ang:Forward() * (dist or 10000),
		mask = mask or MASK_SOLID_BRUSHONLY
	})
end

hook('ShouldDrawLocalPlayer', function()
    return true
end)

hook('OnPlayerLoaded', 'LoadSideCam', function(pl)
	camera.Enable(true)
end)

net('camera.Follow', function()
	local e = net.ReadEntity()
	if not IsValid(e) then
		return
	end

	camera.Follow(e)
end)

net('camera.MoveTo', function()
	camera.Move(net.ReadVector(), net.ReadAngle())
end)

net('camera.SetPos', function()
	local pos = net.ReadVector()
	local ang = net.ReadAngle()

	camera.cur_pos = pos
	camera.des_pos = pos

	if ang then
		camera.cur_ang = ang
		camera.des_ang = ang
	end
end)