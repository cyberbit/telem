local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local InductionMatrixInputAdapter = o.class(BaseMekanismInputAdapter)
InductionMatrixInputAdapter.type = 'InductionMatrixInputAdapter'

function InductionMatrixInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekinduction:'

    local allCategories = {
        'basic',
        'advanced',
        'energy',
        'formation'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self.queries = {
        basic = {
            energy_input        = fn():callElse('getLastInput', 0):joulesToFE():energyRate(),
            energy_output       = fn():callElse('getLastOutput', 0):joulesToFE():energyRate(),
            energy_transfer_cap = fn():callElse('getTransferCap', 0):joulesToFE():energyRate(),
        },

        formation = {
            installed_cells     = fn():callElse('getInstalledCells', 0),
            installed_providers = fn():callElse('getInstalledProviders', 0),
        }
    }

    self:withGenericMachineQueries()
    self:withMultiblockQueries()

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