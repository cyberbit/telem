local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local IndustrialTurbineInputAdapter = o.class(BaseMekanismInputAdapter)
IndustrialTurbineInputAdapter.type = 'IndustrialTurbineInputAdapter'

function IndustrialTurbineInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekturbine:'

    local allCategories = {
        'basic',
        'advanced',
        'energy',
        'steam',
        'formation'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self.queries = {
        basic = {
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage'),
            energy_production_rate      = fn():call('getProductionRate'):joulesToFE():energyRate(),
            energy_max_production       = fn():call('getMaxProduction'):joulesToFE():energyRate(),
            steam_filled_percentage     = fn():call('getSteamFilledPercentage'),
        },
        advanced = {
            comparator_level            = fn():call('getComparatorLevel'),
            dumping_mode                = fn():call('getDumpingMode'):toLookup({ IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }),
            flow_rate                   = fn():call('getFlowRate'):div(1000):fluidRate(),
            max_flow_rate               = fn():call('getMaxFlowRate'):div(1000):fluidRate(),
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
        steam = {
            steam_input_rate            = fn():call('getLastSteamInputRate'):div(1000):fluidRate(),
            steam                       = fn():call('getSteam'):get('amount'):div(1000):fluid(),
            steam_capacity              = fn():call('getSteamCapacity'):div(1000):fluid(),
            steam_needed                = fn():call('getSteamNeeded'):div(1000):fluid(),
        },
        formation = {
            formed                      = fn():call('isFormed'):toFlag(),
            height                      = fn():call('getHeight'):with('unit', 'm'),
            length                      = fn():call('getLength'):with('unit', 'm'),
            width                       = fn():call('getWidth'):with('unit', 'm'),
            blades                      = fn():call('getBlades'),
            coils                       = fn():call('getCoils'),
            condensers                  = fn():call('getCondensers'),
            dispersers                  = fn():call('getDispersers'),
            vents                       = fn():call('getVents'),
            max_water_output            = fn():call('getMaxWaterOutput'):div(1000):fluidRate(),
        },
    }
end

return IndustrialTurbineInputAdapter