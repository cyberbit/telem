local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.powah.BasePowahInputAdapter'

local MagmatorInputAdapter = base.mintAdapter('MagmatorInputAdapter')

function MagmatorInputAdapter:beforeRegister ()
    self.prefix = 'powahmagmator:'

    self.queries = {
        basic = {
            burning         = fn():call('isBurning'):toFlag(),
            fluid           = fn():call('getFluidInTank'):div(1000):fluid(),
            fluid_capacity  = fn():call('getTankCapacity'):div(1000):fluid(),
        }
    }
    
    self:withEnergyQueries()

    -- TODO getInventory seems to always return nil

    -- getName
    -- getInventory
end

return MagmatorInputAdapter