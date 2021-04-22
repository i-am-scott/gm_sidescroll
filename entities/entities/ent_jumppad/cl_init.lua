include 'shared.lua'

ENT.UIOffset = Vector(0,0,50)

local chevron = Material 'materials/sidescroller/chevron.png'

function ENT:Draw()
	self:DrawModel()

	camera.Start3D2DFromView(self:GetPos() + self.UIOffset, 1, function()
		draw.DrawText('JUMP PAD', 'DermaDefault', 0, 0, col.white, TEXT_ALIGN_CENTER)
	end)
end