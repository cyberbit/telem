local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local FluidStorageInputAdapter = o.class(InputAdapter)
FluidStorageInputAdapter.type = 'FluidStorageInputAdapter'

function FluidStorageInputAdapter:constructor (peripheralName)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'storage:'

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()
end

function FluidStorageInputAdapter:read ()
    self:boot()
    
    local source, fluidStorage = next(self.components)
    local tanks = fluidStorage.tanks()

    local tempMetrics = {}

    for _,v in pairs(tanks) do
        if v then
            local prefixkey = self.prefix .. v.name
            tempMetrics[prefixkey] = (tempMetrics[prefixkey] or 0) + v.amount / 1000
        end
    end

    local metrics = MetricCollection()

    for k,v in pairs(tempMetrics) do
        if v then metrics:insert(Metric({ name = k, value = v, unit = 'B', source = source })) end
    end

    return metrics
end

return FluidStorageInputAdapter