local entTable = {
    ent_jumppad = {
        {
            Pos = Vector(175, 0, 50),
            Ang = Angle()
        }
    },
    pickup_ammo = {
        {
            Pos = Vector(350, 0, 50),
            Ang = Angle()
        }
    },
    pickup_weapon = {
        {
            Pos = Vector(-400, 0, 50),
            Ang = Angle()
        }
    },
    pickup_health = {
        {
            Pos = Vector(-200, 0, 400),
            Ang = Angle()
        }
    },
    pickup_ability = {
        {
            Pos = Vector(175, 0, 400),
            Ang = Angle()
        }
    }
}

local function SpawnEntities()
    for class, lst in pairs(entTable) do
        for _, ent in ipairs(ents.FindByClass(class)) do
            ent:Remove()
        end

        for _, data in pairs(lst) do
            local ent = ents.Create(class)
            ent:SetPos(data.Pos)
            ent:SetAngles(data.Ang)
            ent:DropToFloor()
            ent:Spawn()

            if ent.Setup then
                ent:Setup(data)
            end
        end
    end
end

hook('InitPostEntity', SpawnEntities)
concommand.Add('loadents', SpawnEntities)