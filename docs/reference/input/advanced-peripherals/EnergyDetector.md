# Advanced Peripherals Energy Detector <RepoLink path="lib/input/advancedPeripherals/EnergyDetectorInputAdapter.lua" />

```lua
telem.input.advancedPeripherals.energyDetector (
  peripheralID: string,
  categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Advanced Peripherals**.
:::

This adapter produces metrics for the transfer rate and limit of an attached Energy Detector. By default, the metrics are limited to an opinionated basic list, but this can be expanded with the `categories` parameter at initialization.

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Energy Detector'
    },
    {
      name: 'categories',
      type: 'string[] | &quot;*&quot;',
      default: '{ &quot;basic&quot; }'
    }
  ]"
>
<template v-slot:categories>

List of metric categories to query. The value `"*"` can be used to include all categories, which are listed below.

```lua
{ "basic" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_energy', telem.input.advancedPeripherals.energyDetector('right'))
  :cycleEvery(1)()
```

Given an Energy Detector peripheral on the `right` side of the computer, this appends the following metrics to the backplane:

<MetricTable
  :metrics="[
    { name: 'apenergy:transfer_rate',       value: '0 - inf', unit: 'FE/t' },
    { name: 'apenergy:transfer_rate_limit', value: '0 - inf', unit: 'FE/t' },
  ]"
/>