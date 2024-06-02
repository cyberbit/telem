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

This adapter produces a metric for most of the available information from a Fission Reactor Logic Adapter. By default, the metrics are limited to an opinionated basic list, but this can be expanded with the `categories` parameter at initialization. The default `basic` category provides all the information needed to monitor any implemented safety measures for fission reactors.

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
	:metrics="[
		{
			name: 'mekfission:status',
			value: '0 or 1',
		},
		{
			name: 'mekfission:burn_rate',
			value: '0.0 - inf',
			unit: 'B/t',
		},
		{
			name: 'mekfission:temperature',
			value: '0.0 - inf',
			unit: 'K'
		},
		{
			name: 'mekfission:damage_percent',
			value: '0.0 - 1.0*'
		},
		{
			name: 'mekfission:fuel_filled_percentage',
			value: '0.0 - 1.0'
		},
		{
			name: 'mekfission:coolant_filled_percentage',
			value: '0.0 - 1.0'
		},
		{
			name: 'mekfission:heated_coolant_filled_percentage',
			value: '0.0 - 1.0'
		},
		{
			name: 'mekfission:waste_filled_percentage',
			value: '0.0 - 1.0'
		}
	]"
/>

**Damage percent can exceed 100%.*

### Advanced

<MetricTable
	:metrics="[
		{
			name: 'mekfission:actual_burn_rate',
			value: '0.0 - inf',
			unit: 'B/t'
		},
		{
			name: 'mekfission:environmental_loss',
			value: '0.0 - 1.0'
		},
		{
			name: 'mekfission:heating_rate',
			value: '0.0 - inf',
			unit: 'B/t'
		}
	]"
/>

### Coolant

<MetricTable
	:metrics="[
		{
			name: 'mekfission:coolant',
			value: '0.0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:coolant_capacity',
			value: '0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:coolant_needed',
			value: '0.0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:heated_coolant',
			value: '0.0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:heated_coolant_capacity',
			value: '0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:heated_coolant_needed',
			value: '0.0 - inf',
			unit: 'B'
		}
	]"
/>

### Fuel

<MetricTable
	:metrics="[
		{
			name: 'mekfission:fuel',
			value: '0.0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:fuel_capacity',
			value: '0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:fuel_needed',
			value: '0.0 - inf',
			unit: 'B'
		}
	]"
/>

### Waste

<MetricTable
	:metrics="[
		{
			name: 'mekfission:waste',
			value: '0.0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:waste_capacity',
			value: '0 - inf',
			unit: 'B'
		},
		{
			name: 'mekfission:waste_needed',
			value: '0.0 - inf',
			unit: 'B'
		}
	]"
/>

### Formation

<MetricTable
	:metrics="[
		{
			name: 'mekfission:formed',
			value: '0 or 1'
		},
		{
			name: 'mekfission:force_disabled',
			value: '0 or 1'
		},
		{
			name: 'mekfission:height',
			value: '0 - inf',
			unit: 'm'
		},
		{
			name: 'mekfission:length',
			value: '0 - inf',
			unit: 'm'
		},
		{
			name: 'mekfission:width',
			value: '0 - inf',
			unit: 'm'
		},
		{
			name: 'mekfission:fuel_assemblies',
			value: '0 - inf'
		},
		{
			name: 'mekfission:fuel_surface_area',
			value: '0 - inf',
			unit: 'm²'
		},
		{
			name: 'mekfission:heat_capacity',
			value: '0 - inf',
			unit: 'J/K'
		},
		{
			name: 'mekfission:boil_efficiency',
			value: '0.0 - 1.0'
		}
	]"
/>