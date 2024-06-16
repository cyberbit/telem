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
        chemicalTank = require 'telem.lib.input.mekanism.ChemicalTankInputAdapter',
        bioGenerator = require 'telem.lib.input.mekanism.BioGeneratorInputAdapter',
        dynamicTank = require 'telem.lib.input.mekanism.DynamicTankInputAdapter',
        digitalMiner = require 'telem.lib.input.mekanism.DigitalMinerInputAdapter',
        gasGenerator = require 'telem.lib.input.mekanism.GasGeneratorInputAdapter',
    },

    -- modem
    secureModem = require 'telem.lib.input.SecureModemInputAdapter'
}
