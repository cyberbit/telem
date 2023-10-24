local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local QuantumEntangloporterInputAdapter = o.class(InputAdapter)
QuantumEntangloporterInputAdapter.type = 'QuantumEntangloporterInputAdapter'

function QuantumEntangloporterInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekquantumentanglo:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'fluid',
        'gas',
        'infuse',
        'item',
        'pigment',
        'slurry',
        'loss',
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

function QuantumEntangloporterInputAdapter:read ()
    self:boot()

    local source, quantum_entangloporter = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- Literally all we have lmao
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy_amount', value = quantum_entangloporter.getEnergy(), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_needed', value = quantum_entangloporter.getEnergyNeeded(), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = quantum_entangloporter.getEnergyFilledPercentage(), unit = nil, source = source })
        elseif v == 'fluid' then
            metrics:insert(Metric{ name = self.prefix .. 'fluid_amount', value = quantum_entangloporter.getBufferFluid().amount / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fluid_capacity', value = quantum_entangloporter.getBufferFluidCapacity() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fluid_filled_percentage', value = quantum_entangloporter.getBufferFluidFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fluid_needed', value = quantum_entangloporter.getBufferFluidNeeded() / 1000, unit = "B", source = source })
        elseif v == 'gas' then
            metrics:insert(Metric{ name = self.prefix .. 'gas_amount', value = quantum_entangloporter.getBufferGas().amount / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'gas_capacity', value = quantum_entangloporter.getBufferGasCapacity() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'gas_filled_percentage', value = quantum_entangloporter.getBufferGasFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'gas_needed', value = quantum_entangloporter.getBufferGasNeeded() / 1000, unit = "B", source = source })
        elseif v == 'infuse' then
            metrics:insert(Metric{ name = self.prefix .. 'infuse_amount', value = quantum_entangloporter.getBufferInfuse().amount / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'infuse_capacity', value = quantum_entangloporter.getBufferInfuseCapacity() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'infuse_filled_percentage', value = quantum_entangloporter.getBufferInfuseFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'infuse_needed', value = quantum_entangloporter.getBufferInfuseNeeded() / 1000, unit = "B", source = source })
        elseif v == 'item' then
            metrics:insert(Metric{ name = self.prefix .. 'item_amount', value = quantum_entangloporter.getBufferItem().count, unit = nil, source = source })
        elseif v == 'pigment' then
            metrics:insert(Metric{ name = self.prefix .. 'pigment_amount', value = quantum_entangloporter.getBufferPigment().amount / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'pigment_capacity', value = quantum_entangloporter.getBufferPigmentCapacity() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'pigment_filled_percentage', value = quantum_entangloporter.getBufferPigmentFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'pigment_needed', value = quantum_entangloporter.getBufferPigmentNeeded() / 1000, unit = "B", source = source })
        elseif v == 'slurry' then
            metrics:insert(Metric{ name = self.prefix .. 'slurry_amount', value = quantum_entangloporter.getBufferSlurry().amount / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'slurry_capacity', value = quantum_entangloporter.getBufferSlurryCapacity() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'slurry_filled_percentage', value = quantum_entangloporter.getBufferSlurryFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'slurry_needed', value = quantum_entangloporter.getBufferSlurryNeeded() / 1000, unit = "B", source = source })
        elseif v == 'loss' then
            metrics:insert(Metric{ name = self.prefix .. 'transfer_loss', value = quantum_entangloporter.getTransferLoss(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'environmental_loss', value = quantum_entangloporter.getEnvironmentalLoss(), unit = nil, source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return QuantumEntangloporterInputAdapter

