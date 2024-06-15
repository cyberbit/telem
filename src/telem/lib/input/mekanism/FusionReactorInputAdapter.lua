local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local FusionReactorInputAdapter = o.class(BaseMekanismInputAdapter)
FusionReactorInputAdapter.type = 'FusionReactorInputAdapter'

-- alternative call that passes another call as a parameter
local callIsActiveCooled = function (method)
    return function (v)
        return v[method](v.isActiveCooledLogic())
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
            plasma_temperature          = fn():call('getPlasmaTemperature'):temp(),
            case_temperature            = fn():call('getCaseTemperature'):temp(),
            water_filled_percentage     = fn():call('getWaterFilledPercentage'),
            steam_filled_percentage     = fn():call('getSteamFilledPercentage'),
            tritium_filled_percentage   = fn():call('getTritiumFilledPercentage'),
            deuterium_filled_percentage = fn():call('getDeuteriumFilledPercentage'),
            dt_fuel_filled_percentage   = fn():call('getDTFuelFilledPercentage'),
            production_rate             = fn():call('getProductionRate'):joulesToFE():energyRate(),
            injection_rate              = fn():call('getInjectionRate'):div(1000):fluidRate(),
            min_injection_rate          = fn():transform(callIsActiveCooled('getMinInjectionRate')):div(1000):fluidRate(),
            max_plasma_temperature      = fn():transform(callIsActiveCooled('getMaxPlasmaTemperature')):temp(),
            max_casing_temperature      = fn():transform(callIsActiveCooled('getMaxCasingTemperature')):temp(),
            passive_generation_rate     = fn():transform(callIsActiveCooled('getPassiveGeneration')):joulesToFE():energyRate(),
            ignition_temperature        = fn():transform(callIsActiveCooled('getIgnitionTemperature')):temp(),
        },
        advanced = {
            -- transfer_loss            = fn():call('getTransferLoss'),
            -- environmental_loss       = fn():call('getEnvironmentalLoss'),
        },
        coolant = {
            water_capacity              = fn():call('getWaterCapacity'):div(1000):fluid(),
            water_needed                = fn():call('getWaterNeeded'):div(1000):fluid(),
            steam_capacity              = fn():call('getSteamCapacity'):div(1000):fluid(),
            steam_needed                = fn():call('getSteamNeeded'):div(1000):fluid(),
        },
        fuel = {
            tritium_capacity            = fn():call('getTritiumCapacity'):div(1000):fluid(),
            tritium_needed              = fn():call('getTritiumNeeded'):div(1000):fluid(),
            deuterium_capacity          = fn():call('getDeuteriumCapacity'):div(1000):fluid(),
            deuterium_needed            = fn():call('getDeuteriumNeeded'):div(1000):fluid(),
            dt_fuel_capacity            = fn():call('getDTFuelCapacity'):div(1000):fluid(),
            dt_fuel_needed              = fn():call('getDTFuelNeeded'):div(1000):fluid(),
        },
        formation = {
            formed                      = fn():call('isFormed'):toFlag(),
            height                      = fn():call('getHeight'):with('unit', 'm'),
            length                      = fn():call('getLength'):with('unit', 'm'),
            width                       = fn():call('getWidth'):with('unit', 'm'),
            active_cooled_logic         = fn():call('isActiveCooledLogic'):toFlag(),
        }
    }
end

return FusionReactorInputAdapter