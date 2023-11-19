local class = require "ecnet2.class"
local expect = require "cc.expect"
local HandshakeState = require "ecnet2.HandshakeState"
local addressEncoder = require "ecnet2.addressEncoder"
local blake3 = require "ccryptolib.blake3"
local Connection = require "ecnet2.Connection"
local Listener = require "ecnet2.Listener"
local modems = require "ecnet2.modems"

--- A namespace for interpreting messages received over connections.
--- @class ecnet2.Protocol
--- @field _interface ecnet2.IProtocol The underlying interface.
--- @field _identity ecnet2.Identity The protocol's identity.
--- @field _hash string The protocol name hash.
local Protocol = class "ecnet2.Protocol"

--- The interface for describing a new protocol.
--- @class ecnet2.IProtocol
--- @field name string The protocol's name.
--- @field serialize fun(obj: any): string The serializer for messages.
--- @field deserialize fun(str: string): any The deserializer for messages.

--- @param interface ecnet2.IProtocol
--- @param identity ecnet2.Identity The protocol's identity.
function Protocol:initialise(interface, identity)
    expect.field(interface, "name", "string")
    expect.field(interface, "serialize", "function")
    expect.field(interface, "deserialize", "function")
    self._interface = interface
    self._identity = identity
    self._hash = blake3.digest(interface.name)
end

--- Creates a new connection using this protocol and a modem side.
--- @param address string The responder's address.
--- @param modem string The modem name to connect through.
--- @return ecnet2.Connection
function Protocol:connect(address, modem)
    expect.expect(1, address, "string")
    expect.expect(2, modem, "string")
    assert(modems.isOpen(modem), "modem isn't open: " .. modem)
    local rpk = assert(addressEncoder.parse(address), "invalid address")
    local psk = blake3.digest(rpk .. self._hash)
    local descriptor = blake3.digest(psk)
    local msk = self._identity._msk
    local lpk = self._identity._pk
    local state, data = HandshakeState.iA(msk, lpk, rpk, "", psk)
    modems.transmit(modem, descriptor .. data)
    return Connection(state, self, modem)
end

--- Creates a listener for this protocol on all open modems.
--- @return ecnet2.Listener
function Protocol:listen()
    return Listener(self)
end

return Protocol
