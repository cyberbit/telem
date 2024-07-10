local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local RadioactiveWasteBarrelInputAdapter = base.mintAdapter('RadioactiveWasteBarrelInputAdapter')

function RadioactiveWasteBarrelInputAdapter:beforeRegister ()
    self.prefix = 'mekwastebarrel:'

    local _, component = next(self.components)
    local supported = peripheral.getType(component) == 'radioactiveWasteBarrel'

    if not supported then
        error('Radioactive Waste Barrel is not supported in this version of Mekanism')
    end

    self.queries = {
        basic = {
            filled_percentage   = fn():call('getFilledPercentage'),
        },
        storage = {
            stored              = fn():call('getStored'):get('amount'):div(1000):fluid(),
            capacity            = fn():call('getCapacity'):div(1000):fluid(),
            needed              = fn():call('getNeeded'):div(1000):fluid(),
        },
    }

    self.storageQueries = {
        fn():call('getStored'):transform(function (v)
            return { Metric{ name = v.name, value = v.amount / 1000, unit = 'B' } }
        end)
    }

    -- getDirection
    
    -- TODO only supports direction and comparator
    -- self:withGenericMachineQueries()
end

return RadioactiveWasteBarrelInputAdapter