<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Bio Generator Input <RepoLink path="lib/input/mekanism/BioGeneratorInputAdapter.lua" />

```lua
telem.input.mekanism.bioGenerator (
	peripheralID: string,
	categories?: string[] | '*'
)
```

::: warning Mod Dependencies
Requires **Mekanism** and **Mekanism Generators**.
:::

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Bio Generator'
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
{ "basic", "advanced", "fuel", "energy" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_biogen', telem.input.mekanism.bioGenerator('right', '*'))
  :cycleEvery(5)()
```

Given a Bio Generator peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    ...metrics.genericMachine.basic,
    ...metrics.generator.basic,
    { name: 'bio_fuel_filled_percentage', value: '0.0 - 1.0'  },
    { name: 'bio_fuel_item_count',        value: '0 - inf'    }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Fuel

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    { name: 'bio_fuel',           value: '0.0 - inf', unit: 'B' },
    { name: 'bio_fuel_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'bio_fuel_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekbiogen:"
  :metrics="[
    ...metrics.genericMachine.energy,
    ...metrics.generator.energy
  ]"
/>