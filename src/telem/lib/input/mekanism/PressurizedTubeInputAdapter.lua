local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local PressurizedTubeInputAdapter = base.mintAdapter('PressurizedTubeInputAdapter')

function PressurizedTubeInputAdapter:beforeRegister ()
    self.prefix = 'mektube:'

    self.queries = {
        basic = {
            filled_percentage   = fn():call('getFilledPercentage')
        },
        transfer = {
            buffer              = fn():call('getBuffer'):get('amount'):div(1000):fluid(),
            capacity            = fn():call('getCapacity'):div(1000):fluid(),
            needed              = fn():call('getNeeded'):div(1000):fluid(),
        }
    }
end

return PressurizedTubeInputAdapter