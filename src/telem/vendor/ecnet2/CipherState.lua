local class = require "ecnet2.class"
local aead = require "ccryptolib.aead"
local chacha = require "ccryptolib.chacha20"

--- A symmetric encryption cipher state, containing a key and a numeric nonce.
--- @class ecnet2.CipherState
--- @field private k string? The current key.
--- @field private n number The current nonce.
local CipherState = class "ecnet2.CipherState"

--- @param key string? A 32-byte key to initialize the state with.
function CipherState:initialise(key)
    self.k = key
    self.n = 0
end

--- Whether the state has a key or not.
--- @return boolean
function CipherState:hasKey()
    return self.k ~= nil
end

--- Sets the nonce to the given value.
--- @param nonce number
function CipherState:setNonce(nonce)
    self.n = nonce
end

--- Rekeys the cipher.
function CipherState:rekey()
    self.k = chacha.crypt(self.k, ("<I12"):pack(2 ^ 64 - 1), ("\0"):rep(32), 8)
end

--- Computes the cipher descriptor.
--- @return string
function CipherState:descriptor()
    local c = chacha.crypt(self.k, ("<I12"):pack(2 ^ 64 - 1), ("\0"):rep(64), 8)
    return c:sub(33)
end

--- Encrypts a message. Returns the plaintext itself when no key is set.
--- @param ad string Associated data to authenticate.
--- @param plaintext string The plaintext to encrypt
--- @return string ciphertext The encrypted text.
function CipherState:encryptWithAd(ad, plaintext)
    if self:hasKey() then
        local nonce = ("<I12"):pack(self.n)
        local ctx, tag = aead.encrypt(self.k, nonce, plaintext, ad, 8)
        self.n = self.n + 1
        return ctx .. tag
    else
        return plaintext
    end
end

--- Decrypts a message.
--- @param ad string Associated data to authenticate.
--- @param ciphertext string The ciphertext to decrypt.
--- @return string? plaintext The decrypted plaintext, or nil on failure.
function CipherState:decryptWithAd(ad, ciphertext)
    if self:hasKey() then
        if #ciphertext < 16 then return end
        local ctx, tag = ciphertext:sub(1, -17), ciphertext:sub(-16)
        local nonce = ("<I12"):pack(self.n)
        -- On decryption failure, increment nonce and return nil.
        local plaintext = aead.decrypt(self.k, nonce, tag, ctx, ad, 8)
        self.n = self.n + 1
        return plaintext
    else
        return ciphertext
    end
end

return CipherState
