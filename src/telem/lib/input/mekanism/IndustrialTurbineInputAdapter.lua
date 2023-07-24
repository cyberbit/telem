local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local IndustrialTurbineInputAdapter = o.class(InputAdapter)
IndustrialTurbineInputAdapter.type = 'IndustrialTurbineInputAdapter'

local DUMPING_MODES = {
    IDLE = 1,
    DUMPING_EXCESS = 2,
    DUMPING = 3,
}

function IndustrialTurbineInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekturbine:'

    local allCategories = {
        'basic',
        'advanced',
        'energy',
        'steam',
        'formation'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self:addComponentByPeripheralID(peripheralName)
end

function IndustrialTurbineInputAdapter:read ()
    local source, turbine = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- minimum necessary for monitoring a fission reactor safely
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = turbine.getEnergyFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_production_rate', value = mekanismEnergyHelper.joulesToFE(turbine.getProductionRate()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_max_production', value = mekanismEnergyHelper.joulesToFE(turbine.getMaxProduction()), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_filled_percentage', value = turbine.getSteamFilledPercentage(), unit = nil, source = source })

        -- some further production metrics
        elseif v == 'advanced' then
            metrics:insert(Metric{ name = self.prefix .. 'comparator_level', value = turbine.getComparatorLevel(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'dumping_mode', value = DUMPING_MODES[turbine.getDumpingMode()], unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'flow_rate', value = turbine.getFlowRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_flow_rate', value = turbine.getMaxFlowRate() / 1000, unit = 'B/t', source = source })

        elseif v == 'energy' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = mekanismEnergyHelper.joulesToFE(turbine.getEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_energy', value = mekanismEnergyHelper.joulesToFE(turbine.getMaxEnergy()), unit = 'FE', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_needed', value = mekanismEnergyHelper.joulesToFE(turbine.getEnergyNeeded()), unit = 'FE', source = source })

        elseif v == 'steam' then
            metrics:insert(Metric{ name = self.prefix .. 'steam_input_rate', value = turbine.getLastSteamInputRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam', value = turbine.getSteam().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_capacity', value = turbine.getSteamCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_needed', value = turbine.getSteamNeeded() / 1000, unit = 'B', source = source })

        -- measurements based on the multiblock structure itself
        elseif v == 'formation' then
            metrics:insert(Metric{ name = self.prefix .. 'formed', value = (turbine.isFormed() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'height', value = turbine.getHeight(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'length', value = turbine.getLength(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'width', value = turbine.getWidth(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'blades', value = turbine.getBlades(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coils', value = turbine.getCoils(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'condensers', value = turbine.getCondensers(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'dispersers', value = turbine.getDispersers(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'vents', value = turbine.getVents(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_water_output', value = turbine.getMaxWaterOutput() / 1000, unit = 'B/t', source = source })
        end

        loaded[v] = true

        -- not sure if these are useful, but they return types which are not Metric compatible, RIP
        -- turbine.getMaxPos(),
        -- turbine.getMinPos(),
    end

    return metrics
end

return IndustrialTurbineInputAdapter