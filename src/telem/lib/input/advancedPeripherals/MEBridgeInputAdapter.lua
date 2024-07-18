local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'
local Metric    = require 'telem.lib.Metric'

local MEBridgeInputAdapter = base.mintAdapter('MEBridgeInputAdapter')

function MEBridgeInputAdapter:beforeRegister (peripheralName, categories)
    self.prefix = 'apmebridge:'

    self.queries = {
        basic = {
            energy_usage                = fn():call('getEnergyUsage'):aeToFe():energyRate(),
            item_storage_used           = fn():call('getUsedItemStorage'):with('unit', 'bytes'),
            fluid_storage_used          = fn():call('getUsedFluidStorage'):with('unit', 'bytes'),
            cell_count                  = fn():call('listCells'):count(),
        },
        energy = {
            energy                      = fn():call('getEnergyStorage'):aeToFe():energy(),
            max_energy                  = fn():call('getMaxEnergyStorage'):aeToFe():energy(),
        },
        storage = {
            item_storage_capacity       = fn():call('getTotalItemStorage'):with('unit', 'bytes'),
            item_storage_available      = fn():call('getAvailableItemStorage'):with('unit', 'bytes'),
            fluid_storage_capacity      = fn():call('getTotalFluidStorage'):with('unit', 'bytes'),
            fluid_storage_available     = fn():call('getAvailableFluidStorage'):with('unit', 'bytes'),
        },
    }

    -- getCraftingCPUs
    -- listCraftableItems
    -- listCraftableFluid

    self.storageQueries = {
        -- items
        fn():call('listItems'):mapValues(function (v)
            return Metric{ name = v.name, value = v.amount, unit = 'item' }
        end),
        
        -- fluid
        fn():call('listFluid'):mapValues(function (v)
            return Metric{ name = v.name, value = v.amount / 1000, unit = 'B' }
        end),
        
        -- TODO test this when applied mekanistics not installed
        -- gas
        fn():call('listGas'):mapValues(function (v)
            return Metric{ name = v.name, value = v.amount / 1000, unit = 'B' }
        end),
    }

end

return MEBridgeInputAdapter