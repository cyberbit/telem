---
telem:
  adapter:
    id: 'chemicalTank'
    name: 'Chemical Tank'
    categories: '{ "basic", "advanced", "storage" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Chemical Tank Input <RepoLink path="lib/input/mekanism/ChemicalTankInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekchemtank:"
  :metrics="[
    { name: 'fill_item_count',    value: '0 - inf',   unit: 'item'  },
    { name: 'filled_percentage',  value: '0.0 - 1.0'                },
    { name: 'drain_item_count',   value: '0 - inf',   unit: 'item'  }
  ]"
/>

### Advanced

```lua
DUMPING_MODES = { IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }
```

<MetricTable
  prefix="mekchemtank:"
  :metrics="[
    { name: 'dumping_mode', value: 'DUMPING_MODES value' }
  ]"
/>

### Storage

<MetricTable
  prefix="mekchemtank:"
  :metrics="[
    { name: 'stored',   value: '0.0 - inf', unit: 'B' },
    { name: 'capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

## Storage
If the tank contains a chemical, a storage metric is added for the chemical. Given a chemical tank with the following contents:

![Mekanism Basic Chemical Tank with contents](/assets/mekanism-chem-tank.webp)

The following metric would be added:

<MetricTable
  prefix="storage:"
  :metrics="[
    { name: 'mekanism:ethene', value: '47', unit: 'B' }
  ]"
/>