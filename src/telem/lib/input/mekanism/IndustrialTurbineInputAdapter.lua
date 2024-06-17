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
            energy_production_rate      = fn():callElse('getProductionRate', 0):joulesToFE():energyRate(),
            energy_max_production       = fn():callElse('getMaxProduction', 0):joulesToFE():energyRate(),
            steam_filled_percentage     = fn():callElse('getSteamFilledPercentage', 0),
        },
        advanced = {
            dumping_mode                = fn():callElse('getDumpingMode', 'UNKNOWN'):toLookup({ UNKNOWN = 0, IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }),
            flow_rate                   = fn():callElse('getFlowRate', 0):div(1000):fluidRate(),
            max_flow_rate               = fn():callElse('getMaxFlowRate', 0):div(1000):fluidRate(),
        },
        steam = {
            steam_input_rate            = fn():callElse('getLastSteamInputRate', 0):div(1000):fluidRate(),
            steam                       = fn():callElse('getSteam', { amount = 0 }):get('amount'):div(1000):fluid(),
            steam_capacity              = fn():callElse('getSteamCapacity', 0):div(1000):fluid(),
            steam_needed                = fn():callElse('getSteamNeeded', 0):div(1000):fluid(),
        },
        formation = {
            blades                      = fn():callElse('getBlades', 0),
            coils                       = fn():callElse('getCoils', 0),
            condensers                  = fn():callElse('getCondensers', 0),
            dispersers                  = fn():callElse('getDispersers', 0),
            vents                       = fn():callElse('getVents', 0),
            max_water_output            = fn():callElse('getMaxWaterOutput', 0):div(1000):fluidRate(),
        },
    }

    self:withGenericMachineQueries()
    self:withMultiblockQueries()

    -- getMinPos
    -- getMaxPos
end

return IndustrialTurbineInputAdapter