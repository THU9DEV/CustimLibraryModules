local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local CharacterUtility = {}
CharacterUtility.__index = CharacterUtility

-- Constructor to create a new CharacterUtility object
function CharacterUtility.new(player)
    local self = setmetatable({}, CharacterUtility)
    self.player = player or Players.LocalPlayer
    return self
end

-- Retrieve the player's character, waiting for it if not available
function CharacterUtility:GetCharacter()
    return self.player.Character or self.player.CharacterAdded:Wait()
end

-- Retrieve the player's humanoid, if it exists
function CharacterUtility:GetHumanoid()
    local character = self:GetCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

-- Teleport the player's character to a specific position
function CharacterUtility:TeleportTo(position)
    local character = self:GetCharacter()
    if character and character.PrimaryPart then
        character:SetPrimaryPartCFrame(CFrame.new(position))
    else
        warn("Failed to teleport: Character or PrimaryPart is missing.")
    end
end

-- Get the current position of the player's character
function CharacterUtility:GetPosition()
    local character = self:GetCharacter()
    if character and character.PrimaryPart then
        return character.PrimaryPart.Position
    end
    warn("Character or PrimaryPart not found.")
    return nil
end

-- Check if the player's character is alive
function CharacterUtility:IsAlive()
    local humanoid = self:GetHumanoid()
    return humanoid and humanoid.Health > 0
end

-- Monitor the player's health, triggering a callback if it falls below a threshold
function CharacterUtility:MonitorHealth(threshold, callback)
    local humanoid = self:GetHumanoid()
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= threshold then
                callback(humanoid.Health)
            end
        end)
    else
        warn("Cannot monitor health: Humanoid not found.")
    end
end

-- Reset the player's character to the spawn position
function CharacterUtility:ResetCharacter()
    local char = self:GetCharacter()
    char:Breakjoints()
end

-- Continuously move the character towards a target position
function CharacterUtility:MoveTo(targetPosition)
    local humanoid = self:GetHumanoid()
    if humanoid then
        humanoid:MoveTo(targetPosition)
    else
        warn("Cannot move: Humanoid not found.")
    end
end

-- Example usage: Adjust the walk speed of the player's character
function CharacterUtility:SetWalkSpeed(speed)
    local humanoid = self:GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
    else
        warn("Cannot set walk speed: Humanoid not found.")
    end
end

-- Example usage: Adjust the jump power of the player's character
function CharacterUtility:SetJumpPower(jumpPower)
    local humanoid = self:GetHumanoid()
    if humanoid then
        humanoid.JumpPower = jumpPower
    else
        warn("Cannot set jump power: Humanoid not found.")
    end
end

-- Example usage: Auto-jump at intervals
function CharacterUtility:AutoJump(interval)
    local humanoid = self:GetHumanoid()
    if humanoid then
        while true do
            humanoid.Jump = true
            task.wait(interval)
        end
    else
        warn("Cannot auto-jump: Humanoid not found.")
    end
end

getgenv().CharacterUtility = getgenv().CharacterUtility or CharacterUtility
return CharacterUtility
