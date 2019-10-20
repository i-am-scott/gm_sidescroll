camera = camera or {}

util.AddNetworkString 'camera.Follow'
util.AddNetworkString 'camera.MoveTo'
util.AddNetworkString 'camera.SetPos'

function camera.Follow(pl, ent)
	net.Start 'camera.Follow'
		net.WriteEntity(ent)
	net.Send(pl)
end

function camera.MoveTo(pl, vec, ang)
	net.Start 'camera.MoveTo'
		net.WriteVector(vec)
		if ang then
			net.WriteAngle(ang)
		end
	net.Send(pl)
end

function camera.SetPos(pl, vec)
	net.Start 'camera.SetPos'
		net.WriteVector(vec)
	net.Send(pl)
end

function camera.LookAt(pl, vec)
	net.Start 'camera.LookAt'
	net.Send(pl)
end