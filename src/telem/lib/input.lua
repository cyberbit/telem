local function requireInput(target) return require ('telem.lib.input.' .. target) end
local function requireAP(target) return requireInput('advancedPeripherals.' .. target) end
local function requireBR(target) return requireInput('biggerReactors.' .. target) end
local function requireMek(target) return requireInput('mekanism.' .. target) end
local function requirePowah(target) return requireInput('powah.' .. target) end
local function requireCreate(target) return requireInput('create.' .. target) end

local export = {
    helloWorld                   = requireInput('HelloWorldInputAdapter'),
    custom                       = requireInput('CustomInputAdapter'),

    -- storage
    itemStorage                  = requireInput('ItemStorageInputAdapter'),
    fluidStorage                 = requireInput('FluidStorageInputAdapter'),

    -- communication
    secureModem                  = requireInput('SecureModemInputAdapter'),

    advancedPeripherals = {
        energyDetector           = requireAP('EnergyDetectorInputAdapter'),
        environmentDetector      = requireAP('EnvironmentDetectorInputAdapter'),
        geoScanner               = requireAP('GeoScannerInputAdapter'),
        inventoryManager         = requireAP('InventoryManagerInputAdapter'),
        meBridge                 = requireAP('MEBridgeInputAdapter'),
        playerDetector           = requireAP('PlayerDetectorInputAdapter'),
        redstoneIntegrator       = requireAP('RedstoneIntegratorInputAdapter'),
        rsBridge                 = requireAP('RSBridgeInputAdapter'),
    },

    biggerReactors = {
        reactor                  = requireBR('ReactorInputAdapter'),
        turbine                  = requireBR('TurbineInputAdapter'),
    },

    mekanism = {
        -- machines
        apns                     = requireMek('AntiprotonicNucleosynthesizerInputAdapter'),
        bin                      = requireMek('BinInputAdapter'),
        bioGenerator             = requireMek('BioGeneratorInputAdapter'),
        boiler                   = requireMek('ThermoelectricBoilerInputAdapter'),
        chemicalCrystallizer     = requireMek('ChemicalCrystallizerInputAdapter'),
        dissolutionChamber       = requireMek('ChemicalDissolutionChamberInputAdapter'),
        chemicalInfuser          = requireMek('ChemicalInfuserInputAdapter'),
        injectionChamber         = requireMek('ChemicalInjectionChamberInputAdapter'),
        chemicalOxidizer         = requireMek('ChemicalOxidizerInputAdapter'),
        chemicalTank             = requireMek('ChemicalTankInputAdapter'),
        chemicalWasher           = requireMek('ChemicalWasherInputAdapter'),
        combiner                 = requireMek('CombinerInputAdapter'),
        crusher                  = requireMek('CrusherInputAdapter'),
        digitalMiner             = requireMek('DigitalMinerInputAdapter'),
        dynamicTank              = requireMek('DynamicTankInputAdapter'),
        electricPump             = requireMek('ElectricPumpInputAdapter'),
        electrolyticSeparator    = requireMek('ElectrolyticSeparatorInputAdapter'),
        energizedSmelter         = requireMek('EnergizedSmelterInputAdapter'),
        energyCube               = requireMek('EnergyCubeInputAdapter'),
        enrichmentChamber        = requireMek('EnrichmentChamberInputAdapter'),
        fissionReactor           = requireMek('FissionReactorInputAdapter'),
        fluidTank                = requireMek('FluidTankInputAdapter'),
        fluidicPlenisher         = requireMek('FluidicPlenisherInputAdapter'),
        assemblicator            = requireMek('FormulaicAssemblicatorInputAdapter'),
        fuelwoodHeater           = requireMek('FuelwoodHeaterInputAdapter'),
        fusionReactor            = requireMek('FusionReactorInputAdapter'),
        gasGenerator             = requireMek('GasGeneratorInputAdapter'),
        heatGenerator            = requireMek('HeatGeneratorInputAdapter'),
        inductionMatrix          = requireMek('InductionMatrixInputAdapter'),
        industrialTurbine        = requireMek('IndustrialTurbineInputAdapter'),
        isotopicCentrifuge       = requireMek('IsotopicCentrifugeInputAdapter'),
        laser                    = requireMek('LaserInputAdapter'),
        laserAmplifier           = requireMek('LaserAmplifierInputAdapter'),
        laserTractorBeam         = requireMek('LaserTractorBeamInputAdapter'),
        logisticalSorter         = requireMek('LogisticalSorterInputAdapter'),
        mechanicalPipe           = requireMek('MechanicalPipeInputAdapter'),
        metallurgicInfuser       = requireMek('MetallurgicInfuserInputAdapter'),
        nutritionalLiquifier     = requireMek('NutritionalLiquifierInputAdapter'),
        oredictionificator       = requireMek('OredictionificatorInputAdapter'),
        osmiumCompressor         = requireMek('OsmiumCompressorInputAdapter'),
        paintingMachine          = requireMek('PaintingMachineInputAdapter'),
        pigmentExtractor         = requireMek('PigmentExtractorInputAdapter'),
        pigmentMixer             = requireMek('PigmentMixerInputAdapter'),
        precisionSawmill         = requireMek('PrecisionSawmillInputAdapter'),
        reactionChamber          = requireMek('PressurizedReactionChamberInputAdapter'),
        pressurizedTube          = requireMek('PressurizedTubeInputAdapter'),
        purificationChamber      = requireMek('PurificationChamberInputAdapter'),
        quantumEntangloporter    = requireMek('QuantumEntangloporterInputAdapter'),
        wasteBarrel              = requireMek('RadioactiveWasteBarrelInputAdapter'),
        resistiveHeater          = requireMek('ResistiveHeaterInputAdapter'),
        condensentrator          = requireMek('RotaryCondensentratorInputAdapter'),
        sps                      = requireMek('SupercriticalPhaseShifterInputAdapter'),
        seismicVibrator          = requireMek('SeismicVibratorInputAdapter'),
        solarGenerator           = requireMek('SolarGeneratorInputAdapter'),
        neutronActivator         = requireMek('SolarNeutronActivatorInputAdapter'),
        teleporter               = requireMek('TeleporterInputAdapter'),
        evaporationPlant         = requireMek('ThermalEvaporationPlantInputAdapter'),
        universalCable           = requireMek('UniversalCableInputAdapter'),
        windGenerator            = requireMek('WindGeneratorInputAdapter'),

        -- factories
        combiningFactory         = requireMek('CombiningFactoryInputAdapter'),
        compressingFactory       = requireMek('CompressingFactoryInputAdapter'),
        crushingFactory          = requireMek('CrushingFactoryInputAdapter'),
        enrichingFactory         = requireMek('EnrichingFactoryInputAdapter'),
        infusingFactory          = requireMek('InfusingFactoryInputAdapter'),
        injectingFactory         = requireMek('InjectingFactoryInputAdapter'),
        purifyingFactory         = requireMek('PurifyingFactoryInputAdapter'),
        sawingFactory            = requireMek('SawingFactoryInputAdapter'),
        smeltingFactory          = requireMek('SmeltingFactoryInputAdapter'),

        -- QIO
        qioDriveArray            = requireMek('QIODriveArrayInputAdapter'),
    },

    powah = {
        energyCell               = requirePowah('EnergyCellInputAdapter'),
        furnator                 = requirePowah('FurnatorInputAdapter'),
        magmator                 = requirePowah('MagmatorInputAdapter'),
        reactor                  = requirePowah('ReactorInputAdapter'),
        solarPanel               = requirePowah('SolarPanelInputAdapter'),
        thermoGenerator          = requirePowah('ThermoGeneratorInputAdapter'),
    },

    create = {
        stressometerInputAdapter = requireCreate('StressometerInputAdapter'),
        speedometerInputAdapter  = requireCreate('SpeedometerInputAdapter'),
    }
}

-- aliases that will be deprecated in the future
export.refinedStorage              = export.advancedPeripherals.rsBridge
export.meStorage                   = export.advancedPeripherals.meBridge

return export