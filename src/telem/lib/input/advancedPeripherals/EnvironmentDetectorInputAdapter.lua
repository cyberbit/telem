local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'

local EnvironmentDetectorInputAdapter = base.mintAdapter('EnvironmentDetectorInputAdapter')

function EnvironmentDetectorInputAdapter:beforeRegister (peripheralName, categories)
    self.prefix = 'apenv:'

    self.queries = {
        basic = {
            block_light_level           = fn():call('getBlockLightLevel'),
            day_light_level             = fn():call('getDayLightLevel'),
            sky_light_level             = fn():call('getSkyLightLevel'),
            moon_id                     = fn():call('getMoonId'),
            time                        = fn():call('getTime'),
            radiation                   = fn():call('getRadiationRaw'):with('unit', 'Sv/h'),
            can_sleep                   = fn():call('canSleepHere'):toFlag(),
            raining                     = fn():call('isRaining'):toFlag(),
            sunny                       = fn():call('isSunny'):toFlag(),
            thundering                  = fn():call('isThunder'):toFlag(),
            slime_chunk                 = fn():call('isSlimeChunk'):toFlag(),
        },
    }

    -- getBiome
    -- getDimensionName
    -- getDimensionPaN
    -- getDimensionProvider
    -- getMoonName
    -- getOperationCooldown
    -- isDimension
    -- listDimensions
    -- scanCost
    -- scanEntities
end

return EnvironmentDetectorInputAdapter