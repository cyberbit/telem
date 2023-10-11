local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local Metric = require 'telem.lib.Metric'

local MetricCollection = o.class()
MetricCollection.type = 'MetricCollection'

function MetricCollection:constructor (...)
    self.metrics = {}
    self.context = {}

    local firstArg = select(1, ...)

    if type(firstArg) == 'table' and not o.instanceof(firstArg, Metric) then
        for name, value in pairs(firstArg) do
            self:insert(Metric(name, value))
        end
    else
        for _, v in next, {...} do
            self:insert(v)
        end
    end
end

function MetricCollection:insert (element)
    assert(o.instanceof(element, Metric), 'Element must be a Metric')
    table.insert(self.metrics, element)

    return self
end

function MetricCollection:setContext (ctx)
    self.context = { table.unpack(ctx) }

    return self
end

-- return first metric matching name@adapter
function MetricCollection:find (filter)
    local split = {}

    for sv in filter:gmatch('[^@]*') do
        table.insert(split, sv)
    end

    local name = split[1]
    local adapter = split[3] or split[2]

    local nameish = name ~= nil and #name > 0
    local adapterish = adapter ~= nil and #adapter > 0

    for _,v in pairs(self.metrics) do
        if (not nameish or v.name == name) and (not adapterish or v.adapter == adapter) then
            return v
        end
    end

    return nil
end

return MetricCollection