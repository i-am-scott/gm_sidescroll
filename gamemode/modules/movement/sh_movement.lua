local switched
local dirright = Vector(1,0,0)

hook('SetupMove', function(pl, mv, cmd)
    local angle = mv:GetAngles()
    local forward = mv:GetForwardSpeed()
    local sidespeed = mv:GetSideSpeed()
    local newmoveang = angle:SnapTo('y', 180)

    mv:SetMoveAngles(newmoveang)
    mv:SetForwardSpeed(newmoveang.y == -180 and -sidespeed or sidespeed)
    mv:SetSideSpeed(0)
end)