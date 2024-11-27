---
telem:
  adapter:
    id: 'laserAmplifier'
    name: 'Laser Amplifier'
    categories: '{ "basic", "advanced", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Laser Amplifier Input <RepoLink path="lib/input/mekanism/LaserAmplifierInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="meklaseramp:"
  :metrics="[
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

```lua
REDSTONE_OUTPUT_MODES = { ENERGY_CONTENTS = 1, ENTITY_DETECTION = 2, OFF = 3 }
```

<MetricTable
  prefix="meklaseramp:"
  :metrics="[
    { name: 'delay',                value: '0 - inf',                     unit: 't'   },
    { name: 'min_threshold',        value: '0.0 - inf',                   unit: 'FE'  },
    { name: 'max_threshold',        value: '0.0 - inf',                   unit: 'FE'  },
    { name: 'redstone_output_mode', value: 'REDSTONE_OUTPUT_MODES value'              },
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="meklaseramp:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>