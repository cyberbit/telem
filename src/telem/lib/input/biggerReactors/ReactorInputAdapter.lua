local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.biggerReactors.BaseBiggerReactorsInputAdapter'

local ReactorInputAdapter = base.mintAdapter('ReactorInputAdapter')

function ReactorInputAdapter:beforeRegister ()
    self.prefix = 'brreactor:'

    local _, component = next(self.components)
    local supportsBattery = type(component.battery()) ~= 'nil'
    local supportsCoolantTank = type(component.coolantTank()) ~= 'nil'

    local fuelTank              = fn():call('fuelTank')

    self.queries = {
        basic = {
            burn_rate           = fuelTank:call('burnedLastTick'):div(1000):fluidRate(),
            ambient_temperature = fn():call('ambientTemperature'):temp(),
            casing_temperature  = fn():call('casingTemperature'):temp(),
            fuel_temperature    = fn():call('fuelTemperature'):temp(),
            fuel_reactivity     = fuelTank:call('fuelReactivity'),
        },
        fuel = {
            fuel                = fuelTank:call('fuel'):div(1000):fluid(),
            fuel_capacity       = fuelTank:call('capacity'):div(1000):fluid(),
            reactant            = fuelTank:call('totalReactant'):div(1000):fluid(),
            waste               = fuelTank:call('waste'):div(1000):fluid(),
        },
        formation = {
            control_rods        = fn():call('controlRodCount'),
        },
    }

    self:withGenericMachineQueries()

    -- passive reactors
    if supportsBattery then
        self:withGeneratorQueries()
    end

    -- active reactors
    if supportsCoolantTank then
        local coolantTank                           = fn():call('coolantTank')

        self.queries.basic.coolant_transition_rate  = coolantTank:call('transitionedLastTick'):div(1000):fluidRate()

        self.queries.coolant = {
            coolant_hot                             = coolantTank:call('hotFluidAmount'):div(1000):fluid(),
            coolant_cold                            = coolantTank:call('coldFluidAmount'):div(1000):fluid(),
            coolant_capacity                        = coolantTank:call('capacity'):div(1000):fluid(),
            coolant_max_transition_rate             = coolantTank:call('maxTransitionedLastTick'):div(1000):fluidRate(),
        }
    end

    -- getControlRod
end

return ReactorInputAdapter