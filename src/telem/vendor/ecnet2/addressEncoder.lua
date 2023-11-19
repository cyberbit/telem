local expect = require "cc.expect"

local band = bit32.band

local alphabet = {}
local ralphabet = {}
do
    local s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    for i, ch in (s):gmatch("()(.)") do
        alphabet[i - 1] = ch
        ralphabet[ch] = i - 1
    end
end

--- Encodes a public key to an address.
--- @param publicKey string The 32-byte public key.
--- @return string address The encoded address.
local function encode(publicKey)
    expect(1, publicKey, "string")
    assert(#publicKey == 32, "invalid public key")
    publicKey = publicKey .. "\0"
    local out = ""
    for block in (publicKey):gmatch("...") do
        local val = (">I3"):unpack(block)
        local mul = 2 ^ -18
        for _ = 0, 18, 6 do
            out = out .. alphabet[band(val * mul, 63)]
            mul = mul * 64
        end
    end
    return out:sub(1, 43) .. "="
end

--- Decodes an address to a public key.
--- @param address string The address to decode.
--- @return string? publicKey The decoded public key, or nil on failure.
local function parse(address)
    if type(address) ~= "string" then return end
    if #address ~= 44 then return end
    if not address:match("^[A-Za-z0-9%-_]*=$") then return end
    address = address:sub(1, 43) .. "A"
    local bytes = ""
    for block in address:gmatch("....") do
        local val = 0
        for i = 1, 4 do val = val * 64 + ralphabet[block:sub(i, i)] end
        bytes = bytes .. (">I3"):pack(val)
    end
    return bytes:sub(1, 32)
end

return {
    encode = encode,
    parse = parse,
}
