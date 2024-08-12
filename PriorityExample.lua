-- Load the Priority module from a remote source
local Priority = loadstring(game:HttpGet("https://raw.githubusercontent.com/THU9DEV/CustimLibraryModules/main/Priority.lua"))()

-- Define a utility table for organizing functions
local utils = {}
utils.__index = utils

-- Define the AutoFarm function, which uses the Priority system to control its execution
utils.Autofarm = function(v, Priority)
    -- Check if "AutoFarm" is the active priority
    if not Priority:isActive("AutoFarm") then
        return  -- If not, exit the function
    end

    -- Start the AutoFarm loop, which runs repeatedly until stopped
    while task.wait(0.1) do
        -- AutoFarm logic goes here (this is just an example)
        repeat
            print("AutoFarming for", v)  -- Print a message indicating AutoFarm is running
        until not v.Active  -- Continue farming until the 'Active' condition is false

        -- Check if the priority has changed during the loop
        if not Priority:isActive("AutoFarm") then
            print("AutoFarm stopped due to priority change.")  -- Inform that AutoFarm is stopping
            break  -- Exit the loop if "AutoFarm" is no longer the active priority
        end
    end
end

-- Define the AutoCollect function, similar to AutoFarm but for item collection
function utils.AutoCollect(Priority)
    -- Check if "AutoCollect" is the active priority
    if not Priority:isActive("AutoCollect") then
        return  -- If not, exit the function
    end

    -- Start the AutoCollect loop, which runs repeatedly until stopped
    while task.wait(0.1) do
        print("Collecting items...")  -- Print a message indicating AutoCollect is running

        -- Check if the priority has changed during the loop
        if not Priority:isActive("AutoCollect") then
            print("AutoCollect stopped due to priority change.")  -- Inform that AutoCollect is stopping
            break  -- Exit the loop if "AutoCollect" is no longer the active priority
        end
    end
end

-- Create and add a new priority class for AutoFarm with a weight of 10
local autoFarmPriority = Priority:addClass("AutoFarm", 10, {"AutoCollect"})

-- Create and add a new priority class for AutoCollect with a weight of 5
local autoCollectPriority = Priority:addClass("AutoCollect", 5, {"AutoFarm"})

-- Set AutoFarm as the initial active priority
Priority:set("AutoFarm")

-- Run the AutoFarm function in a separate thread
task.spawn(function()
    utils.AutoFarm(game.Players.LocalPlayer, Priority)
end)

-- After 5 seconds, change the active priority to AutoCollect and run AutoCollect
task.delay(5, function()
    Priority:set("AutoCollect")
    utils.AutoCollect(Priority)
end)

-- After another 5 seconds (10 seconds total), reset all priorities, stopping any active tasks
task.delay(10, function()
    Priority:reset()
    print("All priorities reset.")
end)
