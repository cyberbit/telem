local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local UniversalCableInputAdapter = base.mintAdapter('UniversalCableInputAdapter')

function UniversalCableInputAdapter:beforeRegister ()
    self.prefix = 'mekcable:'

    self.queries = {
        basic = {
            filled_percentage   = fn():call('getFilledPercentage')
        },
        transfer = {
            buffer              = fn():call('getBuffer'):joulesToFE():energy(),
            capacity            = fn():call('getCapacity'):joulesToFE():energy(),
            needed              = fn():call('getNeeded'):joulesToFE():energy(),
        }
    }
end

return UniversalCableInputAdapter