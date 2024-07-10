local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local EnergyCubeInputAdapter = base.mintAdapter('EnergyCubeInputAdapter')

function EnergyCubeInputAdapter:beforeRegister ()
    self.prefix = 'mekenergycube:'

    self.queries = {
        basic = {
            charge_item_count       = fn():call('getChargeItem'):get('count'):with('unit', 'item'),
            discharge_item_count    = fn():call('getDischargeItem'):get('count'):with('unit', 'item'),
        }
    }
    
    self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return EnergyCubeInputAdapter