local class = require "ecnet2.class"
local random = require "ccryptolib.random"
local blake3 = require "ccryptolib.blake3"
local x25519 = require "ccryptolib.x25519"
local x25519c = require "ccryptolib.x25519c"
local addressEncoder = require "ecnet2.addressEncoder"
local Protocol = require "ecnet2.Protocol"

local ID_PATH = "id.bin"
local ID_DEL_PATH = "id.bin.del"
local ID_BACKUP_PATH = "id.bin.bak"
local ADDRESS_PATH = "address.txt"

local NOISE_SIZE = 512

--- @return string
local function mkNoise()
    local body = random.random(NOISE_SIZE - 32)
    local checksum = blake3.digest(body)
    return checksum .. body
end

--- @param noise string?
--- @return string?
local function mkKeyFromNoise(noise)
    if not noise then return end
    local checksum = blake3.digest(noise:sub(33))
    if noise:sub(1, 32) ~= checksum then return end
    return blake3.digest(noise)
end

--- @class ecnet2.Identity Identifies a peer to other connected devices.
--- @field _msk string The masked secret key for the identity.
--- @field _pk string The public key for the identity.
--- @field address string The address for connecting to this device
local Identity = class "ecnet2.Identity"

--- @param path string
function Identity:initialise(path)
    local idPath = fs.combine(path, ID_PATH)
    local idDelPath = fs.combine(path, ID_DEL_PATH)
    local idBackupPath = fs.combine(path, ID_BACKUP_PATH)
    local addressPath = fs.combine(path, ADDRESS_PATH)

    --#region critical section on the directory
    fs.makeDir(path)
    if fs.exists(idDelPath) then
        fs.delete(path)
        fs.makeDir(path)
    end

    local noise
    if fs.exists(idPath) then
        local f = assert(fs.open(idPath, "rb"))
        noise = f.readAll()
        f.close()
    else
        noise = mkNoise()
        local f = assert(fs.open(idDelPath, "wb"))
        f.write(noise)
        f.close()
        fs.copy(idDelPath, idBackupPath)
        fs.move(idDelPath, idPath)
    end

    local sk = assert(mkKeyFromNoise(noise), "identity file is corrupted")
    local pk = x25519.publicKey(sk)
    local addr = addressEncoder.encode(pk)
    local f = assert(fs.open(addressPath, "wb"))
    f.write(addr)
    f.close()
    --#endregion

    self._msk = x25519c.mask(sk)
    self._pk = pk
    self.address = addr
end

--- Creates a protocol from a given interface on this identity.
--- @return ecnet2.Protocol
function Identity:Protocol(interface)
    return Protocol(interface, self)
end

return Identity
