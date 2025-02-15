---
telem:
  adapter:
    id: 'teleporter'
    name: 'Teleporter'
    categories: '{ "basic", "advanced", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Teleporter Input <RepoLink path="lib/input/mekanism/TeleporterInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

```lua
STATUSES = { ['ready'] = 1, ['no frequency'] = 2, ['no frame'] = 3, ['no link'] = 4 }
```

<MetricTable
  prefix="mekteleporter:"
  :metrics="[
    { name: 'status',                   value: 'STATUSES value' },
    { name: 'frequency_selected',       value: '0 or 1'         },
    { name: 'active_teleporters_count', value: '0 - inf'        },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mekteleporter:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mekteleporter:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>