local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local InductionMatrixInputAdapter = base.mintAdapter('InductionMatrixInputAdapter')

function InductionMatrixInputAdapter:beforeRegister ()
    self.prefix = 'mekinduction:'

    self.queries = {
        basic = {
            energy_input        = fn():call('getLastInput'):joulesToFE():energyRate(),
            energy_output       = fn():call('getLastOutput'):joulesToFE():energyRate(),
            energy_transfer_cap = fn():call('getTransferCap'):joulesToFE():energyRate(),
        },

        formation = {
            installed_cells     = fn():call('getInstalledCells'),
            installed_providers = fn():call('getInstalledProviders'),
        }
    }

    self:withGenericMachineQueries()
        :withMultiblockQueries()

    -- getMaxPos
    -- getInputItem
    -- getOutputItem
    -- getMinPos
    -- getMode

    -- for generic, does NOT implement:
        -- getDirection
        -- getRedstoneMode
end

return InductionMatrixInputAdapter