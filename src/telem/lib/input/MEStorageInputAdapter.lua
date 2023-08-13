local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local MEStorageInputAdapter = o.class(InputAdapter)
MEStorageInputAdapter.type = 'MEStorageInputAdapter'

function MEStorageInputAdapter:constructor (peripheralName)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'storage:'


    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()
end

function MEStorageInputAdapter:read ()
    self:boot()
    
    local source, storage = next(self.components)
    local items = storage.listItems()
    local fluids = storage.listFluid()

    local metrics = MetricCollection()

    for _,v in pairs(items) do
        if v then metrics:insert(Metric({ name = self.prefix .. v.name, value = v.amount, unit = 'item', source = source })) end
    end

    for _,v in pairs(fluids) do
        if v then metrics:insert(Metric({ name = self.prefix .. v.name, value = v.amount / 1000, unit = 'B', source = source })) end
    end

    return metrics
end

return MEStorageInputAdapter