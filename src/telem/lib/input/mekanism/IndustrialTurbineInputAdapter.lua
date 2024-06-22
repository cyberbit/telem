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
            energy_production_rate      = fn():call('getProductionRate'):joulesToFE():energyRate(),
            energy_max_production       = fn():call('getMaxProduction'):joulesToFE():energyRate(),
            steam_filled_percentage     = fn():call('getSteamFilledPercentage'),
        },
        advanced = {
            dumping_mode                = fn():call('getDumpingMode'):toLookup({ IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }),
            flow_rate                   = fn():call('getFlowRate'):div(1000):fluidRate(),
            max_flow_rate               = fn():call('getMaxFlowRate'):div(1000):fluidRate(),
        },
        steam = {
            steam_input_rate            = fn():call('getLastSteamInputRate'):div(1000):fluidRate(),
            steam                       = fn():call('getSteam'):get('amount'):div(1000):fluid(),
            steam_capacity              = fn():call('getSteamCapacity'):div(1000):fluid(),
            steam_needed                = fn():call('getSteamNeeded'):div(1000):fluid(),
        },
        formation = {
            blades                      = fn():call('getBlades'),
            coils                       = fn():call('getCoils'),
            condensers                  = fn():call('getCondensers'),
            dispersers                  = fn():call('getDispersers'),
            vents                       = fn():call('getVents'),
            max_water_output            = fn():call('getMaxWaterOutput'):div(1000):fluidRate(),
        },
    }

    self:withGenericMachineQueries()
    self:withMultiblockQueries()

    -- getMinPos
    -- getMaxPos
end

return IndustrialTurbineInputAdapter