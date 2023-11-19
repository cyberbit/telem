local expect = require "cc.expect"
local constants = require "ecnet2.constants"

--- Opens a modem with the given peripheral name for exchanging messages.
--- @param modem string
local function open(modem)
    expect.expect(1, modem, "string")
    assert(peripheral.getType(modem) == "modem", "no such modem: " .. modem)
    peripheral.call(modem, "open", constants.CHANNEL)
end

--- Closes a modem with the given peripheral name, or all modems if not given.
--- @param modem string?
local function close(modem)
    expect.expect(1, modem, "string", "nil")
    if modem then
        assert(peripheral.getType(modem) == "modem", "no such modem: " .. modem)
        return peripheral.call(modem, "close", constants.CHANNEL)
    else
        peripheral.find("modem", close)
    end
end

--- Returns whether a modem is currently open, or any modem if not given.
--- @param modem string?
--- @return boolean
local function isOpen(modem)
    expect.expect(1, modem, "string", "nil")
    if modem then
        if peripheral.getType(modem) ~= "modem" then return false end
        return peripheral.call(modem, "isOpen", constants.CHANNEL)
    else
        return not not peripheral.find("modem", isOpen)
    end
end

--- Transmits a packet on all open modems.
--- @param side string
--- @param packet string
--- @return boolean
local function transmit(side, packet)
    return pcall(
        peripheral.call,
        side,
        "transmit",
        constants.CHANNEL,
        constants.CHANNEL,
        packet
    )
end

return {
    open = open,
    close = close,
    isOpen = isOpen,
    transmit = transmit,
}
