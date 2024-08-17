---
telem:
  adapter:
    id: 'digitalMiner'
    name: 'Digital Miner'
    categories: '{ "basic", "advanced", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Digital Miner Input <RepoLink path="lib/input/mekanism/DigitalMinerInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

```lua
STATES = { FINISHED = 1, IDLE = 2, PAUSED = 3, SEARCHING = 4 }
```

<MetricTable
  prefix="mekminer:"
  :metrics="[
    { name: 'running',      value: '0 or 1'                   },
    { name: 'slot_count',   value: '0 - inf'                  },
    { name: 'state',        value: 'STATES value'             },
    { name: 'to_mine',      value: '0 - inf'                  },
    { name: 'energy_usage', value: '0.0 - inf', unit: 'FE/t'  },
    { name: 'slot_usage',   value: '0 - inf'                  },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekminer:"
  :metrics="[
    { name: 'auto_eject',                         value: '0 or 1'             },
    { name: 'auto_pull',                          value: '0 or 1'             },
    { name: 'inverse_mode',                       value: '0 or 1'             },
    { name: 'inverse_mode_requires_replacement',  value: '0 or 1'             },
    { name: 'max_radius',                         value: '1 - inf', unit: 'm' },
    { name: 'max_y',                              value: '-inf - inf'         },
    { name: 'min_y',                              value: '-inf - inf'         },
    { name: 'radius',                             value: '0 - inf', unit: 'm' },
    { name: 'silk_touch',                         value: '0 or 1'             },
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekminer:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>