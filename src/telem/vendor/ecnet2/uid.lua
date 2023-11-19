--- Unique string ID generator.
-- It's just a random string concatenated to a counter. IDs are unique but not
-- uniformly random. Multiple instances of the generator are safe to use and
-- will be unique in relation to each other.

local random = require "ccryptolib.random"

local counter, suffix

--- Returns a unique ID
--- @return string uid A 32-byte unique string id.
return function()
    if not suffix or counter >= 2 ^ 32 then
        suffix = random.random(28)
        counter = 0
    end
    counter = counter + 1
    return ("<I4"):pack(counter) .. suffix
end
