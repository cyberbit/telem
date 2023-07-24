local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local ItemStorageInputAdapter = o.class(InputAdapter)
ItemStorageInputAdapter.type = 'ItemStorageInputAdapter'

function ItemStorageInputAdapter:constructor (peripheralName)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'storage:'

    self:addComponentByPeripheralID(peripheralName)
end

function ItemStorageInputAdapter:read ()
    local source, itemStorage = next(self.components)
    local items = itemStorage.list()

    local tempMetrics = {}

    for _,v in pairs(items) do
        if v then
            local prefixkey = self.prefix .. v.name
            tempMetrics[prefixkey] = (tempMetrics[prefixkey] or 0) + v.count
        end
    end

    local metrics = MetricCollection()

    for k,v in pairs(tempMetrics) do
        if v then metrics:insert(Metric({ name = k, value = v, unit = 'item', source = source })) end
    end

    return metrics
end

return ItemStorageInputAdapter