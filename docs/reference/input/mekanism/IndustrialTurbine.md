---
telem:
  adapter:
    id: 'industrialTurbine'
    name: 'Industrial Turbine'
    categories: '{ "basic", "advanced", "energy", "steam", "formation" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Industrial Turbine Input <RepoLink path="lib/input/mekanism/IndustrialTurbineInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

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