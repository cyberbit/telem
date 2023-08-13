local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local InductionMatrixInputAdapter = o.class(InputAdapter)
InductionMatrixInputAdapter.type = 'InductionMatrixInputAdapter'

function InductionMatrixInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

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

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()
end

function InductionMatrixInputAdapter:read ()
    self:boot()
    
    local source, induction = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- minimum necessary for monitoring a fission reactor safely
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = induction.getEnergyFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_input', value = mekanismEnergyHelper.joulesToFE(induction.getLastInput()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_output', value = mekanismEnergyHelper.joulesToFE(induction.getLastOutput()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_transfer_cap', value = mekanismEnergyHelper.joulesToFE(induction.getTransferCap()), unit = 'FE/t', source = source })

        -- some further production metrics
        elseif v == 'advanced' then
            metrics:insert(Metric{ name = self.prefix .. 'comparator_level', value = induction.getComparatorLevel(), unit = nil, source = source })

        elseif v == 'energy' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = mekanismEnergyHelper.joulesToFE(induction.getEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_energy', value = mekanismEnergyHelper.joulesToFE(induction.getMaxEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_needed', value = mekanismEnergyHelper.joulesToFE(induction.getEnergyNeeded()), unit = 'FE', source = source })

        -- measurements based on the multiblock structure itself
        elseif v == 'formation' then
            metrics:insert(Metric{ name = self.prefix .. 'formed', value = (induction.isFormed() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'height', value = induction.getHeight(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'length', value = induction.getLength(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'width', value = induction.getWidth(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'installed_cells', value = induction.getInstalledCells(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'installed_providers', value = induction.getInstalledProviders(), unit = nil, source = source })
        end

        loaded[v] = true

        -- not sure if these are useful, but they return types which are not Metric compatible, RIP
        -- induction.getInputItem()
        -- induction.getOutputItem()
        -- induction.getMaxPos()
        -- induction.getMinPos()
    end

    return metrics
end

return InductionMatrixInputAdapter