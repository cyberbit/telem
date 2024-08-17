local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local FusionReactorInputAdapter = base.mintAdapter('FusionReactorInputAdapter')

function FusionReactorInputAdapter:beforeRegister ()
    self.prefix = 'mekfusion:'

    -- alternative call that passes another call as a parameter
    local callIsActiveCooled = function (method)
        return function (v)
            return v[method](v.isActiveCooledLogic())
        end
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
        -- advanced = {
        --     transfer_loss            = fn():call('getTransferLoss'),
        --     environmental_loss       = fn():call('getEnvironmentalLoss'),
        -- },
        coolant = {
            water                       = fn():call('getWater'):get('amount'):div(1000):fluid(),
            water_capacity              = fn():call('getWaterCapacity'):div(1000):fluid(),
            water_needed                = fn():call('getWaterNeeded'):div(1000):fluid(),
            steam                       = fn():call('getSteam'):get('amount'):div(1000):fluid(),
            steam_capacity              = fn():call('getSteamCapacity'):div(1000):fluid(),
            steam_needed                = fn():call('getSteamNeeded'):div(1000):fluid(),
        },
        fuel = {
            tritium                     = fn():call('getTritium'):get('amount'):div(1000):fluid(),
            tritium_capacity            = fn():call('getTritiumCapacity'):div(1000):fluid(),
            tritium_needed              = fn():call('getTritiumNeeded'):div(1000):fluid(),
            deuterium                   = fn():call('getDeuterium'):get('amount'):div(1000):fluid(),
            deuterium_capacity          = fn():call('getDeuteriumCapacity'):div(1000):fluid(),
            deuterium_needed            = fn():call('getDeuteriumNeeded'):div(1000):fluid(),
            dt_fuel                     = fn():call('getDTFuel'):get('amount'):div(1000):fluid(),
            dt_fuel_capacity            = fn():call('getDTFuelCapacity'):div(1000):fluid(),
            dt_fuel_needed              = fn():call('getDTFuelNeeded'):div(1000):fluid(),
        },
        formation = {
            active_cooled_logic         = fn():call('isActiveCooledLogic'):toFlag()
        }
    }

    self:withMultiblockQueries()

    -- getMinPos
    -- getHohlraum
    -- getMaxPos
    -- getLogicMode
end

return FusionReactorInputAdapter
