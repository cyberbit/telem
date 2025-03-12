---
telem:
  adapter:
    id: 'energyDetector'
    name: 'Energy Detector'
    categories: '{ "basic" }'
---

# Advanced Peripherals Energy Detector <RepoLink path="lib/input/advancedPeripherals/EnergyDetectorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="apenergy:"
  :metrics="[
    { name: 'transfer_rate',        value: '0 - inf', unit: 'FE/t' },
    { name: 'transfer_rate_limit',  value: '0 - inf', unit: 'FE/t' },
  ]"
/>