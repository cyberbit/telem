<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Injection Chamber Input <RepoLink path="lib/input/mekanism/ChemicalInjectionChamberInputAdapter.lua" />

```lua
telem.input.mekanism.injectionChamber (
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
      description: 'Peripheral ID of the Chemical Injection Chamber'
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
{ "basic", "advanced", "input", "energy", "recipe" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_injection', telem.input.mekanism.injectionChamber('right', '*'))
  :cycleEvery(5)()
```

Given a Chemical Injection Chamber peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekinject:"
  :metrics="[
    { name: 'chemical_filled_percentage', value: '0.0 - 1.0'                },
    { name: 'input_count',                value: '0 - inf',   unit: 'item'  },
    { name: 'chemical_item_count',        value: '0 - inf',   unit: 'item'  },
    { name: 'output_count',               value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',               value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekinject:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekinject:"
  :metrics="[
    { name: 'chemical',           value: '0.0 - inf', unit: 'B' },
    { name: 'chemical_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'chemical_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekinject:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Recipe

<MetricTable
  prefix="mekinject:"
  :metrics="[
    ...metrics.recipeProgress.recipe
  ]"
/>