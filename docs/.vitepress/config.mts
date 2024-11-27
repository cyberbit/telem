import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Telem",
  description: "Trivial Extract and Load Engine for Minecraft",

  srcDir: '.',
  srcExclude: ['**/common/*.md'],

  cleanUrls: true,
  ignoreDeadLinks: 'localhostLinks',
  markdown: {
    image: {
      lazyLoading: true
    }
  },
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Changelog', link: 'https://github.com/cyberbit/telem/releases' }
    ],
    
    sidebar: [
      {
        text: 'Getting Started',
        link: '/getting-started'
      },
      {
        text: 'API',
        collapsed: true,
        items: [
          { text: 'Metric', link: '/reference/Metric' },
          { text: 'MetricCollection', link: '/reference/MetricCollection' },
          { text: 'InputAdapter', link: '/reference/InputAdapter' },
          { text: 'OutputAdapter', link: '/reference/OutputAdapter' },
          { text: 'Backplane', link: '/reference/Backplane' },
          { text: 'Middleware', link: '/reference/Middleware' },
        ]
      },
      {
        text: 'Input',
        collapsed: false,
        items: [
          { text: 'Hello World', link: '/reference/input/HelloWorld' },
          { text: 'Item Storage', link: '/reference/input/ItemStorage' },
          { text: 'Fluid Storage', link: '/reference/input/FluidStorage' },
          { text: 'Secure Modem', link: '/reference/input/SecureModem' },
          { text: 'Custom', link: '/reference/input/Custom' },
          {
            text: 'Advanced Peripherals',
            collapsed: true,
            items: [
              { text: 'Energy Detector', link: '/reference/input/advanced-peripherals/EnergyDetector' },
            ]
          },
          {
            text: 'Applied Energistics',
            collapsed: true,
            items: [
              { text: 'ME Storage', link: '/reference/input/applied-energistics/MEStorage' },
            ]
          },
          {
            text: 'Mekanism [🚧 WIP 🚧]',
            collapsed: true,
            items: [
              { text: 'Antiprotonic Nucleosynthesizer', link: '/reference/input/mekanism/AntiprotonicNucleosynthesizer' },
              { text: 'Bin', link: '/reference/input/mekanism/Bin' },
              { text: 'Bio Generator', link: '/reference/input/mekanism/BioGenerator' },
              { text: 'Chemical Crystallizer', link: '/reference/input/mekanism/ChemicalCrystallizer' },
              { text: 'Chemical Dissolution Chamber', link: '/reference/input/mekanism/ChemicalDissolutionChamber' },
              { text: 'Chemical Infuser', link: '/reference/input/mekanism/ChemicalInfuser' },
              { text: 'Chemical Injection Chamber', link: '/reference/input/mekanism/ChemicalInjectionChamber' },
              { text: 'Chemical Oxidizer', link: '/reference/input/mekanism/ChemicalOxidizer' },
              { text: 'Chemical Tank', link: '/reference/input/mekanism/ChemicalTank' },
              { text: 'Chemical Washer', link: '/reference/input/mekanism/ChemicalWasher' },
              { text: 'Combiner', link: '/reference/input/mekanism/Combiner' },
              // { text: 'Combining Factory', link: '/reference/input/mekanism/CombiningFactory' },
              // { text: 'Compressing Factory', link: '/reference/input/mekanism/CompressingFactory' },
              { text: 'Crusher', link: '/reference/input/mekanism/Crusher' },
              // { text: 'Crushing Factory', link: '/reference/input/mekanism/CrushingFactory' },
              { text: 'Digital Miner', link: '/reference/input/mekanism/DigitalMiner' },
              { text: 'Dynamic Tank', link: '/reference/input/mekanism/DynamicTank' },
              { text: 'Electric Pump', link: '/reference/input/mekanism/ElectricPump' },
              { text: 'Electrolytic Separator', link: '/reference/input/mekanism/ElectrolyticSeparator' },
              { text: 'Energized Smelter', link: '/reference/input/mekanism/EnergizedSmelter' },
              { text: 'Energy Cube', link: '/reference/input/mekanism/EnergyCube' },
              // { text: 'Enriching Factory', link: '/reference/input/mekanism/EnrichingFactory' },
              { text: 'Enrichment Chamber', link: '/reference/input/mekanism/EnrichmentChamber' },
              { text: 'Fission Reactor', link: '/reference/input/mekanism/FissionReactor' },
              { text: 'Fluid Tank', link: '/reference/input/mekanism/FluidTank' },
              { text: 'Fluidic Plenisher', link: '/reference/input/mekanism/FluidicPlenisher' },
              { text: 'Formulaic Assemblicator', link: '/reference/input/mekanism/FormulaicAssemblicator' },
              { text: 'Fuelwood Heater', link: '/reference/input/mekanism/FuelwoodHeater' },
              { text: 'Fusion Reactor', link: '/reference/input/mekanism/FusionReactor' },
              { text: 'Gas Generator', link: '/reference/input/mekanism/GasGenerator' },
              { text: 'Heat Generator', link: '/reference/input/mekanism/HeatGenerator' },
              { text: 'Induction Matrix', link: '/reference/input/mekanism/InductionMatrix' },
              { text: 'Industrial Turbine', link: '/reference/input/mekanism/IndustrialTurbine' },
              // { text: 'Infusing Factory', link: '/reference/input/mekanism/InfusingFactory' },
              // { text: 'Injecting Factory', link: '/reference/input/mekanism/InjectingFactory' },
              { text: 'Isotopic Centrifuge', link: '/reference/input/mekanism/IsotopicCentrifuge' },
              { text: 'Laser', link: '/reference/input/mekanism/Laser' },
              { text: 'Laser Amplifier', link: '/reference/input/mekanism/LaserAmplifier' },
              { text: 'Laser Tractor Beam', link: '/reference/input/mekanism/LaserTractorBeam' },
              // { text: 'Logistical Sorter', link: '/reference/input/mekanism/LogisticalSorter' },
              // { text: 'Mechanical Pipe', link: '/reference/input/mekanism/MechanicalPipe' },
              // { text: 'Metallurgic Infuser', link: '/reference/input/mekanism/MetallurgicInfuser' },
              // { text: 'Nutritional Liquifier', link: '/reference/input/mekanism/NutritionalLiquifier' },
              // { text: 'Oredictionificator', link: '/reference/input/mekanism/Oredictionificator' },
              // { text: 'Osmium Compressor', link: '/reference/input/mekanism/OsmiumCompressor' },
              // { text: 'Painting Machine', link: '/reference/input/mekanism/PaintingMachine' },
              // { text: 'Pigment Extractor', link: '/reference/input/mekanism/PigmentExtractor' },
              // { text: 'Pigment Mixer', link: '/reference/input/mekanism/PigmentMixer' },
              // { text: 'Precision Sawmill', link: '/reference/input/mekanism/PrecisionSawmill' },
              // { text: 'Pressurized Reaction Chamber', link: '/reference/input/mekanism/PressurizedReactionChamber' },
              // { text: 'Pressurized Tube', link: '/reference/input/mekanism/PressurizedTube' },
              // { text: 'Purification Chamber', link: '/reference/input/mekanism/PurificationChamber' },
              // { text: 'Purifying Factory', link: '/reference/input/mekanism/PurifyingFactory' },
              // { text: 'QIO Drive Array', link: '/reference/input/mekanism/QIODriveArray' },
              // { text: 'Quantum Entangloporter', link: '/reference/input/mekanism/QuantumEntangloporter' },
              // { text: 'Radioactive Waste Barrel', link: '/reference/input/mekanism/RadioactiveWasteBarrel' },
              // { text: 'Resistive Heater', link: '/reference/input/mekanism/ResistiveHeater' },
              // { text: 'Rotary Condensentrator', link: '/reference/input/mekanism/RotaryCondensentrator' },
              // { text: 'Sawing Factory', link: '/reference/input/mekanism/SawingFactory' },
              // { text: 'Seismic Vibrator', link: '/reference/input/mekanism/SeismicVibrator' },
              // { text: 'Smelting Factory', link: '/reference/input/mekanism/SmeltingFactory' },
              // { text: 'Solar Generator', link: '/reference/input/mekanism/SolarGenerator' },
              // { text: 'Solar Neutron Activator', link: '/reference/input/mekanism/SolarNeutronActivator' },
              // { text: 'Supercritical Phase Shifter', link: '/reference/input/mekanism/SupercriticalPhaseShifter' },
              // { text: 'Teleporter', link: '/reference/input/mekanism/Teleporter' },
              // { text: 'Thermal Evaporation Plant', link: '/reference/input/mekanism/ThermalEvaporationPlant' },
              { text: 'Thermoelectric Boiler', link: '/reference/input/mekanism/ThermoelectricBoiler' },
              // { text: 'Universal Cable', link: '/reference/input/mekanism/UniversalCable' },
              // { text: 'Wind Generator', link: '/reference/input/mekanism/WindGenerator' },
            ]
          },
          {
            text: 'Refined Storage',
            collapsed: true,
            items: [
              { text: 'Refined Storage', link: '/reference/input/refined-storage/RefinedStorage' },
            ]
          },
        ]
      },
      {
        text: 'Output',
        collapsed: false,
        items: [
          { text: 'Hello World', link: '/reference/output/HelloWorld' },
          { text: 'Line Chart', link: '/reference/output/ChartLine' },
          { text: 'Area Chart', link: '/reference/output/ChartArea' },
          { text: 'Secure Modem', link: '/reference/output/SecureModem' },
          { text: 'Custom', link: '/reference/output/Custom' },
          { text: 'Grafana', link: '/reference/output/Grafana' },
          {
            text: 'Basalt',
            collapsed: true,
            items: [
              { text: 'Label', link: '/reference/output/basalt/Label' },
              { text: 'Graph', link: '/reference/output/basalt/Graph' },
            ]
          }
        ]
      },
      {
        text: 'Middleware',
        collapsed: false,
        items: [
          { text: 'Sort', link: '/reference/middleware/Sort' },
          { text: 'Calculate Average', link: '/reference/middleware/CalcAverage' },
          { text: 'Calculate Delta', link: '/reference/middleware/CalcDelta' },
          { text: 'Custom', link: '/reference/middleware/Custom' },
        ]
      }
    ],
    
    socialLinks: [
      { icon: 'github', link: 'https://github.com/cyberbit/telem' }
    ],
    
    externalLinkIcon: true,
  }
})
