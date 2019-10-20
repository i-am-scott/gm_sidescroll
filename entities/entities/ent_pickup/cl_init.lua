include 'shared.lua'

ENT.Angle = Angle()
function ENT:Draw()
    if not self.CorePos then
        self.CorePos = self:GetPos() + Vector(0,0,10)
        self.AngleSpeed = math.random(.3, .8)
    end

    self.Angle = self.Angle + Angle(0,self.AngleSpeed,0)
    self:SetRenderOrigin(self.CorePos + Vector(0, 0, math.sin(FrameTime()) * 5))
    self:SetRenderAngles(self.Angle)
    self:DrawModel()
end