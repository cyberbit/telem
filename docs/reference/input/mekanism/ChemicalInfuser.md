<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Infuser Input <RepoLink path="lib/input/mekanism/ChemicalInfuserInputAdapter.lua" />

```lua
telem.input.mekanism.chemicalInfuser (
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
      description: 'Peripheral ID of the Chemical Infuser'
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
{ "basic", "advanced", "input", "output", "energy" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_infuser', telem.input.mekanism.chemicalInfuser('right', '*'))
  :cycleEvery(5)()
```

Given a Chemical Infuser peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekcheminfuser:"
  :metrics="[
    { name: 'input_left_item_count',          value: '0 - inf',   unit: 'item'  },
    { name: 'input_left_filled_percentage',   value: '0.0 - 1.0', unit: 'B'     },
    { name: 'input_right_filled_percentage',  value: '0.0 - inf'                },
    { name: 'input_right_item_count',         value: '0 - inf',   unit: 'item'  },
    { name: 'output_filled_percentage',       value: '0.0 - inf'                },
    { name: 'output_item_count',              value: '0 - inf',   unit: 'item'  },
    { name: 'energy_usage',                   value: '0.0 - inf', unit: 'FE/t'  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekcheminfuser:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Input

<MetricTable
  prefix="mekcheminfuser:"
  :metrics="[
    { name: 'input_left',           value: '0.0 - inf', unit: 'B' },
    { name: 'input_left_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'input_left_needed',    value: '0.0 - inf', unit: 'B' },
    { name: 'input_right',          value: '0.0 - inf', unit: 'B' },
    { name: 'input_right_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'input_right_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Output

<MetricTable
  prefix="mekcheminfuser:"
  :metrics="[
    { name: 'output',           value: '0.0 - inf', unit: 'B' },
    { name: 'output_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'output_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekcheminfuser:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>
