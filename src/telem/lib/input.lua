local prefixInput = 'telem.lib.input.'
local prefixMek = prefixInput .. 'mekanism.'

return {
    helloWorld              = require (prefixInput .. 'HelloWorldInputAdapter'),
    custom                  = require (prefixInput .. 'CustomInputAdapter'),

    -- storage
    itemStorage             = require (prefixInput .. 'ItemStorageInputAdapter'),
    fluidStorage            = require (prefixInput .. 'FluidStorageInputAdapter'),
    refinedStorage          = require (prefixInput .. 'RefinedStorageInputAdapter'),
    meStorage               = require (prefixInput .. 'MEStorageInputAdapter'),

    -- machinery
    mekanism = {
        bioGenerator        = require (prefixMek .. 'BioGeneratorInputAdapter'),
        chemicalTank        = require (prefixMek .. 'ChemicalTankInputAdapter'),
        digitalMiner        = require (prefixMek .. 'DigitalMinerInputAdapter'),
        dynamicTank         = require (prefixMek .. 'DynamicTankInputAdapter'),
        fissionReactor      = require (prefixMek .. 'FissionReactorInputAdapter'),
        fusionReactor       = require (prefixMek .. 'FusionReactorInputAdapter'),
        gasGenerator        = require (prefixMek .. 'GasGeneratorInputAdapter'),
        inductionMatrix     = require (prefixMek .. 'InductionMatrixInputAdapter'),
        industrialTurbine   = require (prefixMek .. 'IndustrialTurbineInputAdapter'),
        isotopicCentrifuge  = require (prefixMek .. 'IsotopicCentrifugeInputAdapter'),
        laser               = require (prefixMek .. 'LaserInputAdapter'),
        laserAmplifier      = require (prefixMek .. 'LaserAmplifierInputAdapter'),
    },

    -- modem
    secureModem = require (prefixInput .. 'SecureModemInputAdapter'),
}
