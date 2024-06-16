local class = require "ecnet2.class"
local blake3 = require "ccryptolib.blake3"
local CipherState = require "ecnet2.CipherState"

--- A symmetric state containing keys and a handshake transcript hash.
--- @class ecnet2.SymmetricState
--- @field private h string The current handshake transcript hash.
--- @field private ck string The current chaining key for deriving other keys.
--- @field private cs ecnet2.CipherState The current encryption CipherState.
local SymmetricState = class "ecnet2.SymmetricState"

-- We modify Noise so much that it's meaningless to use their naming standard.
local PROTOCOL_NAME = blake3.digest
    "ecnet2 2023-01-03 04:16 UTC network handshake protocol"

local DESCRIPTOR_KDF = blake3.deriveKey
    "ecnet2 2023-01-05 00:00 UTC handshake descriptor context"

function SymmetricState:initialise()
    self.h = PROTOCOL_NAME
    self.ck = PROTOCOL_NAME
    self.cs = CipherState(nil)
end

--- Mixes keying material into the key and the transcript hash.
--- @param material string
function SymmetricState:mixKeyAndHash(material)
    local tk = blake3.digestKeyed(self.ck, material, 96)
    self.ck = tk:sub(1, 32)
    self:mixHash(tk:sub(33, 64))
    self.cs = CipherState(tk:sub(65))
end

--- Mixes keying material into the key.
--- @param material string
function SymmetricState:mixKey(material)
    local tk = blake3.digestKeyed(self.ck, material, 64)
    self.ck = tk:sub(1, 32)
    self.cs = CipherState(tk:sub(33))
end

--- Mixes data into the transcript hash.
--- @param data string
--- @return string data The input data.
function SymmetricState:mixHash(data)
    self.h = blake3.digest(self.h .. data)
    return data
end

--- Returns the current transcript hash.
--- @return string hash The handshake transcript hash.
function SymmetricState:getHandshakeHash()
    return self.h
end

--- Encrypts data and adds it to the transcript.
--- @param plaintext string The plaintext to encrypt.
--- @return string ciphertext The encrypted plaintext 
function SymmetricState:encryptAndHash(plaintext)
    local ciphertext = self.cs:encryptWithAd(self.h, plaintext)
    return self:mixHash(ciphertext)
end

--- Adds data to the transcript and tries to decrypt it.
--- @param ciphertext string The ciphertext to decrypt.
--- @return string? plaintext The decrypted plaintext, or nil on failure.
function SymmetricState:decryptAndHash(ciphertext)
    local plaintext = self.cs:decryptWithAd(self.h, ciphertext)
    self:mixHash(ciphertext)
    return plaintext
end

--- Returns the current descriptor for the state.
--- @return string descriptor The descriptor.
function SymmetricState:descriptor()
    return DESCRIPTOR_KDF(self.ck .. self.h)
end

--- Splits the state into two cipher states, finishing the handshake.
--- @return ecnet2.CipherState, ecnet2.CipherState
function SymmetricState:split()
    local tk = blake3.digestKeyed(self.ck, "", 64)
    return CipherState(tk:sub(1, 32)), CipherState(tk:sub(33))
end

return SymmetricState
