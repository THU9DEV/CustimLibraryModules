local CustomServices = {}

local Players = game:GetService("Players")
local Client = Players.LocalPlayer

CustomServices.IsAlive = function(Entity)
    return Entity and Entity.Character and Entity.Character.Humanoid.Health > 0
end

CustomServices.GetClosest = function(Distance)
    local Closet = {Distance or math.huge}

    for _, player in ipairs(Players:GetPlayers()) do
        if player == Client then
            continue
        end

        if not CustomServices.IsAlive(player) then
            continue
        end

        local Char = player.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        local ClientRoot = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")

        if Root and Root then
            local distance = (ClientRoot.Position - Root.Position).magnitude

            if distance < Closet[1] then
                Closet[1] = distance
                Closet[2] = player
            end
        end
    end

    return Closet[2]
end


return CustomServices
