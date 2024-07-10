# Mekanism Antiprotonic Nucleosynthesizer Input <RepoLink path="lib/input/mekanism/AntiprotonicNucleosynthesizerInputAdapter.lua" />

```lua
telem.input.mekanism.apns (
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
      description: 'Peripheral ID of the Antiprotonic Nucleosynthesizer'
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
  :addInput('my_apns', telem.input.mekanism.apns('right', '*'))
  :cycleEvery(5)()
```

Given an Antiprotonic Nucleosynthesizer peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  :metrics="[
    {
      name: 'mekapns:input_chemical_filled_percentage',
      value: '0.0 - 1.0'
    },
    {
      name: 'mekapns:input_item_count',
      value: '0 - inf',
      unit: 'item'
    },
    {
      name: 'mekapns:output_item_count',
      value: '0 - inf',
      unit: 'item'
    },
    {
      name: 'mekapns:energy_filled_percentage',
      value: '0.0 - 1.0'
    },
    {
      name: 'mekapns:energy_usage',
      value: '0.0 - inf',
      unit: 'FE/t'
    }
  ]"
/>

### Advanced

<MetricTable
  :metrics="[
    {
      name: 'mekapns:comparator_level',
      value: '0 - 15'
    }
  ]"
/>

### Input

<MetricTable
  :metrics="[
    {
      name: 'mekapns:input_chemical',
      value: '0.0 - inf',
      unit: 'B'
    },
    {
      name: 'mekapns:input_chemical_capacity',
      value: '0.0 - inf',
      unit: 'B'
    },
    {
      name: 'mekapns:input_chemical_needed',
      value: '0.0 - inf',
      unit: 'B'
    }
  ]"
/>

### Energy

<MetricTable
  :metrics="[
    {
      name: 'mekapns:energy',
      value: '0.0 - inf',
      unit: 'FE'
    },
    {
      name: 'mekapns:max_energy',
      value: '0.0 - inf',
      unit: 'FE'
    },
    {
      name: 'mekapns:energy_needed',
      value: '0.0 - inf',
      unit: 'FE'
    }
  ]"
/>

### Recipe

<MetricTable
  :metrics="[
    {
      name: 'mekapns:recipe_progress',
      value: '0 - inf',
      unit: 't'
    },
    {
      name: 'mekapns:ticks_required',
      value: '0 - inf',
      unit: 't'
    }
  ]"
/>