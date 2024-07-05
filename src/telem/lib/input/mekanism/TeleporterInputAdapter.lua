local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local TeleporterInputAdapter = base.mintAdapter('TeleporterInputAdapter')

function TeleporterInputAdapter:beforeRegister ()
    self.prefix = 'mekteleporter:'

    self.queries = {
        basic = {
            status                      = fn():call('getStatus'):toLookup({ ['ready'] = 1, ['no frequency'] = 2, ['no frame'] = 3, ['no link'] = 4 }),
            frequency_selected          = fn():callElse('hasFrequency', false):toFlag(),
            active_teleporters_count    = fn():callElse('getActiveTeleporters', {}):count(),
        },
    }
    
    -- TODO does not support direction
    self:withGenericMachineQueries()

    -- getRedstoneMode
end

return TeleporterInputAdapter