local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local FusionReactorInputAdapter = o.class(InputAdapter)
FusionReactorInputAdapter.type = 'FusionReactorInputAdapter'

function FusionReactorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekfusion:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
        'fuel',
        'coolant',
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

function FusionReactorInputAdapter:read ()
    local source, fusion = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- minimum necessary for monitoring a fusion reactor
        elseif v == 'basic' then
            local isActive = fusion.isActiveCooledLogic()
            metrics:insert(Metric{ name = self.prefix .. 'plasma_temperature', value = fusion.getPlasmaTemperature(), unit = 'K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'case_temperature', value = fusion.getCaseTemperature(), unit = 'K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'water_filled_percentage', value = fusion.getWaterFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_filled_percentage', value = fusion.getSteamFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'tritium_filled_percentage', value = fusion.getTritiumFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'deuterium_filled_percentage', value = fusion.getDeuteriumFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'dt_fuel_filled_percentage', value = fusion.getDTFuelFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'production_rate', value = mekanismEnergyHelper.joulesToFE(fusion.getProductionRate()), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'injection_rate', value = fusion.getInjectionRate() / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'min_injection_rate', value = fusion.getMinInjectionRate(isActive) / 1000, unit = 'B/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_plasma_temperature', value = fusion.getMaxPlasmaTemperature(isActive), unit = 'K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'max_casing_temperature', value = fusion.getMaxCasingTemperature(isActive), unit = 'K', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'passive_generation_rate', value = mekanismEnergyHelper.joulesToFE(fusion.getPassiveGeneration(isActive)), unit = 'FE/t', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'ignition_temperature', value = fusion.getIgnitionTemperature(isActive), unit = 'K', source = source })

        -- some further production metrics
        elseif v == 'advanced' then
            -- metrics:insert(Metric{ name = self.prefix .. 'transfer_loss', value = fusion.getTransferLoss(), unit = nil, source = source })
            -- metrics:insert(Metric{ name = self.prefix .. 'environmental_loss', value = fusion.getEnvironmentalLoss(), unit = nil, source = source })
            
        elseif v == 'coolant' then
            metrics:insert(Metric{ name = self.prefix .. 'water_capacity', value = fusion.getWaterCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'water_needed', value = fusion.getWaterNeeded() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_capacity', value = fusion.getSteamCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'steam_needed', value = fusion.getSteamNeeded() / 1000, unit = 'B', source = source })
            
        elseif v == 'fuel' then
            metrics:insert(Metric{ name = self.prefix .. 'tritium_capacity', value = fusion.getTritiumCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'tritium_needed', value = fusion.getTritiumNeeded() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'deuterium_capacity', value = fusion.getDeuteriumCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'deuterium_needed', value = fusion.getDeuteriumNeeded() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'dt_fuel_capacity', value = fusion.getDTFuelCapacity() / 1000, unit = 'B', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'dt_fuel_needed', value = fusion.getDTFuelNeeded() / 1000, unit = 'B', source = source })
            
            -- measurements based on the multiblock structure itself
        elseif v == 'formation' then
            metrics:insert(Metric{ name = self.prefix .. 'formed', value = (fusion.isFormed() and 1 or 0), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'height', value = fusion.getHeight(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'length', value = fusion.getLength(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'width', value = fusion.getWidth(), unit = 'm', source = source })
            metrics:insert(Metric{ name = self.prefix .. 'active_cooled_logic', value = (fusion.isActiveCooledLogic() and 1 or 0), unit = nil, source = source })
        end
        
        loaded[v] = true
        
        -- not sure if these are useful, but they return strings anyway which are not Metric compatible, RIP
        -- metrics:insert(Metric{ name = self.prefix .. 'logic_mode', value = fusion.getLogicMode(), unit = nil, source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'tritium', value = fusion.getTritium() / 1000, unit = 'B', source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'deuterium', value = fusion.getDeuterium() / 1000, unit = 'B', source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'dt_fuel', value = fusion.getDTFuel() / 1000, unit = 'B', source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'hohlraum', value = fusion.getHohlraum(), unit = nil, source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'water', value = fusion.getWater() / 1000, unit = 'B', source = source })
        -- metrics:insert(Metric{ name = self.prefix .. 'steam', value = fusion.getSteam() / 1000, unit = 'B', source = source })
    end
    
    return metrics
end

return FusionReactorInputAdapter