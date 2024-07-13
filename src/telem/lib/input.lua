local function requireInput(target) return require ('telem.lib.input.' .. target) end
local function requireMek(target) return requireInput('mekanism.' .. target) end
local function requirePowah(target) return requireInput('powah.' .. target) end

return {
    helloWorld                  = requireInput('HelloWorldInputAdapter'),
    custom                      = requireInput('CustomInputAdapter'),

    -- storage
    itemStorage                 = requireInput('ItemStorageInputAdapter'),
    fluidStorage                = requireInput('FluidStorageInputAdapter'),
    refinedStorage              = requireInput('RefinedStorageInputAdapter'),
    meStorage                   = requireInput('MEStorageInputAdapter'),

    -- communication
    secureModem                 = requireInput('SecureModemInputAdapter'),

    advancedPeripherals = {
        energyDetector = require 'telem.lib.input.advancedPeripherals.EnergyDetectorInputAdapter',
    },

    mekanism = {
        -- machines
        apns                    = requireMek('AntiprotonicNucleosynthesizerInputAdapter'),
        bin                     = requireMek('BinInputAdapter'),
        bioGenerator            = requireMek('BioGeneratorInputAdapter'),
        boiler                  = requireMek('ThermoelectricBoilerInputAdapter'),
        chemicalCrystallizer    = requireMek('ChemicalCrystallizerInputAdapter'),
        dissolutionChamber      = requireMek('ChemicalDissolutionChamberInputAdapter'),
        chemicalInfuser         = requireMek('ChemicalInfuserInputAdapter'),
        injectionChamber        = requireMek('ChemicalInjectionChamberInputAdapter'),
        chemicalOxidizer        = requireMek('ChemicalOxidizerInputAdapter'),
        chemicalTank            = requireMek('ChemicalTankInputAdapter'),
        chemicalWasher          = requireMek('ChemicalWasherInputAdapter'),
        combiner                = requireMek('CombinerInputAdapter'),
        crusher                 = requireMek('CrusherInputAdapter'),
        digitalMiner            = requireMek('DigitalMinerInputAdapter'),
        dynamicTank             = requireMek('DynamicTankInputAdapter'),
        electricPump            = requireMek('ElectricPumpInputAdapter'),
        electrolyticSeparator   = requireMek('ElectrolyticSeparatorInputAdapter'),
        energizedSmelter        = requireMek('EnergizedSmelterInputAdapter'),
        energyCube              = requireMek('EnergyCubeInputAdapter'),
        enrichmentChamber       = requireMek('EnrichmentChamberInputAdapter'),
        fissionReactor          = requireMek('FissionReactorInputAdapter'),
        fluidTank               = requireMek('FluidTankInputAdapter'),
        fluidicPlenisher        = requireMek('FluidicPlenisherInputAdapter'),
        assemblicator           = requireMek('FormulaicAssemblicatorInputAdapter'),
        fuelwoodHeater          = requireMek('FuelwoodHeaterInputAdapter'),
        fusionReactor           = requireMek('FusionReactorInputAdapter'),
        gasGenerator            = requireMek('GasGeneratorInputAdapter'),
        heatGenerator           = requireMek('HeatGeneratorInputAdapter'),
        inductionMatrix         = requireMek('InductionMatrixInputAdapter'),
        industrialTurbine       = requireMek('IndustrialTurbineInputAdapter'),
        isotopicCentrifuge      = requireMek('IsotopicCentrifugeInputAdapter'),
        laser                   = requireMek('LaserInputAdapter'),
        laserAmplifier          = requireMek('LaserAmplifierInputAdapter'),
        laserTractorBeam        = requireMek('LaserTractorBeamInputAdapter'),
        logisticalSorter        = requireMek('LogisticalSorterInputAdapter'),
        mechanicalPipe          = requireMek('MechanicalPipeInputAdapter'),
        metallurgicInfuser      = requireMek('MetallurgicInfuserInputAdapter'),
        nutritionalLiquifier    = requireMek('NutritionalLiquifierInputAdapter'),
        oredictionificator      = requireMek('OredictionificatorInputAdapter'),
        osmiumCompressor        = requireMek('OsmiumCompressorInputAdapter'),
        paintingMachine         = requireMek('PaintingMachineInputAdapter'),
        pigmentExtractor        = requireMek('PigmentExtractorInputAdapter'),
        pigmentMixer            = requireMek('PigmentMixerInputAdapter'),
        precisionSawmill        = requireMek('PrecisionSawmillInputAdapter'),
        reactionChamber         = requireMek('PressurizedReactionChamberInputAdapter'),
        pressurizedTube         = requireMek('PressurizedTubeInputAdapter'),
        purificationChamber     = requireMek('PurificationChamberInputAdapter'),
        quantumEntangloporter   = requireMek('QuantumEntangloporterInputAdapter'),
        wasteBarrel             = requireMek('RadioactiveWasteBarrelInputAdapter'),
        resistiveHeater         = requireMek('ResistiveHeaterInputAdapter'),
        condensentrator         = requireMek('RotaryCondensentratorInputAdapter'),
        sps                     = requireMek('SupercriticalPhaseShifterInputAdapter'),
        seismicVibrator         = requireMek('SeismicVibratorInputAdapter'),
        solarGenerator          = requireMek('SolarGeneratorInputAdapter'),
        neutronActivator        = requireMek('SolarNeutronActivatorInputAdapter'),
        teleporter              = requireMek('TeleporterInputAdapter'),
        evaporationPlant        = requireMek('ThermalEvaporationPlantInputAdapter'),
        universalCable          = requireMek('UniversalCableInputAdapter'),
        windGenerator           = requireMek('WindGeneratorInputAdapter'),

        -- factories
        combiningFactory        = requireMek('CombiningFactoryInputAdapter'),
        compressingFactory      = requireMek('CompressingFactoryInputAdapter'),
        crushingFactory         = requireMek('CrushingFactoryInputAdapter'),
        enrichingFactory        = requireMek('EnrichingFactoryInputAdapter'),
        infusingFactory         = requireMek('InfusingFactoryInputAdapter'),
        injectingFactory        = requireMek('InjectingFactoryInputAdapter'),
        purifyingFactory        = requireMek('PurifyingFactoryInputAdapter'),
        sawingFactory           = requireMek('SawingFactoryInputAdapter'),
        smeltingFactory         = requireMek('SmeltingFactoryInputAdapter'),

        -- QIO
        qioDriveArray           = requireMek('QIODriveArrayInputAdapter'),
    },

    powah = {
        energyCell              = requirePowah('EnergyCellInputAdapter'),
        furnator                = requirePowah('FurnatorInputAdapter'),
        magmator                = requirePowah('MagmatorInputAdapter'),
        reactor                 = requirePowah('ReactorInputAdapter'),
        solarPanel              = requirePowah('SolarPanelInputAdapter'),
        thermoGenerator         = requirePowah('ThermoGeneratorInputAdapter'),
    }
}
