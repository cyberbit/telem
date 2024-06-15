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
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage'),
            energy_input                = fn():call('getLastInput'):joulesToFE():energyRate(),
            energy_output               = fn():call('getLastOutput'):joulesToFE():energyRate(),
            energy_transfer_cap         = fn():call('getTransferCap'):joulesToFE():energyRate()
        },
        advanced = {
            comparator_level            = fn():call('getComparatorLevel')
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy()
        },
        formation = {
            formed                      = fn():call('isFormed'):toFlag(),
            height                      = fn():call('getHeight'):with('unit', 'm'),
            length                      = fn():call('getLength'):with('unit', 'm'),
            width                       = fn():call('getWidth'):with('unit', 'm'),
            installed_cells             = fn():call('getInstalledCells'),
            installed_providers         = fn():call('getInstalledProviders')
        }
    }

    -- not sure if these are useful, but they return types which are not Metric compatible, RIP
    -- induction.getInputItem()
    -- induction.getOutputItem()
    -- induction.getMaxPos()
    -- induction.getMinPos()
end

return InductionMatrixInputAdapter