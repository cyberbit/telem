local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local vendor
local ecnet2
local random
local lualzw

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local SecureModemOutputAdapter = o.class(OutputAdapter)
SecureModemOutputAdapter.type = 'SecureModemOutputAdapter'

SecureModemOutputAdapter.VERSION = 'v2.0.0'

SecureModemOutputAdapter.REQUEST_PREAMBLE = 'telem://'
SecureModemOutputAdapter.REQUESTS = {
    GET_COLLECTION = SecureModemOutputAdapter.REQUEST_PREAMBLE .. SecureModemOutputAdapter.VERSION .. '/collection',
}

function SecureModemOutputAdapter:constructor (peripheralName)
    self:super('constructor')

    self.protocol = nil
    self.connections = {}

    -- TODO test modem disconnect recovery
    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)

        if not vendor then
            self:dlog('SecureModemOutput:boot :: Loading vendor modules...')

            vendor = require 'telem.vendor'

            self:dlog('SecureModemOutput:boot :: Vendor modules ready.')
        end

        if not random then
            self:dlog('SecureModemOutput:boot :: Loading ccryptolib.random...')

            random = vendor.ccryptolib.random

            self:dlog('SecureModemOutput:boot :: ccryptolib.random ready.')
        end

        -- lazy load because it is slow
        if not ecnet2 then
            t.log('SecureModemOutput:boot :: Loading ECNet2...')

            ecnet2 = vendor.ecnet2

            -- TODO fallback initializer when http not available
            local postHandle = assert(http.post("https://krist.dev/ws/start", "{}"))
            local data = textutils.unserializeJSON(postHandle.readAll())
            postHandle.close()
            random.init(data.url)
            http.websocket(data.url).close()
            
            t.log('SecureModemOutput:boot :: ECNet2 ready. Address = ' .. ecnet2.address())
        end

        if not lualzw then
            self:dlog('SecureModemOutput:boot :: Loading lualzw...')

            lualzw = vendor.lualzw

            self:dlog('SecureModemOutput:boot :: lualzw ready.')
        end

        self:dlog('SecureModemOutput:boot :: Opening modem...')

        ecnet2.open(peripheralName)

        if not self.protocol then
            self:dlog('SecureModemOutput:boot :: Initializing protocol...')

            self.protocol = ecnet2.Protocol {
                name = "telem",
                serialize = textutils.serialize,
                deserialize = textutils.unserialize,
            }
        end

        self:dlog('SecureModemOutput:boot :: Boot complete.')
    end)()

    -- register async adapter
    self:setAsyncCycleHandler(function (backplane)
        local listener = self.protocol:listen()

        self:dlog('SecureModemOutput:asyncCycleHandler :: Listener started')

        while true do
            local event, id, p2, p3 = os.pullEvent()

            if event == "ecnet2_request" and id == listener.id then
                self:dlog('SecureModemOutput:asyncCycleHandler :: received connection from ' .. id)

                self:dlog('SecureModemOutput:asyncCycleHandler :: sending ack...')

                local connection = listener:accept('telem ' .. self.VERSION, p2)

                self.connections[connection.id] = connection

                self:dlog('SecureModemOutput:asyncCycleHandler :: ack sent, connection ' .. connection.id .. ' cached')
            elseif event == "ecnet2_message" and self.connections[id] then
                self:dlog('SecureModemOutput:asyncCycleHandler :: received request from ' .. p2)

                if p3 == self.REQUESTS.GET_COLLECTION then
                    self:dlog('SecureModemOutput:asyncCycleHandler :: request = GET_COLLECTION')

                    local payload = backplane.collection:pack()

                    -- use compression for payloads with > 256 metrics
                    if #payload.m > 256 then
                        self:dlog('SecureModemOutput:asyncCycleHandler :: compressing large payload...')

                        payload = lualzw.compress(textutils.serialize(payload, { compact = true }))
                    end

                    self.connections[id]:send(payload)

                    self:dlog('SecureModemOutput:asyncCycleHandler :: response sent')
                else
                    t.log('SecureModemOutput: Unknown request: ' .. tostring(p3))
                end
            end
        end
    end)
end

function SecureModemOutputAdapter:write (collection)
    self:boot()

    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    -- no op, all async :)
end

return SecureModemOutputAdapter