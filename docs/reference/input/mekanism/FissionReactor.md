<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Fission Reactor Input <RepoLink path="lib/input/mekanism/FissionReactorInputAdapter.lua" />

```lua
telem.input.mekanism.fissionReactor (
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
      description: 'Peripheral ID of the Fission Reactor Logic Adapter'
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
{ "basic", "advanced", "fuel", "coolant", "waste", "formation" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
	:addInput('my_fission', telem.input.mekanism.fissionReactor('right', '*'))
	:cycleEvery(5)()
```

Given a Fission Reactor Logic Adapter peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
	prefix="mekfission:"
	:metrics="[
		{ name: 'status', 													value: '0 or 1' 									},
		{ name: 'burn_rate', 												value: '0.0 - inf', unit: 'B/t' 	},
		{ name: 'temperature', 											value: '0.0 - inf', unit: 'K' 		},
		{ name: 'damage_percent', 									value: '0.0 - 1.0*' 							},
		{ name: 'fuel_filled_percentage', 					value: '0.0 - 1.0' 								},
		{ name: 'coolant_filled_percentage', 				value: '0.0 - 1.0' 								},
		{ name: 'heated_coolant_filled_percentage', value: '0.0 - 1.0' 								},
		{ name: 'waste_filled_percentage',					value: '0.0 - 1.0' 								}
	]"
/>

**Damage percent can exceed 100%.*

### Advanced

<MetricTable
	prefix="mekfission:"
	:metrics="[
		{ name: 'actual_burn_rate', 	value: '0.0 - inf', unit: 'B/t' },
		{ name: 'environmental_loss', value: '0.0 - 1.0' 							},
		{ name: 'heating_rate', 			value: '0.0 - inf', unit: 'B/t' }
	]"
/>

### Coolant

<MetricTable
	prefix="mekfission:"
	:metrics="[
		{ name: 'coolant', 									value: '0.0 - inf', unit: 'B' },
		{ name: 'coolant_capacity', 				value: '0 - inf', 	unit: 'B' },
		{ name: 'coolant_needed', 					value: '0.0 - inf', unit: 'B' },
		{ name: 'heated_coolant', 					value: '0.0 - inf', unit: 'B' },
		{ name: 'heated_coolant_capacity', 	value: '0 - inf', 	unit: 'B' },
		{ name: 'heated_coolant_needed', 		value: '0.0 - inf', unit: 'B' }
	]"
/>

### Fuel

<MetricTable
	prefix="mekfission:"
	:metrics="[
		{ name: 'fuel', 					value: '0.0 - inf', unit: 'B' },
		{ name: 'fuel_capacity', 	value: '0 - inf', 	unit: 'B' },
		{ name: 'fuel_needed', 	value: '0.0 - inf', 	unit: 'B' }
	]"
/>

### Waste

<MetricTable
	prefix="mekfission:"
	:metrics="[
		{ name: 'waste', 					value: '0.0 - inf', unit: 'B' },
		{ name: 'waste_capacity', value: '0 - inf', 	unit: 'B' },
		{ name: 'waste_needed', 	value: '0.0 - inf', unit: 'B' }
	]"
/>

### Formation

<MetricTable
	prefix="mekfission:"
	:metrics="[
		...metrics.multiblock.formation,
		{ name: 'force_disabled', 		value: '0 or 1' 							},
		{ name: 'fuel_assemblies', 		value: '0 - inf' 							},
		{ name: 'fuel_surface_area', 	value: '0 - inf', unit: 'm²' 	},
		{ name: 'heat_capacity', 			value: '0 - inf', unit: 'J/K' },
		{ name: 'boil_efficiency', 		value: '0.0 - 1.0' 						}
	]"
/>