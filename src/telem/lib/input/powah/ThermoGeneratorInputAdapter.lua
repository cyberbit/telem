local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.powah.BasePowahInputAdapter'

local ThermoGeneratorInputAdapter = base.mintAdapter('ThermoGeneratorInputAdapter')

function ThermoGeneratorInputAdapter:beforeRegister ()
    self.prefix = 'powahthermo:'

    self.queries = {
        basic = {
            coolant = fn():call('getCoolantInTank'):div(1000):fluid(),
        }
    }
    
    self:withEnergyQueries()

    -- getName
end

return ThermoGeneratorInputAdapter