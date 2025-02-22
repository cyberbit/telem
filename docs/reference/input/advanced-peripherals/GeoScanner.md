# Advanced Peripherals Geo Scanner Input <RepoLink path="lib/input/advancedPeripherals/GeoScannerInputAdapter.lua" />

```lua
telem.input.advancedPeripherals.geoScanner (
  peripheralID: string,
  categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Advanced Peripherals**.
:::

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Geo Scanner'
    },
    {
      name: 'categories',
      type: 'string[] | &quot;*&quot;',
      default: '{ &quot;basic&quot; }',
      description: 'N/A'
    }
  ]"
/>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_geoScanner', telem.input.advancedPeripherals.geoScanner('right', '*'))
  :cycleEvery(5)()
```

## Storage
If a Geo Scanner is in a chunk containing ore blocks, a storage metric is added for each ore block ID scanned.

Given a chunk with 1 layer of dirt, 2 layers of stone, and 1 layer of iron ore, the following metrics would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'minecraft:iron_ore', value: '256' }
  ]"
/>