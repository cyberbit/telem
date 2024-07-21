<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Induction Matrix Input <RepoLink path="lib/input/mekanism/InductionMatrixInputAdapter.lua" />

```lua
telem.input.mekanism.inductionMatrix (
  peripheralID: string,
  categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Mekanism** and **Mekanism Generators**.
:::

This adapter produces a metric for most of the available information from an Induction Matrix Port. By default, the metrics are limited to an opinionated basic list, but this can be expanded with the `categories` parameter at initialization. The default `basic` category provides all the information needed to safely monitor the induction matrix.

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Induction Matrix Port'
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
{ "basic", "advanced", "energy", "formation" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_induction', telem.input.mekanism.inductionMatrix('right', '*'))
  :cycleEvery(5)()
```

Given an Induction Matrix Port peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.genericMachine.basic,
    { name: 'energy_input',             value: '0.0 - inf', unit: 'FE/t' },
    { name: 'energy_output',            value: '0.0 - inf', unit: 'FE/t' },
    { name: 'energy_transfer_cap',      value: '0 - inf',   unit: 'FE/t' }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.genericMachine.advanced,
  ]"
/>

### Energy

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.genericMachine.energy,
  ]"
/>

### Formation

<MetricTable
  prefix="mekinduction:"
  :metrics="[
    ...metrics.multiblock.formation,
    { name: 'installed_cells',     value: '0 - inf' },
    { name: 'installed_providers', value: '0 - inf' }
  ]"
/>