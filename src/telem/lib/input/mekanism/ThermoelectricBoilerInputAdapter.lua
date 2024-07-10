local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ThermoelectricBoilerInputAdapter = base.mintAdapter('ThermoelectricBoilerInputAdapter')

function ThermoelectricBoilerInputAdapter:beforeRegister ()
    self.prefix = 'mekboiler:'

    local _, component = next(self.components)
    local supportsEnvironmentalLoss = type(component.getEnvironmentalLoss) == 'function'

    self.queries = {
        basic = {
            boil_rate                           = fn():call('getBoilRate'):div(1000):fluidRate(),
            max_boil_rate                       = fn():call('getMaxBoilRate'):div(1000):fluidRate(),
            temperature                         = fn():call('getTemperature'):temp(),
            water_filled_percentage             = fn():call('getWaterFilledPercentage'),
            steam_filled_percentage             = fn():call('getSteamFilledPercentage'),
            cooled_coolant_filled_percentage    = fn():call('getCooledCoolantFilledPercentage'),
            heated_coolant_filled_percentage    = fn():call('getHeatedCoolantFilledPercentage'),
        },
        water = {
            water                               = fn():call('getWater'):get('amount'):div(1000):fluid(),
            water_capacity                      = fn():call('getWaterCapacity'):div(1000):fluid(),
            water_needed                        = fn():call('getWaterNeeded'):div(1000):fluid(),
        },
        steam = {
            steam                               = fn():call('getSteam'):get('amount'):div(1000):fluid(),
            steam_capacity                      = fn():call('getSteamCapacity'):div(1000):fluid(),
            steam_needed                        = fn():call('getSteamNeeded'):div(1000):fluid(),
        },
        coolant = {
            cooled_coolant                      = fn():call('getCooledCoolant'):get('amount'):div(1000):fluid(),
            cooled_coolant_capacity             = fn():call('getCooledCoolantCapacity'):div(1000):fluid(),
            cooled_coolant_needed               = fn():call('getCooledCoolantNeeded'):div(1000):fluid(),
            heated_coolant                      = fn():call('getHeatedCoolant'):get('amount'):div(1000):fluid(),
            heated_coolant_capacity             = fn():call('getHeatedCoolantCapacity'):div(1000):fluid(),
            heated_coolant_needed               = fn():call('getHeatedCoolantNeeded'):div(1000):fluid(),
        },
        formation = {
            superheaters                        = fn():call('getSuperheaters'),
            boil_capacity                       = fn():call('getBoilCapacity'):div(1000):fluidRate(),
        },
    }

    -- Mekanism 10.3+ only
    if supportsEnvironmentalLoss then
        self.queries.advanced = self.queries.advanced or {}
        self.queries.advanced.environmental_loss = fn():call('getEnvironmentalLoss')
    end

    self:withMultiblockQueries()

    -- getComparatorLevel
    -- getMinPos
    -- getMaxPos
end

return ThermoelectricBoilerInputAdapter