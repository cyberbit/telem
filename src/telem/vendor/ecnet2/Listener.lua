local class = require "ecnet2.class"
local uid = require "ecnet2.uid"
local blake3 = require "ccryptolib.blake3"
local ecnetd = require "ecnet2.ecnetd"
local modems = require "ecnet2.modems"
local HandshakeState = require "ecnet2.HandshakeState"
local Connection = require "ecnet2.Connection"

--- A listener for incoming connection requests.
--- @class ecnet2.Listener
--- @field _protocol ecnet2.Protocol The listener's protocol.
--- @field _psk string The PSK for incoming connections in this listener.
--- @field _handler function The packet handler function.
--- @field _processed table<string, ecnet2.Connection> Processed connections.
--- @field id string The connection's ID, used in `ecnet2_message` events.
local Listener = class "ecnet2.Listener"

--- @param protocol ecnet2.Protocol
function Listener:initialise(protocol)
    self.id = uid()
    self._psk = blake3.digest(protocol._identity._pk .. protocol._hash)
    self._protocol = protocol
    self._processed = setmetatable({}, { __mode = "v" })
    self._handler = function(m, s) return self:_handle(m, s) end
    local descriptor = blake3.digest(self._psk)
    ecnetd.handlers[descriptor] = self._handler
end

--- Handles an incoming packet.
--- @param packet string
--- @param side string
function Listener:_handle(packet, side)
    local request = { _lid = self.id, _nid = side, _packet = packet }
    os.queueEvent("ecnet2_request", self.id, request, side)
end

--- Accepts a request and builds a connection. Waits for the next request if
--- none are provided.
---
--- Throws `"invalid listener for this request"` if the supplied request isn't
--- meant for this listener.
---
--- Returns a dummy connection if the request is malformed, or if the request
--- has already been accepted.
---
--- @param reply any
--- @param request table?
--- @return ecnet2.Connection
function Listener:accept(reply, request)
    -- Wait for the request if not given.
    while not request do
        local _, id, req = os.pullEvent("ecnet2_request")
        if id == self.id then request = req end
    end

    -- If the tag has already been processed, return a dummy connection. 
    local tag = HandshakeState.getTag(request._packet)
    if self._processed[tag] then
        return Connection(HandshakeState.close(), self._protocol, request._nid)
    end

    assert(request._lid == self.id, "invalid listener for this request")

    local msk = self._protocol._identity._msk
    local pk = self._protocol._identity._pk
    local state = HandshakeState.rA(msk, pk, "", self._psk, request._packet)

    local str = self._protocol._interface.serialize(reply)
    assert(type(str) == "string", "serializer returned non-string")
    assert(#str <= state.maxlen, "serialized message is too large")
    local newState, packet = state.send(str)
    if packet then modems.transmit(request._nid, packet) end

    local connection = Connection(newState, self._protocol, request._nid)
    self._processed[tag] = connection
    return connection
end

return Listener
