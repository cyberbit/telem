local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'
local Metric    = require 'telem.lib.Metric'

local MEBridgeInputAdapter = base.mintAdapter('MEBridgeInputAdapter')

function MEBridgeInputAdapter:beforeRegister ()
    self.prefix = 'apmebridge:'

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
        
        -- fluid
        fn()
            :call('listFluid')
            :mapValues(function (v)
                return Metric{ name = v.name, value = v.amount / 1000, unit = 'B' }
            end),
        
        -- TODO test this when applied mekanistics not installed
        -- gas
        fn()
            :call('listGas')
            :mapValues(function (v)
                return Metric{ name = v.name, value = v.amount / 1000, unit = 'B' }
            end),
    }

end

return MEBridgeInputAdapter