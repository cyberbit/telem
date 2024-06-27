local function requireInput(target) return require ('telem.lib.input.' .. target) end
local function requireMek(target) return requireInput('mekanism.' .. target) end

return {
    helloWorld                  = requireInput('HelloWorldInputAdapter'),
    custom                      = requireInput('CustomInputAdapter'),

    -- storage
    itemStorage                 = requireInput('ItemStorageInputAdapter'),
    fluidStorage                = requireInput('FluidStorageInputAdapter'),
    refinedStorage              = requireInput('RefinedStorageInputAdapter'),
    meStorage                   = requireInput('MEStorageInputAdapter'),

    -- machinery
    mekanism = {
        apns                    = requireMek('AntiprotonicNucleosynthesizerInputAdapter'),
        bin                     = requireMek('BinInputAdapter'),
        bioGenerator            = requireMek('BioGeneratorInputAdapter'),
        boiler                  = requireMek('ThermoelectricBoilerInputAdapter'),
        chemicalCrystallizer    = requireMek('ChemicalCrystallizerInputAdapter'),
        dissolutionChamber      = requireMek('ChemicalDissolutionChamberInputAdapter'),
        chemicalTank            = requireMek('ChemicalTankInputAdapter'),
        digitalMiner            = requireMek('DigitalMinerInputAdapter'),
        dynamicTank             = requireMek('DynamicTankInputAdapter'),
        fissionReactor          = requireMek('FissionReactorInputAdapter'),
        fusionReactor           = requireMek('FusionReactorInputAdapter'),
        gasGenerator            = requireMek('GasGeneratorInputAdapter'),
        inductionMatrix         = requireMek('InductionMatrixInputAdapter'),
        industrialTurbine       = requireMek('IndustrialTurbineInputAdapter'),
        isotopicCentrifuge      = requireMek('IsotopicCentrifugeInputAdapter'),
        laser                   = requireMek('LaserInputAdapter'),
        laserAmplifier          = requireMek('LaserAmplifierInputAdapter'),
        mechanicalPipe          = requireMek('MechanicalPipeInputAdapter'),
        pressurizedTube         = requireMek('PressurizedTubeInputAdapter'),
        quantumEntangloporter   = requireMek('QuantumEntangloporterInputAdapter'),
        universalCable          = requireMek('UniversalCableInputAdapter'),
    },

    -- modem
    secureModem                 = requireInput('SecureModemInputAdapter'),
}
