local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local FusionReactorInputAdapter = o.class(BaseMekanismInputAdapter)
FusionReactorInputAdapter.type = 'FusionReactorInputAdapter'

-- alternative call that passes another call as a parameter
local callIsActiveCooled = function (method)
    return function (v)
        local success, isActiveCooledLogic = pcall(v.isActiveCooledLogic)

        if not success then
            return 0
        end

        local subsuccess, result = pcall(v[method], isActiveCooledLogic)

        if not subsuccess then
            return 0
        end

        return result
    end
end

function FusionReactorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekfusion:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
        'fuel',
        'coolant',
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
            plasma_temperature          = fn():callElse('getPlasmaTemperature', 0):temp(),
            case_temperature            = fn():callElse('getCaseTemperature', 0):temp(),
            water_filled_percentage     = fn():callElse('getWaterFilledPercentage', 0),
            steam_filled_percentage     = fn():callElse('getSteamFilledPercentage', 0),
            tritium_filled_percentage   = fn():callElse('getTritiumFilledPercentage', 0),
            deuterium_filled_percentage = fn():callElse('getDeuteriumFilledPercentage', 0),
            dt_fuel_filled_percentage   = fn():callElse('getDTFuelFilledPercentage', 0),
            production_rate             = fn():callElse('getProductionRate', 0):joulesToFE():energyRate(),
            injection_rate              = fn():callElse('getInjectionRate', 0):div(1000):fluidRate(),
            min_injection_rate          = fn():transform(callIsActiveCooled('getMinInjectionRate')):div(1000):fluidRate(),
            max_plasma_temperature      = fn():transform(callIsActiveCooled('getMaxPlasmaTemperature')):temp(),
            max_casing_temperature      = fn():transform(callIsActiveCooled('getMaxCasingTemperature')):temp(),
            passive_generation_rate     = fn():transform(callIsActiveCooled('getPassiveGeneration')):joulesToFE():energyRate(),
            ignition_temperature        = fn():transform(callIsActiveCooled('getIgnitionTemperature')):temp(),
        },
        advanced = {
            -- transfer_loss            = fn():callElse('getTransferLoss', 0),
            -- environmental_loss       = fn():callElse('getEnvironmentalLoss', 0),
        },
        coolant = {
            water_capacity              = fn():callElse('getWaterCapacity', 0):div(1000):fluid(),
            water_needed                = fn():callElse('getWaterNeeded', 0):div(1000):fluid(),
            steam_capacity              = fn():callElse('getSteamCapacity', 0):div(1000):fluid(),
            steam_needed                = fn():callElse('getSteamNeeded', 0):div(1000):fluid(),
        },
        fuel = {
            tritium_capacity            = fn():callElse('getTritiumCapacity', 0):div(1000):fluid(),
            tritium_needed              = fn():callElse('getTritiumNeeded', 0):div(1000):fluid(),
            deuterium_capacity          = fn():callElse('getDeuteriumCapacity', 0):div(1000):fluid(),
            deuterium_needed            = fn():callElse('getDeuteriumNeeded', 0):div(1000):fluid(),
            dt_fuel_capacity            = fn():callElse('getDTFuelCapacity', 0):div(1000):fluid(),
            dt_fuel_needed              = fn():callElse('getDTFuelNeeded', 0):div(1000):fluid(),
        },
        formation = {
            active_cooled_logic         = fn():callElse('isActiveCooledLogic', 0):toFlag()
        }
    }

    self:withMultiblockQueries()

    -- getDTFuel
    -- getMinPos
    -- getHohlraum
    -- getMaxPos
    -- getTrititum
    -- getDeuterium
    -- getSteam
    -- getWater
    -- getLogicMode
end

return FusionReactorInputAdapter