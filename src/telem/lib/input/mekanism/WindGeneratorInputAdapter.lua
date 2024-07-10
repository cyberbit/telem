local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local WindGeneratorInputAdapter = base.mintAdapter('WindGeneratorInputAdapter')

function WindGeneratorInputAdapter:beforeRegister ()
    self.prefix = 'mekwindgen:'

    self.queries = {
        basic = {
            blacklisted_dimension   = fn():call('isBlacklistedDimension'):toFlag(),
        },
    }
    
    self:withGenericMachineQueries()
        :withGeneratorQueries()

    -- getDirection
    -- getRedstoneMode
end

return WindGeneratorInputAdapter