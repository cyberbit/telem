<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Crystallizer Input <RepoLink path="lib/input/mekanism/ChemicalCrystallizerInputAdapter.lua" />

```lua
telem.input.mekanism.chemicalCrystallizer (
  peripheralID: string,
  categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Mekanism**.
:::

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Chemical Crystallizer'
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
{ "basic", "advanced", "input", "output", "energy", "recipe" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_crystallizer', telem.input.mekanism.chemicalCrystallizer('right', '*'))
  :cycleEvery(5)()
```

Given a Chemical Crystallizer peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    { name: 'input_filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'input_item_count',         value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    { name: 'input',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    { name: 'output_count', value: '0 - inf', unit: 'item' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekcrystallizer:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>