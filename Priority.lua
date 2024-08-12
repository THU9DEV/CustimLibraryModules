-- Priority System: Manages different prioritized tasks or states within a system.
-- Each priority has a weight, which determines its importance.
-- The system allows setting, checking, and clearing priorities, ensuring the highest priority is active.

local Priority = {
    Activity = nil,        -- string | nil: The currently active priority's class name.
    Weightness = 0,        -- number: The weight of the currently active priority.
    Recently = nil,        -- table | nil: The most recently active priority object.
    Start = 0,             -- number: The timestamp when the current priority became active.
    Classes = {},          -- table: List of all priority objects.
    Currently = nil,       -- table | nil: The currently active priority object.
}
Priority.__index = Priority

-- Sets a priority as the active one if it meets the necessary conditions.
-- @param Data table | string: The priority object or class name to be set as active.
-- @param Skip boolean | nil: Whether to skip certain checks when setting the priority.
-- @return boolean: Whether the priority was successfully set as active.
function Priority:set(Data: table | string, Skip: boolean?): boolean
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self, "Weight") then
        Value = self
        self = Priority
    end

    if self.Currently ~= Value and Value:check(Skip) then
        self.Activity = Value.Class
        self.Currently = Value
        self.Weightness = Value.Weight
        self.Recently = Value
        self.Start = tick()
        Value.LastActive = self.Start
        return true
    end
    return false
end

-- Checks if a priority can be set as the active one based on its weight and conditions.
-- @param Data table | string | boolean: The priority object or class name to check, or a skip flag.
-- @param Skip boolean | nil: Whether to skip certain checks.
-- @return boolean: Whether the priority can be set as active.
function Priority:check(Data: table | string | boolean, Skip: boolean?): boolean
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self, "Weight") then
        Value = self
        self = Priority
    end
    if type(Data) == "boolean" then Skip = Data end

    if (not self.Activity or (Skip and Value.Skipable))
    and (self.Weightness < Value.Weight or table.find(Priority.Currently.CanSkip, self.Class))
    or self.Currently == Value then
        return true
    end
    return false
end

-- Checks if a specific priority is currently active.
-- @param Data table | string | boolean: The priority object or class name to check, or a skip flag.
-- @param Skip boolean | nil: Whether to skip certain checks.
-- @return boolean: Whether the given priority is currently active.
function Priority:isActive(Data: table | string | boolean, Skip: boolean?): boolean
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self, "Weight") then
        Value = self
        self = Priority
    end
    if type(Data) == "boolean" then Skip = Data end
    return self.Currently == Value
end

-- Clears the current active priority if it matches the given one.
-- @param Data table | string: The priority object or class name to clear.
-- @return boolean | nil: Whether the priority was successfully cleared.
function Priority:clear(Data: table | string): boolean | nil
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self, "Weight") then
        Value = self
        self = Priority
    end

    if not Value or Value.Class ~= self.Activity or Value.LastActive ~= self.Start then
        return nil
    end

    self.Activity = nil
    self.Currently = nil
    self.Weightness = 0
    self.Start = 0
    return true
end

-- Retrieves a priority object by its class name.
-- @param name string: The class name of the priority to retrieve.
-- @return table | nil: The priority object, or nil if not found.
function Priority:get(name: string): table | nil
    for _, v in ipairs(self.Classes) do
        if v.Class == name then
            return v
        end
    end
    return nil
end

-- Returns a list of all priority objects.
-- @return table: A list of all priority objects.
function Priority:getAll(): table
    return self.Classes
end

-- Resets the entire priority system, clearing all active priorities.
function Priority:reset(): void
    self.Activity = nil
    self.Weightness = 0
    self.Recently = nil
    self.Start = 0
    self.Currently = nil
end

-- Adds a new priority class to the system.
-- @param Class string: The class name of the new priority.
-- @param Weight number: The weight of the new priority.
-- @param CanSkip table | nil: A list of classes that can be skipped by this priority.
-- @return table: The newly created priority object.
function Priority:addClass(Class: string, Weight: number, CanSkip: table?): table
    return self.new(Class, Weight, CanSkip)
end

-- WeightBase metatable for individual priority instances.
local WeightBase = setmetatable({}, Priority)
WeightBase.__index = Priority
WeightBase.__tostring = function(self: table): string
    return string.format("%s : [ %s ]", self.Class, self.Weight)
end

-- Creates a new priority instance.
-- @param Class string: The class name of the new priority.
-- @param Weight number: The weight of the new priority.
-- @param CanSkip table | nil: A list of classes that can be skipped by this priority.
-- @return table: The newly created priority object.
function Priority.new(Class: string, Weight: number, CanSkip: table?): table
    local Value = setmetatable({}, WeightBase)
    Value.Class = Class ~= "" and Class or "Undefined"
    Value.Weight = Weight or #Priority.Classes + 1
    Value.Skipable = true
    Value.LastActive = 0
    Value.CanSkip = CanSkip or {}

    -- Insert into priority classes list and sort by weight
    table.insert(Priority.Classes, Value)
    table.sort(Priority.Classes, function(a, b)
        return a.Weight < b.Weight
    end)

    return Value
end

-- Retrieves the currently active priority.
-- @return table | nil: The currently active priority object, or nil if none.
function Priority:getCurrent(): table | nil
    return self.Currently
end

-- Gets the time elapsed since the current priority was set.
-- @return number: The time in seconds since the current priority was set.
function Priority:getTimeSinceStart(): number
    return tick() - (self.Start or 0)
end

-- Checks if a priority has a higher weight than the currently active one.
-- @param Data table | string: The priority object or class name to compare.
-- @return boolean: Whether the given priority has a higher weight than the current one.
function Priority:hasHigherWeight(Data: table | string): boolean
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self, "Weight") then
        Value = self
        self = Priority
    end

    return Value.Weight > (self.Weightness or 0)
end

-- Expose the Priority module globally.
getgenv().Priority = getgenv().Priority or Priority
return Priority
