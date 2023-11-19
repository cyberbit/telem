local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local vendor
local ecnet2
local random

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local SecureModemOutputAdapter = o.class(OutputAdapter)
SecureModemOutputAdapter.type = 'SecureModemOutputAdapter'

SecureModemOutputAdapter.VERSION = 'v1.0.0'

SecureModemOutputAdapter.REQUEST_PREAMBLE = 'telem://'
SecureModemOutputAdapter.REQUESTS = {
    GET_COLLECTION = SecureModemOutputAdapter.REQUEST_PREAMBLE .. SecureModemOutputAdapter.VERSION .. '/collection',
}

function SecureModemOutputAdapter:constructor (peripheralName)
    self:super('constructor')

    self.protocol = nil
    self.connections = {}

    -- last recorded state
    self.collection = MetricCollection()

    -- TODO test modem disconnect recovery
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
            self:dlog('SecureModemOutput:boot :: Loading ccryptolib.random...')

            random = vendor.ccryptolib.random

            self:dlog('SecureModemOutput:boot :: ccryptolib.random ready.')
        end

        -- lazy load because it is slow
        if not ecnet2 then
            t.log('SecureModemOutput:boot :: Loading ECNet2...')

            ecnet2 = vendor.ecnet2

            -- TODO fallback initializer when http not available
            -- Initialize the random generator.
            local postHandle = assert(http.post("https://krist.dev/ws/start", "{}"))
            local data = textutils.unserializeJSON(postHandle.readAll())
            postHandle.close()
            random.init(data.url)
            http.websocket(data.url).close()
            
            t.log('SecureModemOutput:boot :: ECNet2 ready. Address = ' .. ecnet2.address())
        end

        self:dlog('SecureModemOutput:boot :: Opening modem...')

        ecnet2.open(peripheralName)

        if not self.protocol then
            self:dlog('SecureModemOutput:boot :: Initializing protocol...')

            self.protocol = ecnet2.Protocol {
                -- Programs will only see packets sent on the same protocol.
                -- Only one active listener can exist at any time for a given protocol name.
                name = "telem",
            
                -- Objects must be serialized before they are sent over.
                serialize = textutils.serialize,
                deserialize = textutils.unserialize,
            }
        end

        self:dlog('SecureModemOutput:boot :: Boot complete.')
    end)()

    -- register async adapter
    self:setAsyncCycleHandler(function ()
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
                    self:dlog('SecureModemOutput:asyncCacheHandler :: request = GET_COLLECTION')

                    self.connections[id]:send(self.collection)

                    self:dlog('SecureModemOutput:asyncCycleHandler :: response sent')
                else
                    t.log('SecureModemOutput: Unknown request: ' .. tostring(p3))
                end
            end
            
            -- if type(message) == 'string' and message:sub(1, #self.REQUEST_PREAMBLE) == self.REQUEST_PREAMBLE then
            --     self:dlog('SecureModemOutput:asyncCycleHandler :: received request from ' .. sender)

            --     if message == self.REQUESTS.GET_COLLECTION then
            --         self:dlog('SecureModemOutput:asyncCacheHandler :: request = GET_COLLECTION')

            --         self.secureModem.send(sender, self.collection)

            --         self:dlog('SecureModemOutput:asyncCycleHandler :: response sent')
            --     else
            --         t.log('SecureModemOutput: Unknown request: ' .. tostring(message))
            --     end
            -- else
            --     self:dlog('SecureModemOutput:asyncCycleHandler :: Ignoring message with missing preamble')
            -- end
        end
    end)
end

function SecureModemOutputAdapter:write (collection)
    self:boot()

    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    -- update internal state
    self.collection = collection
end

return SecureModemOutputAdapter