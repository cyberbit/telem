local class = require "ecnet2.class"
local ecnetd = require "ecnet2.ecnetd"
local addressEncoder = require "ecnet2.addressEncoder"
local modems = require "ecnet2.modems"
local uid = require "ecnet2.uid"

--- An encrypted tunnel operating over a modem.
--- @class ecnet2.Connection
--- @field _state ecnet2.HandshakeState The current handshake state.
--- @field _protocol ecnet2.Protocol The connection's protocol.
--- @field _side string The modem name this connection is routing through.
--- @field _handler function The packet handler function.
--- @field id string The connection's ID, used in `ecnet2_message` events.
local Connection = class "ecnet2.Connection"

--- @param state ecnet2.HandshakeState
--- @param protocol ecnet2.Protocol
--- @param side string
function Connection:initialise(state, protocol, side)
    self.id = uid()
    self._protocol = protocol
    self._side = side
    self._handler = function(m, _) return self:_handle(m, _) end
    self._state = state
    if state.d then ecnetd.handlers[state.d] = self._handler end
end

--- @param newState ecnet2.HandshakeState
function Connection:_setState(newState)
    if self._state.d then ecnetd.handlers[self._state.d] = nil end
    if newState.d then ecnetd.handlers[newState.d] = self._handler end
    self._state = newState
end

--- Handles an incoming packet, modifying the state.
--- @param packet string
--- @param _ string
function Connection:_handle(packet, _)
    local newState, msg = self._state.resolve(packet)
    self:_setState(newState)
    if not msg then return end
    local deserialize = self._protocol._interface.deserialize
    local ok, message = pcall(deserialize, msg)
    if ok then
        os.queueEvent("ecnet2_message", self.id, self._state.pk, message)
    end
end

--- Sends a message.
---
--- Throws `"can't send on an incomplete connection"` until at least one
--- message has been received.
---
--- @param message any The message object.
function Connection:send(message)
    local str = self._protocol._interface.serialize(message)
    assert(type(str) == "string", "serializer returned non-string")
    assert(self._state.maxlen, "can't send on an incomplete connection")
    assert(#str <= self._state.maxlen, "serialized message is too large")
    local newState, data = self._state.send(str)
    self:_setState(newState)
    if data then modems.transmit(self._side, data) end
end

--- Yields until a message is received. Returns the sender and contents, or nil
--- on timeout.
--- @param timeout number?
--- @return string? sender
--- @return any message
function Connection:receive(timeout)
    local timer = -1
    if timeout then timer = os.startTimer(timeout) end
    while true do
        local event, p1, p2, p3 = os.pullEvent()
        if event == "timer" and p1 == timer then
            return
        elseif event == "ecnet2_message" and p1 == self.id then
            os.cancelTimer(timer)
            return addressEncoder.encode(p2), p3
        end
    end
end

return Connection
