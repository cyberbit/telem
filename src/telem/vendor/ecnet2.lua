local constants = require "ecnet2.constants"
local Identity = require "ecnet2.Identity"
local modems = require "ecnet2.modems"
local Protocol = require "ecnet2.Protocol"

local module = {}

--- @type ecnet2.Identity?
local identity

local function fetchIdentity()
    if not identity then identity = Identity(constants.IDENTITY_PATH) end
    return identity
end

--- Returns the address for this device.
--- @return string address The address.
function module.address()
    return fetchIdentity().address
end

module.open = modems.open
module.close = modems.close
module.isOpen = modems.isOpen

--- Creates a protocol from a given interface.
--- @param interface ecnet2.IProtocol A table describing the protocol.
--- @return ecnet2.Protocol protocol The resulting protocol.
function module.Protocol(interface)
    return Protocol(interface, fetchIdentity())
end

return module
