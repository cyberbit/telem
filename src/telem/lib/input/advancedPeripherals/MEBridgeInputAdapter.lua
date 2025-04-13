local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'
local Metric    = require 'telem.lib.Metric'

local MEBridgeInputAdapter = base.mintAdapter('MEBridgeInputAdapter')

function MEBridgeInputAdapter:beforeRegister (peripheralName, categories)
    self.prefix = 'apmebridge:'

    local _, component = next(self.components)
    local listCellsSupported = pcall(component.listCells) and true or false

    self.queries = {
        basic = {
            energy_usage                = fn():call('getEnergyUsage'):aeToFe():energyRate(),
            item_storage_used           = fn():call('getUsedItemStorage'):with('unit', 'bytes'),
            fluid_storage_used          = fn():call('getUsedFluidStorage'):with('unit', 'bytes'),
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

    if listCellsSupported then
        self.queries.basic.cell_count = fn():call('listCells'):count()
    else
        -- TODO debug logs aren't supported in adapter constructors yet
        self:dlog('MEBridgeInput:beforeRegister :: cell_count is not supported on this network, upgrade to Advanced Peripherals 0.7.41r or newer')
    end

    -- TODO gas storage metrics?

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