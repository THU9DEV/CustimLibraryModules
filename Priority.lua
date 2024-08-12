local Priority = {
    Activity = nil,        -- The currently active priority's class
    Weightness = 0,        -- The current weight of the active priority
    Recently = nil,        -- The most recently active priority object
    Start = 0,             -- The timestamp when the current priority became active
    Classes = {},          -- List of all priorities
    Currently = nil,       -- The current priority object
}
Priority.__index = Priority

-- Set a priority as the active one, if it meets conditions
function Priority:set(Data, Skip)
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
end

-- Check if a priority can be set as active
function Priority:check(Data, Skip)
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self, "Weight") then
        Value = self
        self = Priority
    end
    if type(Data) == "boolean" then Skip = Data end

    -- Check if there’s no current activity, or if the new priority has higher weight and can be skipped
    if (not self.Activity or (Skip and Value.Skipable))
    and (self.Weightness < Value.Weight or table.find(Priority.Currently.CanSkip, self.Class))
    or self.Currently == Value then
        return true
    end
end

-- Check if a specific priority is currently active
function Priority:isActive(Data, Skip)
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

-- Clear the current active priority if it matches the given one
function Priority:clear(Data)
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self, "Weight") then
        Value = self
        self = Priority
    end

    if not Value or Value.Class ~= self.Activity or Value.LastActive ~= self.Start then
        return
    end

    self.Activity = nil
    self.Currently = nil
    self.Weightness = 0
    self.Start = 0
    return true
end

-- Retrieve a priority by its class name
function Priority:get(name)
    for _, v in ipairs(self.Classes) do
        if v.Class == name then
            return v
        end
    end
end

-- WeightBase metatable for individual priority instances
local WeightBase = setmetatable({}, Priority)
WeightBase.__index = Priority
WeightBase.__tostring = function(self)
    return string.format("%s : [ %s ]", self.Class, self.Weight)
end

-- Create a new priority instance
function Priority.new(Class, Weight, CanSkip)
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

getgenv().Priority = getgenv().Priority or Priority
return Priority
