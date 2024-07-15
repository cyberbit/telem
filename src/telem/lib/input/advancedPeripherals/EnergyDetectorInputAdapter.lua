local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'

local EnergyDetectorInputAdapter = base.mintAdapter('EnergyDetectorInputAdapter')

function EnergyDetectorInputAdapter:beforeRegister ()
    self.prefix = 'apenergy:'

    self.queries = {
        basic = {
            transfer_rate       = fn():call('getTransferRate'):energyRate(),
            transfer_rate_limit = fn():call('getTransferRateLimit'):energyRate(),
        }
    }
end

return EnergyDetectorInputAdapter