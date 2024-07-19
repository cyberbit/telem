local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.powah.BasePowahInputAdapter'

local EnergyCellInputAdapter = base.mintAdapter('EnergyCellInputAdapter')

function EnergyCellInputAdapter:beforeRegister ()
    self.prefix = 'powahcell:'

    self.queries = {
        -- mixins cover everything
    }
    
    self:withEnergyQueries()

    -- getName
end

return EnergyCellInputAdapter