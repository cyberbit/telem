local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local QuantumEntangloporterInputAdapter = base.mintAdapter('QuantumEntangloporterInputAdapter')

function QuantumEntangloporterInputAdapter:beforeRegister ()
    self.prefix = 'mekentanglo:'

    self.queries = {
        basic = {
            fluid_filled_percentage     = fn():call('getBufferFluidFilledPercentage'),
            gas_filled_percentage       = fn():call('getBufferGasFilledPercentage'),
            infuse_filled_percentage    = fn():call('getBufferInfuseTypeFilledPercentage'),
            pigment_filled_percentage   = fn():call('getBufferPigmentFilledPercentage'),
            slurry_filled_percentage    = fn():call('getBufferSlurryFilledPercentage'),
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage'),
            temperature                 = fn():call('getTemperature'):temp(),
        },
        advanced = {
            transfer_loss               = fn():call('getTransferLoss'),
            environmental_loss          = fn():call('getEnvironmentalLoss'),
        },
        fluid = {
            fluid                       = fn():call('getBufferFluid'):get('amount'):div(1000):fluid(),
            fluid_capacity              = fn():call('getBufferFluidCapacity'):div(1000):fluid(),
            fluid_needed                = fn():call('getBufferFluidNeeded'):div(1000):fluid(),
        },
        gas = {
            gas                         = fn():call('getBufferGas'):get('amount'):div(1000):fluid(),
            gas_capacity                = fn():call('getBufferGasCapacity'):div(1000):fluid(),
            gas_needed                  = fn():call('getBufferGasNeeded'):div(1000):fluid(),
        },
        infuse = {
            infuse                      = fn():call('getBufferInfuseType'):get('amount'):div(1000):fluid(),
            infuse_capacity             = fn():call('getBufferInfuseTypeCapacity'):div(1000):fluid(),
            infuse_needed               = fn():call('getBufferInfuseTypeNeeded'):div(1000):fluid(),
        },
        item = {
            item_count                  = fn():call('getBufferItem'):get('count'),
        },
        pigment = {
            pigment                     = fn():call('getBufferPigment'):get('amount'):div(1000):fluid(),
            pigment_capacity            = fn():call('getBufferPigmentCapacity'):div(1000):fluid(),
            pigment_needed              = fn():call('getBufferPigmentNeeded'):div(1000):fluid(),
        },
        slurry = {
            slurry                      = fn():call('getBufferSlurry'):get('amount'):div(1000):fluid(),
            slurry_capacity             = fn():call('getBufferSlurryCapacity'):div(1000):fluid(),
            slurry_needed               = fn():call('getBufferSlurryNeeded'):div(1000):fluid(),
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
    }
end

return QuantumEntangloporterInputAdapter