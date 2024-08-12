local Players = game:GetService("Players")

local CharacterUtility = {}
CharacterUtility.__index = CharacterUtility

function CharacterUtility.new(player)
    local self = setmetatable({}, CharacterUtility)
    self.player = player or Players.LocalPlayer
    return self
end


function CharacterUtility:GetCharacter()
    return self.player.Character or self.player.CharacterAdded:Wait()
end

function CharacterUtility:GetHumanoid()
    local character = self:GetCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

function CharacterUtility:TeleportTo(position)
    local character = self:GetCharacter()
    if character and character.PrimaryPart then
        character:SetPrimaryPartCFrame(CFrame.new(position))
    end
end

function CharacterUtility:GetPosition()
    local character = self:GetCharacter()
    if character and character.PrimaryPart then
        return character.PrimaryPart.Position
    end
    return nil
end

function CharacterUtility:IsAlive()
    local humanoid = self:GetHumanoid()
    return humanoid and humanoid.Health > 0
end

getgenv().CharacterUtility = getgenv().CharacterUtility or CharacterUtility
return CharacterUtility
