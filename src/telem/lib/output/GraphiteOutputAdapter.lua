local o                   = require 'telem.lib.ObjectModel'
local OutputAdapter      = require 'telem.lib.OutputAdapter'
local MetricCollection   = require 'telem.lib.MetricCollection'
t
local GraphiteOutputAdapter = o.class(OutputAdapter)
GraphiteOutputAdapter.type = 'GraphiteOutputAdapter'

-- Graphite Output Adapter
--
-- Endpoint: Grafana Cloud or hosted Graphite metric endpoint
-- API Key: Token with at least metric:write scope
--
-- Note that API key are prefixed with a numeric, i.e. 2021620:your-api-key
function GraphiteOutputAdapter:constructor(endpoint, apiKey)
    self:super('constructor')
    self.endpoint = assert(endpoint, 'Endpoint is required')
    self.apiKey   = assert(apiKey,   'API key is required')
end

function GraphiteOutputAdapter:write(collection)
    assert(o.instanceof(collection, MetricCollection),
           'Collection must be a MetricCollection')

    -- Build an array of metric objects
    local payload = {}
    -- Current unix timestamp
    local now = math.floor(os.epoch('utc') / 1000)

    for _, metric in pairs(collection.metrics) do
        local tags = {}
        if metric.unit    and metric.unit    ~= '' then table.insert(tags, 'unit='   .. metric.unit)    end
        if metric.source  and metric.source  ~= '' then table.insert(tags, 'source=' .. metric.source)  end
        if metric.adapter and metric.adapter ~= '' then table.insert(tags, 'adapter='.. metric.adapter) end
        
        -- Graphite metric name are namespaced by dots "."
        local normalized_name = string.gsub(metric.name, ':', '.')

        table.insert(payload, {
            name     = normalized_name,
            interval = 30,
            value    = metric.value,
            tags     = tags,
            time     = metric.time or now,
        })
    end

    -- Serialize to JSON
    local body = textutils.serializeJSON(payload) 

    -- POST to Graphite HTTP endpoint
    local res = http.post{
        url     = self.endpoint,
        body    = body,
        headers = {
            ['Authorization'] = 'Bearer ' .. self.apiKey,
            ['Content-Type']  = 'application/json',
        }
    }

    return res
end

return GraphiteOutputAdapter