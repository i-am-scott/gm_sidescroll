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
hook('OnPlayerLoaded', ss.hud.Display)

local belowOffset = Vector(0, 0, -50)
function PLAYER:Draw3DBelow()
	local plPos = self:GetPos()

	local pos = plPos - belowOffset
	local ang = Angle(camera.cur_ang.p, camera.cur_ang.y, camera.cur_ang.r)

	cam.Start3D2D(pos, ang, 1)
		draw.DrawText(self:Nick(), 'DermaDefault', 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

hook('PostDrawPlayer', 'PLAYER.DrawBelow', function(pl)
	pl:DrawBelow()
end)

concommand.Add('ss_hud', function()
	ss.hud.Display()
end)