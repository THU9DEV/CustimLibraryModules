local TaskScheduler = require(game.ReplicatedStorage.TaskScheduler)

local scheduler = TaskScheduler.new()

-- Add a one-time task
scheduler:AddTask("Task1", 5, function()
    print("Task1 executed after 5 seconds")
end)

-- Add a repeating task
scheduler:AddTask("RepeatingTask", 0, function()
    print("Repeating task executed every 3 seconds")
end, true, 3)

-- Add a high-priority task
scheduler:AddTask("HighPriorityTask", 2, function()
    print("High priority task executed after 2 seconds")
end, false, 0, 10)

-- In the game loop, call Update() to process tasks
while true do
    scheduler:Update()
    wait(0.1) -- Adjust this wait time based on your game's needs
end
