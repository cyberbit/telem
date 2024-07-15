local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'
local Metric    = require 'telem.lib.Metric'

local RSBridgeInputAdapter = base.mintAdapter('RSBridgeInputAdapter')

function RSBridgeInputAdapter:beforeRegister ()
    self.prefix = 'aprsbridge:'

    self.queries = {
        basic = {}
    }

    self.storageQueries = {
        -- items
        fn()
            :call('listItems')
            :mapValues(function (v)
                return Metric{ name = v.name, value = v.amount, unit = 'item' }
            end),
        
        -- fluids
        fn()
            :call('listFluids')
            :mapValues(function (v)
                return Metric{ name = v.name, value = v.amount / 1000, unit = 'B' }
            end),
    }

end

return RSBridgeInputAdapter