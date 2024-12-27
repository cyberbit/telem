---
telem:
  adapter:
    id: 'oredictionificator'
    name: 'Oredictionificator'
    categories: '{ "basic" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Oredictionificator Input <RepoLink path="lib/input/mekanism/OredictionificatorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekoredict:"
  :metrics="[
    { name: 'input_count',  value: '0 - inf', unit: 'item'  },
    { name: 'output_count', value: '0 - inf', unit: 'item'  }
  ]"
/>