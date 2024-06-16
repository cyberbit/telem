local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local vendor
local ecnet2
local random
local lualzw

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local SecureModemInputAdapter = o.class(InputAdapter)
SecureModemInputAdapter.type = 'SecureModemInputAdapter'

SecureModemInputAdapter.VERSION = 'v2.0.0'

SecureModemInputAdapter.REQUEST_PREAMBLE = 'telem://'
SecureModemInputAdapter.REQUESTS = {
    GET_COLLECTION = SecureModemInputAdapter.REQUEST_PREAMBLE .. SecureModemInputAdapter.VERSION .. '/collection',
}

function SecureModemInputAdapter:constructor (peripheralName, address)
    self:super('constructor')

    self.inputAddress = address
    self.protocol = nil
    self.connection = nil

    self.receiveTimeout = 1

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)

        if not vendor then
            self:dlog('SecureModemInput:boot :: Loading vendor modules...')

            vendor = require 'telem.vendor'

            self:dlog('SecureModemInput:boot :: Vendor modules ready.')
        end

        if not random then
            self:dlog('SecureModemInput:boot :: Loading ccryptolib.random...')

            random = vendor.ccryptolib.random

            self:dlog('SecureModemInput:boot :: ccryptolib.random ready.')
        end

        -- lazy load because it is slow
        if not ecnet2 then
            self:dlog('SecureModemInput:boot :: Loading ECNet2...')

            ecnet2 = vendor.ecnet2

            -- TODO fallback initializer when http not available
            local postHandle = assert(http.post("https://krist.dev/ws/start", "{}"))
            local data = textutils.unserializeJSON(postHandle.readAll())
            postHandle.close()
            random.init(data.url)
            http.websocket(data.url).close()
            
            self:dlog('SecureModemInput:boot :: ECNet2 ready. Address = ' .. ecnet2.address())
        end

        if not lualzw then
            self:dlog('SecureModemInput:boot :: Loading lualzw...')

            lualzw = vendor.lualzw

            self:dlog('SecureModemInput:boot :: lualzw ready.')
        end

        self:dlog('SecureModemInput:boot :: Opening modem...')

        ecnet2.open(peripheralName)

        self:dlog('SecureModemInput:boot :: Initializing protocol...')

        self.protocol = ecnet2.Protocol {
            name = "telem",
            serialize = textutils.serialize,
            deserialize = textutils.unserialize,
        }

        self:dlog('SecureModemInput:boot :: Boot complete.')
    end)()
end

function SecureModemInputAdapter:read ()
    local _, modem = next(self.components)
    local peripheralName = getmetatable(modem).name

    local connect = function ()
        self:dlog('SecureModemInput:read :: connecting to ' .. self.inputAddress)

        -- TODO come up with better catch mekanism here
        self.connection = self.protocol:connect(self.inputAddress, peripheralName)

        local ack = select(2, self.connection:receive(3))

        if ack then
            self:dlog('SecureModemInput:read :: remote ack: ' .. ack)

            -- TODO this is dumb way, make good way
            if ack ~= 'telem ' .. self.VERSION then
                t.log('SecureModemInput:read :: protocol mismatch: telem ' .. self.VERSION .. ' => ' .. ack)
                return false
            end

            self:dlog('SecureModemInput:read :: connection established')
            return true
        end

        t.log('SecureModemInput:read :: ECNet2 connection failed. Please verify remote server is running.')

        self.connection = nil

        return false
    end

    self:dlog('SecureModemInput:read :: connected? ' .. tostring(self.connection))

    if not self.connection and not connect() then
        return MetricCollection()
    end
    
    self:dlog('SecureModemInput:read :: sending request to ' .. self.inputAddress)

    local sendResult, errorResult = pcall(self.connection.send, self.connection, self.REQUESTS.GET_COLLECTION)

    if not sendResult then
        self:dlog('SecureModemInput:read :: Connection stale, retrying next cycle')
        self.connection = nil
        return MetricCollection()
    end

    self:dlog('SecureModemInput:read :: listening for response')
    local sender, message = self.connection:receive(self.receiveTimeout)

    if not sender then
        t.log('SecureModemInput:read :: Receive timed out after ' .. self.receiveTimeout .. ' seconds, retrying next cycle')

        self.connection = nil

        return MetricCollection()
    end

    local unwrapped = message
    
    -- decompress if needed
    if type(message) == 'string' and string.sub(message, 1, 1) == 'c' then
        unwrapped = textutils.unserialize(lualzw.decompress(message))
    end

    local unpacked = MetricCollection.unpack(unwrapped)

    self:dlog('SecureModemInput:read :: response received')

    return unpacked
end

return SecureModemInputAdapter