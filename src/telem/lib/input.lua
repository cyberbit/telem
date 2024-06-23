local function prefixInput(target) return 'telem.lib.input.' .. target end
local function prefixMek(target) return prefixInput('mekanism.' .. target) end

return {
    helloWorld              = require (prefixInput('HelloWorldInputAdapter')),
    custom                  = require (prefixInput('CustomInputAdapter')),

    -- storage
    itemStorage             = require (prefixInput('ItemStorageInputAdapter')),
    fluidStorage            = require (prefixInput('FluidStorageInputAdapter')),
    refinedStorage          = require (prefixInput('RefinedStorageInputAdapter')),
    meStorage               = require (prefixInput('MEStorageInputAdapter')),

    -- machinery
    mekanism = {
        bioGenerator        = require (prefixMek('BioGeneratorInputAdapter')),
        chemicalTank        = require (prefixMek('ChemicalTankInputAdapter')),
        digitalMiner        = require (prefixMek('DigitalMinerInputAdapter')),
        dynamicTank         = require (prefixMek('DynamicTankInputAdapter')),
        fissionReactor      = require (prefixMek('FissionReactorInputAdapter')),
        fusionReactor       = require (prefixMek('FusionReactorInputAdapter')),
        gasGenerator        = require (prefixMek('GasGeneratorInputAdapter')),
        inductionMatrix     = require (prefixMek('InductionMatrixInputAdapter')),
        industrialTurbine   = require (prefixMek('IndustrialTurbineInputAdapter')),
        isotopicCentrifuge  = require (prefixMek('IsotopicCentrifugeInputAdapter')),
        laser               = require (prefixMek('LaserInputAdapter')),
        laserAmplifier      = require (prefixMek('LaserAmplifierInputAdapter')),
        mechanicalPipe      = require (prefixMek('MechanicalPipeInputAdapter')),
        pressurizedTube     = require (prefixMek('PressurizedTubeInputAdapter')),
    },

    -- modem
    secureModem = require (prefixInput('SecureModemInputAdapter')),
}
