local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local SupercriticalPhaseShifterInputAdapter = base.mintAdapter('SupercriticalPhaseShifterInputAdapter')

function SupercriticalPhaseShifterInputAdapter:beforeRegister ()
    self.prefix = 'meksps:'

    self.queries = {
        basic = {
            input_filled_percentage     = fn():call('getInputFilledPercentage'),
            output_filled_percentage    = fn():call('getOutputFilledPercentage'),
            process_rate                = fn():call('getProcessRate'):div(1000):fluidRate(),
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage')
        },
        input = {
            input                       = fn():call('getInput'):get('amount'):div(1000):fluid(),
            input_capacity              = fn():call('getInputCapacity'):div(1000):fluid(),
            input_needed                = fn():call('getInputNeeded'):div(1000):fluid(),
        },
        output = {
            output                      = fn():call('getOutput'):get('amount'):div(1000):fluid(),
            output_capacity             = fn():call('getOutputCapacity'):div(1000):fluid(),
            output_needed               = fn():call('getOutputNeeded'):div(1000):fluid(),
        },
        
        -- TODO energy metrics never seem to change, it always appears as if the SPS is not using any energy
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
        formation = {
            coils                       = fn():call('getCoils'),
        },
    }

    self:withMultiblockQueries()

    -- TODO only supports energy
    -- self:withGenericMachineQueries()

    -- getMinPos
    -- getMaxPos
end

return SupercriticalPhaseShifterInputAdapter