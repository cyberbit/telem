local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.biggerReactors.BaseBiggerReactorsInputAdapter'

local TurbineInputAdapter = base.mintAdapter('TurbineInputAdapter')

function TurbineInputAdapter:beforeRegister ()
    self.prefix = 'brturbine:'

    local fluidTank             = fn():call('fluidTank')
    local fluidInput            = fluidTank:call('input')
    local fluidOutput           = fluidTank:call('output')
    local rotor                 = fn():call('rotor')

    self.queries = {
        basic = {
            coil_engaged        = fn():call('coilEngaged'):toFlag(),
            flow_rate           = fluidTank:call('flowLastTick'):div(1000):fluidRate(),
            input               = fluidInput:call('amount'):div(1000):fluid(),
            output              = fluidOutput:call('amount'):div(1000):fluid(),
            rpm                 = rotor:call('RPM'):with('unit', 'RPM'),
            efficiency          = rotor:call('efficiencyLastTick'),
        },
        fluid = {
            nominal_flow_rate   = fluidTank:call('nominalFlowRate'):div(1000):fluidRate(),
            max_flow_rate       = fluidTank:call('flowRateLimit'):div(1000):fluidRate(),
            input_capacity      = fluidInput:call('maxAmount'):div(1000):fluid(),
            output_capacity     = fluidOutput:call('maxAmount'):div(1000):fluid(),
        },
    }

    self:withGenericMachineQueries()
        :withGeneratorQueries()
end

return TurbineInputAdapter