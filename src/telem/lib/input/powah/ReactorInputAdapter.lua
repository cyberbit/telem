local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.powah.BasePowahInputAdapter'

local ReactorInputAdapter = base.mintAdapter('ReactorInputAdapter')

function ReactorInputAdapter:beforeRegister ()
    self.prefix = 'powahreactor:'

    self.queries = {
        basic = {
            running         = fn():call('isRunning'):toFlag(),
            fuel            = fn():call('getFuel'):with('unit', '%'),
            carbon          = fn():call('getCarbon'):with('unit', '%'),
            redstone        = fn():call('getRedstone'):with('unit', '%'),
            temperature     = fn():call('getTemperature'):with('unit', '%'),
        }
    }
    
    self:withEnergyQueries()

    -- TODO getInventory* seems to always return nil

    -- getName
    -- getInventoryUraninite
    -- getInventoryRedstone
    -- getInventoryCarbon
end

return ReactorInputAdapter