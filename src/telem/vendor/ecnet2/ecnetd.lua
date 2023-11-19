local redrun = require "redrun"
local constants = require "ecnet2.constants"

--- The global daemon state.
--- @class ecnet2.EcnetdState
--- @field handlers table<string, fun(etc: string, side: string)>
local state

--- @param message string
local function enqueue(message, side)
    if type(message) ~= "string" then return end
    if #message >= 2 ^ 16 then return end
    if #message < 32 then return end
    local descriptor = message:sub(1, 32)
    local etc = message:sub(33)
    local handler = state.handlers[descriptor]
    if handler then return handler(etc, side) end
end

local function ecnetd()
    while not state do coroutine.yield() end
    while true do
        local _, side, ch, _, msg = coroutine.yield("modem_message")
        if ch == constants.CHANNEL then enqueue(msg, side) end
    end
end

-- Spin up a daemon to handle incoming modem messages if none exist.
local id = redrun.getid("ecnetd")
if id then
    state = assert(redrun.getstate(id))
else
    id = redrun.start(ecnetd, "ecnetd")
    state = assert(redrun.getstate(id))
    state.handlers = setmetatable({}, { __mode = "v" })
end

return {
    handlers = state.handlers,
}
