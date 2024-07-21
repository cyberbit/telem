<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Industrial Turbine Input <RepoLink path="lib/input/mekanism/IndustrialTurbineInputAdapter.lua" />

```lua
telem.input.mekanism.industrialTurbine (
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
      description: 'Peripheral ID of the Turbine Valve'
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
{ "basic", "advanced", "energy", "steam", "formation" }
```
</template>
</PropertiesTable>

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
	:addInput('my_turbine', telem.input.mekanism.industrialTurbine('right', '*'))
  :cycleEvery(5)()
```

Given a Turbine Valve peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="mekturbine:"
  :metrics="[
    ...metrics.genericMachine.basic,
    { name: 'energy_production_rate',   value: '0.0 - inf', unit: 'FE/t'  },
    { name: 'energy_max_production',    value: '0.0 - inf', unit: 'FE/t'  },
    { name: 'steam_filled_percentage',  value: '0.0 - 1.0'                }
  ]"
/>

### Advanced

```lua
DUMPING_MODES = { IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }
```

<MetricTable
  prefix="mekturbine:"
  :metrics="[
    ...metrics.genericMachine.advanced,
    { name: 'dumping_mode',   value: 'DUMPING_MODES value'              },
    { name: 'flow_rate',      value: '0.0 - inf',           unit: 'B/t' },
    { name: 'max_flow_rate',  value: '0.0 - inf',           unit: 'B/t' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekturbine:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>

### Steam

<MetricTable
  prefix="mekturbine:"
  :metrics="[
    { name: 'steam_input_rate', value: '0.0 - inf', unit: 'B/t' },
    { name: 'steam',            value: '0.0 - inf', unit: 'B'   },
    { name: 'steam_capacity',   value: '0.0 - inf', unit: 'B'   },
    { name: 'steam_needed',     value: '0.0 - inf', unit: 'B'   }
  ]"
/>

### Formation

<MetricTable
  prefix="mekturbine:"
  :metrics="[
    ...metrics.multiblock.formation,
    { name: 'blades',           value: '0 - inf'                },
    { name: 'coils',            value: '0 - inf'                },
    { name: 'condensers',       value: '0 - inf'                },
    { name: 'dispersers',       value: '0 - inf'                },
    { name: 'vents',            value: '0 - inf'                },
    { name: 'max_water_output', value: '0.0 - inf', unit: 'B/t' }
  ]"
/>