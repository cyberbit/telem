---
outline: deep
---

# Refined Storage Input <RepoLink path="lib/input/RefinedStorageInputAdapter.lua" />

```lua
telem.input.refinedStorage (peripheralID: string)
```

::: warning Mod Dependencies
Requires **Refined Storage** and **Advanced Peripherals**.
:::

This adapter produces a metric for each item and fluid ID in a Refined Storage network, with the metric names being the IDs, and the value being the total amount of that item/fluid in storage. Peripheral must be an [Advanced Peripherals RS Bridge](https://docs.advanced-peripherals.de/peripherals/rs_bridge/).

Items that are craftable but not stored are not included in the metrics.

## Usage

```lua
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_refined', telem.input.refinedStorage('rsBridge_0'))
  :cycleEvery(1)()
```

Given an RS Bridge peripheral with the ID `rsBridge_0` attached to a Refined Storage network with the following items and fluids:

![Refined Storage Fluid Grid and Grid inventory](/assets/rs-inventory.webp)

This appends the following metrics to the backplane:

<MetricTable
  :metrics="[
    {
      name: 'storage:minecraft:lava',
      value: 23.810,
      unit: 'B',
      adapter: 'my_refined',
      source: 'rsBridge_0'
    },
    {
      name: 'storage:minecraft:oak_planks',
      value: 3,
      unit: 'item',
      adapter: 'my_refined',
      source: 'rsBridge_0'
    },
    {
      name: 'storage:minecraft:redstone',
      value: 459,
      unit: 'item',
      adapter: 'my_refined',
      source: 'rsBridge_0'
    }
  ]"
/>