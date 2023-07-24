local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local FissionReactorInputAdapter = o.class(InputAdapter)
FissionReactorInputAdapter.type = 'FissionReactorInputAdapter'

function FissionReactorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekfission:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
        'fuel',
        'coolant',
        'waste',
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

function FissionReactorInputAdapter:read ()
    local source, fission = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- minimum necessary for monitoring a fission reactor safely
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'status', value = (fission.getStatus() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'burn_rate', value = fission.getBurnRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_burn_rate', value = fission.getMaxBurnRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'temperature', value = fission.getTemperature(), unit = 'K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'damage_percent', value = fission.getDamagePercent(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_filled_percentage', value = fission.getFuelFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coolant_filled_percentage', value = fission.getCoolantFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant_filled_percentage', value = fission.getHeatedCoolantFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'waste_filled_percentage', value = fission.getWasteFilledPercentage(), unit = nil, source = source })

        -- some further production metrics
        elseif v == 'advanced' then
            metrics:insert(Metric{ name = self.prefix .. 'actual_burn_rate', value = fission.getActualBurnRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'environmental_loss', value = fission.getEnvironmentalLoss(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heating_rate', value = fission.getHeatingRate() / 1000, unit = 'B/t', source = source })

        elseif v == 'coolant' then
            metrics:insert(Metric{ name = self.prefix .. 'coolant', value = fission.getCoolant().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coolant_capacity', value = fission.getCoolantCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'coolant_needed', value = fission.getCoolantNeeded() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant', value = fission.getHeatedCoolant().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant_capacity', value = fission.getHeatedCoolantCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heated_coolant_needed', value = fission.getHeatedCoolantNeeded() / 1000, unit = 'B', source = source })

        elseif v == 'fuel' then
            metrics:insert(Metric{ name = self.prefix .. 'fuel', value = fission.getFuel().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_capacity', value = fission.getFuelCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_needed', value = fission.getFuelNeeded(), unit = 'B', source = source })

        elseif v == 'waste' then
            metrics:insert(Metric{ name = self.prefix .. 'waste', value = fission.getWaste().amount / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'waste_capacity', value = fission.getWasteCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'waste_needed', value = fission.getWasteNeeded() / 1000, unit = 'B', source = source })

        -- measurements based on the multiblock structure itself
        elseif v == 'formation' then
            metrics:insert(Metric{ name = self.prefix .. 'formed', value = (fission.isFormed() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'force_disabled', value = (fission.isForceDisabled() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'height', value = fission.getHeight(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'length', value = fission.getLength(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'width', value = fission.getWidth(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_assemblies', value = fission.getFuelAssemblies(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_surface_area', value = fission.getFuelSurfaceArea(), unit = 'm²', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'heat_capacity', value = fission.getHeatCapacity(), unit = 'J/K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'boil_efficiency',  value = fission.getBoilEfficiency(), unit = nil, source = source })
        end

        loaded[v] = true

        -- not sure if these are useful, but they return strings anyway which are not Metric compatible, RIP
        -- metrics:insert(Metric{ name = self.prefix .. 'logic_mode', value = fission.getLogicMode(), unit = nil, source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'redstone_logic_status', value = fission.getRedstoneLogicStatus(), unit = nil, source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'redstone_mode', value = fission.getRedstoneLogicStatus(), unit = nil, source = source })
    end

    return metrics
end

return FissionReactorInputAdapter