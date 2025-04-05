local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.create.BaseCreateInputAdapter'
local Metric    = require 'telem.lib.Metric'

local RotationSpeedControllerInputAdapter = base.mintAdapter('RotationSpeedControllerInputAdapter')

function RotationSpeedControllerInputAdapter:beforeRegister ()
    self.prefix = "createspeedcontroller:"

    self.queries = {
        basic = {
            target_speed    = fn():call("getTargetSpeed"):with("unit", "RPM"),
        }
    }
end

return RotationSpeedControllerInputAdapter