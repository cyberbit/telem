---
telem:
  adapter:
    id: 'quantumEntangloporter'
    name: 'Quantum Entangloporter'
    categories: '{ "basic", "advanced", "fluid", "gas", "infuse", "item", "pigment", "slurry", "energy" }'
---

# Mekanism Quantum Entangloporter Input <RepoLink path="lib/input/mekanism/QuantumEntangloporterInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'fluid_filled_percentage',    value: '0.0 - 1.0'            },
    { name: 'gas_filled_percentage',      value: '0.0 - 1.0'            },
    { name: 'infuse_filled_percentage',   value: '0.0 - 1.0'            },
    { name: 'pigment_filled_percentage',  value: '0.0 - 1.0'            },
    { name: 'slurry_filled_percentage',   value: '0.0 - 1.0'            },
    { name: 'energy_filled_percentage',   value: '0.0 - 1.0'            },
    { name: 'temperature',                value: '0.0 - inf', unit: 'K' }
  ]"
/>

### Advanced

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'transfer_loss',      value: '0.0 - inf' },
    { name: 'environmental_loss', value: '0.0 - inf' }
  ]"
/>

### Fluid

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'fluid',          value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'fluid_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Gas

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'gas',          value: '0.0 - inf', unit: 'B' },
    { name: 'gas_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'gas_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Infuse

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'infuse',           value: '0.0 - inf', unit: 'B' },
    { name: 'infuse_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'infuse_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Item

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'item_count', value: '0 - inf' }
  ]"
/>

### Pigment

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'pigment',          value: '0.0 - inf', unit: 'B' },
    { name: 'pigment_capacity', value: '0.0 - inf', unit: 'B' },
    { name: 'pigment_needed',   value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Slurry

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'slurry',           value: '0.0 - inf', unit: 'B' },
    { name: 'slurry_capacity',  value: '0.0 - inf', unit: 'B' },
    { name: 'slurry_needed',    value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Energy

<MetricTable
  prefix="mekentanglo:"
  :metrics="[
    { name: 'energy',         value: '0.0 - inf', unit: 'FE' },
    { name: 'max_energy',     value: '0.0 - inf', unit: 'FE' },
    { name: 'energy_needed',  value: '0.0 - inf', unit: 'FE' }
  ]"
/>