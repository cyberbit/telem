local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.powah.BasePowahInputAdapter'

local SolarPanelInputAdapter = base.mintAdapter('SolarPanelInputAdapter')

function SolarPanelInputAdapter:beforeRegister ()
    self.prefix = 'powahsolar:'

    self.queries = {
        basic = {
            sees_sky    = fn():call('canSeeSky'):toFlag(),
        }
    }
    
    self:withEnergyQueries()

    -- getName
end

return SolarPanelInputAdapter