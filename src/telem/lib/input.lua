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
        bioGenerator        = require 'telem.lib.input.mekanism.BioGeneratorInputAdapter',
        chemicalTank        = require 'telem.lib.input.mekanism.ChemicalTankInputAdapter',
        digitalMiner        = require 'telem.lib.input.mekanism.DigitalMinerInputAdapter',
        dynamicTank         = require 'telem.lib.input.mekanism.DynamicTankInputAdapter',
        fissionReactor      = require 'telem.lib.input.mekanism.FissionReactorInputAdapter',
        fusionReactor       = require 'telem.lib.input.mekanism.FusionReactorInputAdapter',
        gasGenerator        = require 'telem.lib.input.mekanism.GasGeneratorInputAdapter',
        inductionMatrix     = require 'telem.lib.input.mekanism.InductionMatrixInputAdapter',
        industrialTurbine   = require 'telem.lib.input.mekanism.IndustrialTurbineInputAdapter',
        isotopicCentrifuge  = require 'telem.lib.input.mekanism.IsotopicCentrifugeInputAdapter',
    },

    -- modem
    secureModem = require 'telem.lib.input.SecureModemInputAdapter'
}
