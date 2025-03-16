local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.create.BaseCreateInputAdapter'
local Metric    = require 'telem.lib.Metric'

local StressometerInputAdapter = base.mintAdapter('StressometerInputAdapter')

function StressometerInputAdapter:beforeRegister ()
    self.prefix = "createstresso:"

    self.queries = {
        basic = {
            usage    = fn():call("getStress"):with("unit", "SU"),
            capacity = fn():call("getStressCapacity"):with("unit", "SU")
        }
    }
end

return StressometerInputAdapter