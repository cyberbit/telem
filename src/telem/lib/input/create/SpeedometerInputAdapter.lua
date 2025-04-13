local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.create.BaseCreateInputAdapter'
local Metric    = require 'telem.lib.Metric'

local SpeedometerInputAdapter = base.mintAdapter('SpeedometerInputAdapter')

function SpeedometerInputAdapter:beforeRegister ()
    self.prefix = "createspeedo:"

    self.queries = {
        basic = {
            speed    = fn():call("getSpeed"):with("unit", "RPM"),
        }
    }
end

return SpeedometerInputAdapter