local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'
local Metric    = require 'telem.lib.Metric'

local GeoScannerInputAdapter = base.mintAdapter('GeoScannerInputAdapter')

function GeoScannerInputAdapter:beforeRegister (peripheralName, categories)
    self.prefix = 'apgeo:'

    self.queries = {
        basic = {},
    }

    -- TODO no unit? intentional?? meh???
    self.storageQueries = {
        fn():callElse('chunkAnalyze', {})
            :map(function (k, v) return Metric{ name = k, value = v } end)
            :values()
    }

    -- scan
end

return GeoScannerInputAdapter