local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local RadioactiveWasteBarrelInputAdapter = base.mintAdapter('RadioactiveWasteBarrelInputAdapter')

function RadioactiveWasteBarrelInputAdapter:beforeRegister ()
    self.prefix = 'mekwastebarrel:'

    -- TODO Mekanism 10.2.5 does not have proper support for waste barrels,
    -- so the queries have not yet been built. This will be updated in the future.
end

return RadioactiveWasteBarrelInputAdapter