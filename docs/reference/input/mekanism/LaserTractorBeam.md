---
telem:
  adapter:
    id: 'laserTractorBeam'
    name: 'Laser Tractor Beam'
    categories: '{ "basic", "advanced", "energy" }'
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Laser Tractor Beam Input <RepoLink path="lib/input/mekanism/LaserTractorBeamInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mektractorbeam:"
  :metrics="[
    { name: 'slot_usage', value: '0 - inf' },
    { name: 'slot_count', value: '0 - inf' },
    ...metrics.genericMachine.basic
  ]"
/>

### Advanced

<MetricTable
  prefix="mektractorbeam:"
  :metrics="[
    ...metrics.genericMachine.advanced
  ]"
/>

### Energy

<MetricTable
  prefix="mektractorbeam:"
  :metrics="[
    ...metrics.genericMachine.energy
  ]"
/>