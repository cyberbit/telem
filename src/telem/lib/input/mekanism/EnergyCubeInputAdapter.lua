local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local EnergyCubeInputAdapter = base.mintAdapter('EnergyCubeInputAdapter')

function EnergyCubeInputAdapter:beforeRegister ()
    self.prefix = 'mekenergycube:'

    self.queries = {
        -- current supported queries covered by generic machine mixin
    }
    
    self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return EnergyCubeInputAdapter