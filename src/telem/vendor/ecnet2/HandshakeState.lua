local x25519c = require "ccryptolib.x25519c"
local x25519 = require "ccryptolib.x25519"
local SymmetricState = require "ecnet2.SymmetricState"

--- A handshake state.
--- @class ecnet2.HandshakeState
--- The other party's public key, if known.
--- @field pk string?
--- A descriptor to filter when receiving.
--- @field d string?
--- A function to call for resolving incoming messages. The argument shouldn't
--- include the descriptor. Returns the next state to use, and the decrypted
--- message or nil on failure.
--- @field resolve (fun(data: string): ecnet2.HandshakeState, string?)?
--- The largest length, in bytes, that send() will accept.
--- @field maxlen number
--- A function to call for sending messages. Returns the next state to use and
--- the raw data to send over the network.
--- @field send (fun(msg: string): ecnet2.HandshakeState, string?)?

--- Returns a dummy state that does nothing. Used for aborting handshakes.
--- @return ecnet2.HandshakeState
local function close()
    return {
        maxlen = math.huge,
        send = function()
            return close(), nil
        end,
    }
end

--- Pads a message to partially hide its length.
--- @param msg string The input message.
--- @param prefixlen number The size of a prefix that will be added afterwards.
--- @param minlen number The minimum length to pad the message into.
local function pad(msg, prefixlen, minlen)
    local l = math.max(#msg + prefixlen + 2, minlen)
    local e = math.floor(math.log(l, 2))
    local s = math.floor(math.log(e, 2)) + 1
    local w = l + -l % 2 ^ (e - s)
    local p = math.min(w, 2 ^ 16) - #msg - prefixlen - 2
    return msg .. "\x80" .. ("\0"):rep(p)
end

--- Unpads a padded message.
--- @param msg string? The padded message, or nil for failure propagation.
--- @return string? unpadded The unpadded message, or nil on failure.
local function unpad(msg)
    if not msg then return end
    for i = #msg, 1, -1 do
        local b = msg:byte(i)
        if b == 0 then
        elseif b == 0x80 then
            return msg:sub(1, i - 1)
        else
            return
        end
    end
end

--- Creates the transport state.
--- @param pk string The remote party's public key.
--- @param localCs ecnet2.CipherState The local party's cipher state.
--- @param remoteCs ecnet2.CipherState The remote party's cipher state.
--- @return ecnet2.HandshakeState
local function Transport(pk, localCs, remoteCs)
    local out = {}

    out.pk = pk
    out.d = localCs:descriptor()
    out.maxlen = 2 ^ 16 - 1 - 32 - 1 - 1 - 16

    function out.resolve(data)
        if #data < 16 then return close() end
        local m = unpad(localCs:decryptWithAd("", data))
        localCs:rekey()
        if not m then return close() end
        return Transport(pk, localCs, remoteCs), m
    end

    function out.send(msg)
        local d = remoteCs:descriptor()
        local ctx = remoteCs:encryptWithAd("", pad(msg, 32 + 16, 192))
        remoteCs:rekey()
        return Transport(pk, localCs, remoteCs), d .. ctx
    end

    return out
end

--- Creates the responder state for message C (-> s, se).
--- @param msk string The responder's masked secret key.
--- @param symmetricState ecnet2.SymmetricState The handshake's symmetric state.
--- @return ecnet2.HandshakeState
local function rC(msk, symmetricState)
    local out = {}

    out.d = symmetricState:descriptor()

    function out.resolve(data)
        if #data < 64 then return close() end

        local pk = symmetricState:decryptAndHash(data:sub(1, 48))
        if not pk then return close() end

        symmetricState:mixKey(x25519.exchange(x25519c.ephemeralSk(msk), pk))

        local xm = unpad(symmetricState:decryptAndHash(data:sub(49)))
        if not xm then return close() end
        local ok, m = pcall(string.unpack, "<s2", xm)
        if not ok then return close() end

        local iCs, rCs = symmetricState:split()
        return Transport(pk, rCs, iCs), m
    end

    return out
end

--- Creates the initiator state for message C (-> s, se).
--- @param iPk string The initiator's static public key.
--- @param rPk string The responder's static public key.
--- @param se string The static-ephemeral shared secret for this handshake.
--- @param symmetricState ecnet2.SymmetricState The handshake's symmetric state.
--- @return ecnet2.HandshakeState
local function iC(iPk, rPk, se, symmetricState)
    local out = {}

    out.maxlen = 2 ^ 15 - 1
    out.pk = rPk

    function out.send(msg)
        local d = symmetricState:descriptor()

        local pkCtx = symmetricState:encryptAndHash(iPk)

        symmetricState:mixKey(se)
        local xmsg = ("<s2"):pack(msg)
        local ctx = symmetricState:encryptAndHash(pad(xmsg, 32 + 48 + 16, 192))
        local iCs, rCs = symmetricState:split()
        return Transport(rPk, iCs, rCs), d .. pkCtx .. ctx
    end

    return out
end

--- Creates the initiator state for message B (<- e, ee)
--- @param msk string The initiator's masked secret key.
--- @param iPk string The initiator's static public key.
--- @param rPk string The responder's static public key.
--- @param symmetricState ecnet2.SymmetricState The handshake's symmetric state.
--- @return ecnet2.HandshakeState
local function iB(msk, iPk, rPk, symmetricState)
    local out = {}

    out.d = symmetricState:descriptor()

    function out.resolve(data)
        if #data < 64 then return close() end

        local e = symmetricState:decryptAndHash(data:sub(1, 48))
        if not e then return close() end

        local se, ee = x25519c.exchange(msk, e)
        symmetricState:mixKey(ee)

        local xm = unpad(symmetricState:decryptAndHash(data:sub(49)))
        if not xm then return close() end
        local ok, msg = pcall(string.unpack, "<s2", xm)
        if not ok then return close() end

        return iC(iPk, rPk, se, symmetricState), msg
    end

    return out
end

--- Creates the responder state for message B (<- e, ee).
--- @param msk string The responder's masked secret key.
--- @param ee string The ephemeral-ephemeral shared secret for this handshake.
--- @param symmetricState ecnet2.SymmetricState The handshake's symmetric state.
--- @return ecnet2.HandshakeState
local function rB(msk, ee, symmetricState)
    local out = {}

    out.maxlen = 2 ^ 15 - 1

    function out.send(msg)
        local d = symmetricState:descriptor()

        local e = x25519.publicKey(x25519c.ephemeralSk(msk))
        local eCtx = symmetricState:encryptAndHash(e)

        symmetricState:mixKey(ee)
        local xmsg = ("<s2"):pack(msg)
        local ctx = symmetricState:encryptAndHash(pad(xmsg, 32 + 48 + 16, 192))

        return rC(msk, symmetricState), d .. eCtx .. ctx
    end

    return out
end

--- Initializes a handshake as the responder, resolving message A (-> e, es).
--- @param msk string The responder's masked secret key.
--- @param rPk string The responder's static public key.
--- @param prologue string The handshake prologue.
--- @param introPsk string A pre-shared key resolved in the introduction.
--- @param data string The incoming network message, without the intro prefix.
--- @return ecnet2.HandshakeState
local function rA(msk, rPk, prologue, introPsk, data)
    if #data < 64 then return close() end

    msk = x25519c.remask(msk)

    local symmetricState = SymmetricState()
    symmetricState:mixHash(prologue)
    symmetricState:mixHash(rPk)
    symmetricState:mixKeyAndHash(introPsk)

    local eCtx = data:sub(1, 48)
    local e = symmetricState:decryptAndHash(eCtx)
    if not e then return close() end

    local es, ee = x25519c.exchange(msk, e)
    symmetricState:mixKey(es)

    local m = unpad(symmetricState:decryptAndHash(data:sub(49)))
    if not m then return close() end

    return rB(msk, ee, symmetricState)
end

--- Returns a unique tag for a given (valid) connection request packet.
--- @param data string The incoming network message, without the intro prefix.
--- @return string tag A unique tag for this request.
local function getTag(data)
    if #data < 64 then return "" end
    return data:sub(33, 48)
end

--- Initializes a handshake as the initiator, sending message A (-> e, es).
--- @param msk string The initiator's masked secret key.
--- @param iPk string The initiator's static public key.
--- @param rPk string The responder's static public key.
--- @param prologue string The handshake prologue.
--- @param introPsk string A pre-shared key resolved in the introduction.
--- @return ecnet2.HandshakeState
--- @return string data The raw data to send over the network.
local function iA(msk, iPk, rPk, prologue, introPsk)
    msk = x25519c.remask(msk)

    local symmetricState = SymmetricState()
    symmetricState:mixHash(prologue)
    symmetricState:mixHash(rPk)
    symmetricState:mixKeyAndHash(introPsk)

    local esk = x25519c.ephemeralSk(msk)
    local eCtx = symmetricState:encryptAndHash(x25519.publicKey(esk))

    symmetricState:mixKey(x25519.exchange(esk, rPk))
    local ctx = symmetricState:encryptAndHash(pad("", 32 + 48 + 16, 192))

    return iB(msk, iPk, rPk, symmetricState), eCtx .. ctx
end

return {
    iA = iA,
    rA = rA,
    getTag = getTag,
    close = close,
}
