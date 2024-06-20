return {
    helloWorld = require 'telem.lib.input.HelloWorldInputAdapter',
    custom = require 'telem.lib.input.CustomInputAdapter',

    -- storage
    itemStorage = require 'telem.lib.input.ItemStorageInputAdapter',
    fluidStorage = require 'telem.lib.input.FluidStorageInputAdapter',
    refinedStorage = require 'telem.lib.input.RefinedStorageInputAdapter',
    meStorage = require 'telem.lib.input.MEStorageInputAdapter',

    -- machinery
    mekanism = {
        fissionReactor = require 'telem.lib.input.mekanism.FissionReactorInputAdapter',
        inductionMatrix = require 'telem.lib.input.mekanism.InductionMatrixInputAdapter',
        industrialTurbine = require 'telem.lib.input.mekanism.IndustrialTurbineInputAdapter',
        fusionReactor = require 'telem.lib.input.mekanism.FusionReactorInputAdapter',
    },

    -- or advanced_peripherals?
    advancedPeripherals = {
        energyDetector = require 'telem.lib.input.advancedPeripherals.EnergyDetectorInputAdapter',
    },

    -- modem
    secureModem = require 'telem.lib.input.SecureModemInputAdapter'
}