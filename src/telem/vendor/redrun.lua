--- RedRun - A very tiny background task runner using the native top-level coroutine
-- By JackMacWindows
-- Licensed under CC0, though I'd appreciate it if this notice was left in place.
-- @module redrun

-- Note: RedRun is not intended for use as a fully-featured multitasking environment. It is meant
-- to allow running small asynchronous tasks that just listen for events and respond (like
-- rednet.run does). While it is certainly possible to use this to make a functioning kernel, you
-- should not do this as a) any time spent in the processes is time taken from Rednet, and b) there
-- is no filtering for user-initiated events, or automatic terminal redirect handling.
-- Yes: Background network file transfer, asynchronous GPS host, remote shell host (if implemented correctly)
-- No: Window server, multishell, music player

local expect = require "cc.expect".expect

local redrun = {}
local coroutines = {}

--- Initializes the RedRun runtime. This is called automatically, but it's still available if desired.
-- @param silent Set to any truthy value to inhibit the status message.
function redrun.init(silent)
    local env = getfenv(rednet.run)
    if env.__redrun_coroutines then
        -- RedRun was already initialized, so just grab the coroutine table and run
        coroutines = env.__redrun_coroutines
    else
        -- For the actual code execution, we go through os.pullEventRaw which is the only function called unconditionally each loop
        -- To avoid breaking real os, we set this through the environment of the function
        -- We also use a metatable to avoid writing every other function out
        env.os = setmetatable({
            pullEventRaw = function()
                local ev = table.pack(coroutine.yield())
                local delete = {}
                for k,v in pairs(coroutines) do
                    if v.terminate or v.filter == nil or v.filter == ev[1] or ev[1] == "terminate" then
                        local ok
                        if v.terminate then ok, v.filter = coroutine.resume(v.coro, "terminate")
                        else ok, v.filter = coroutine.resume(v.coro, table.unpack(ev, 1, ev.n)) end
                        if not ok or coroutine.status(v.coro) ~= "suspended" or v.terminate then delete[#delete+1] = k end
                    end
                end
                for _,v in ipairs(delete) do coroutines[v] = nil end
                return table.unpack(ev, 1, ev.n)
            end
        }, {__index = os, __isredrun = true})
        -- Add the coroutine table to the environment to be fetched by init later
        env.__redrun_coroutines = coroutines
        if not silent then print("Successfully registered RedRun.") end
    end
end

--- Starts a coroutine running in the background.
-- @param func The function to run.
-- @param name A value to use to identify this task later. Can be any value, including nil/none.
-- @return The ID of the started task.
function redrun.start(func, name)
    expect(1, func, "function")
    local id = #coroutines+1
    coroutines[id] = {coro = coroutine.create(func), name = name}
    return id
end

--- Returns the task ID for a named task.
-- @param name The name of the task.
-- @return The ID of the task with the name, or nil if not found.
function redrun.getid(name)
    for k,v in pairs(coroutines) do if v.name == name then return k end end
    return nil
end

--- Returns a table of custom state held by the task.
-- @param id The ID of the task.
-- @return The state table held by the task, or nil if the task doesn't exist.
function redrun.getstate(id)
    expect(1, id, "number")
    if coroutines[id] == nil then return nil end
    coroutines[id].state = coroutines[id].state or {}
    return coroutines[id].state
end

--- Kills a task immediately.
-- @param id The ID of the task.
function redrun.kill(id)
    expect(1, id, "number")
    coroutines[id] = nil
end

--- Terminates a task. This sends it one terminate event, and then removes it from the queue.
-- @param id The ID of the task.
function redrun.terminate(id)
    expect(1, id, "number")
    if coroutines[id] == nil then error("Task ID " .. id .. " is not running", 2) end
    coroutines[id].terminate = true
    os.queueEvent("redrun_pause")
    while true do
        local ev = table.pack(os.pullEvent())
        if ev[1] == "redrun_pause" then break
        else os.queueEvent(table.unpack(ev, 1, ev.n)) end
    end
end

redrun.init(...)
return redrun