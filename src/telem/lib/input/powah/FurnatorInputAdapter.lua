local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.powah.BasePowahInputAdapter'

local FurnatorInputAdapter = base.mintAdapter('FurnatorInputAdapter')

function FurnatorInputAdapter:beforeRegister ()
    self.prefix = 'powahfurnator:'

    self.queries = {
        basic = {
            burning     = fn():call('isBurning'):toFlag(),
            carbon      = fn():call('getCarbon'),
        }
    }
    
    self:withEnergyQueries()

    -- TODO getInventory seems to always return nil

    -- getName
    -- getInventory
end

return FurnatorInputAdapter