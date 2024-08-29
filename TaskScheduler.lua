type Task = {
    Id: string,
    Delay: number,
    Callback: () -> (),
    IsRepeating: boolean,
    Interval: number,
    Priority: number,
    NextRun: number,

    Run: (self: Task) -> boolean?
}

type TaskScheduler = {
    Tasks: {Task},

    new: () -> TaskScheduler,
    AddTask: (self: TaskScheduler, id: string, delay: number, callback: () -> (), isRepeating: boolean?, interval: number?, priority: number?) -> (),
    RemoveTask: (self: TaskScheduler, id: string) -> (),
    Update: (self: TaskScheduler) -> ()
}


local TaskScheduler: TaskScheduler = {}
TaskScheduler.__index = TaskScheduler


local Task: Task = {}
Task.__index = Task


function Task.new(id: string, delay: number, callback: () -> (), isRepeating: boolean?, interval: number?, priority: number?): Task
    local self: Task = setmetatable({}, Task)
    self.Id = id
    self.Delay = delay
    self.Callback = callback
    self.IsRepeating = isRepeating or false
    self.Interval = interval or 0
    self.Priority = priority or 1
    self.NextRun = tick() + delay
    return self
end

function Task:Run(): boolean?
    self.Callback()
    if self.IsRepeating then
        self.NextRun = tick() + self.Interval
    else
        return true -- Indicate that the task should be removed
    end
end


function TaskScheduler.new(): TaskScheduler
    local self: TaskScheduler = setmetatable({}, TaskScheduler)
    self.Tasks = {}
    return self
end


function TaskScheduler:AddTask(id: string, delay: number, callback: () -> (), isRepeating: boolean?, interval: number?, priority: number?)
    local task: Task = Task.new(id, delay, callback, isRepeating, interval, priority)
    table.insert(self.Tasks, task)
    table.sort(self.Tasks, function(a: Task, b: Task): boolean
        return a.Priority > b.Priority
    end)
end


function TaskScheduler:RemoveTask(id: string)
    for i, task in ipairs(self.Tasks) do
        if task.Id == id then
            table.remove(self.Tasks, i)
            break
        end
    end
end


function TaskScheduler:Update()
    local now: number = tick()
    for i = #self.Tasks, 1, -1 do
        local task: Task = self.Tasks[i]
        if now >= task.NextRun then
            local remove: boolean? = task:Run()
            if remove then
                table.remove(self.Tasks, i)
            end
        end
    end
end

return TaskScheduler
