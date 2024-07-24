<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Oxidizer Input <RepoLink path="lib/input/mekanism/ChemicalOxidizerInputAdapter.lua" />

```lua
telem.input.mekanism.chemicalOxidizer (
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
      description: 'Peripheral ID of the Chemical Oxidizer'
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
{ "basic", "advanced", "output", "energy", "recipe" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_oxidizer', telem.input.mekanism.chemicalOxidizer('right', '*'))
  :cycleEvery(5)()
```

Given a Chemical Oxidizer peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    { name: 'input_count',              value: '0 - inf',   unit: 'item'  },
    { name: 'output_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'output_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',             value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Output

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekchemoxidizer:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>