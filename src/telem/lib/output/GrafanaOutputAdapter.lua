local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local GrafanaOutputAdapter = o.class(OutputAdapter)
GrafanaOutputAdapter.type = 'GrafanaOutputAdapter'

function GrafanaOutputAdapter:constructor (endpoint, apiKey)
    self:super('constructor')

    self.endpoint = assert(endpoint, 'Endpoint is required')
    self.apiKey = assert(apiKey, 'API key is required')
end

function GrafanaOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    local outf = {}

    for _,v in pairs(collection.metrics) do
        local unitreal = (v.unit and v.unit ~= '' and ',unit=' .. v.unit) or ''
        local sourcereal = (v.source and v.source ~= '' and ',source=' .. v.source) or ''
        local adapterreal = (v.adapter and v.adapter ~= '' and ',adapter=' .. v.adapter) or ''

        table.insert(outf, v.name .. unitreal .. sourcereal .. adapterreal .. (' metric=%f'):format(v.value))
    end

    -- t.pprint(collection)

    local res = http.post({
        url = self.endpoint,
        body = table.concat(outf, '\n'),
        headers = { Authorization = ('Bearer %s'):format(self.apiKey) }
    })
end

return GrafanaOutputAdapter