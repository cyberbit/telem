---
telem:
  adapter:
    id: 'fissionReactor'
    name: 'Fission Reactor'
    categories: '{ "basic", "advanced", "fuel", "coolant", "waste", "formation" }'
    requiresMekGen: true
---

<script setup>
  import { data as metrics } from './common/metrics.data.ts'
</script>

# Mekanism Fission Reactor Input <RepoLink path="lib/input/mekanism/FissionReactorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

<MetricTable
  prefix="mekfission:"
  :metrics="[
    { name: 'status', 													value: '0 or 1' 									},
    { name: 'burn_rate', 												value: '0.0 - inf', unit: 'B/t' 	},
    { name: 'temperature', 											value: '0.0 - inf', unit: 'K' 		},
    { name: 'damage_percent', 									value: '0.0 - 1.0*' 							},
    { name: 'fuel_filled_percentage', 					value: '0.0 - 1.0' 								},
    { name: 'coolant_filled_percentage', 				value: '0.0 - 1.0' 								},
    { name: 'heated_coolant_filled_percentage', value: '0.0 - 1.0' 								},
    { name: 'waste_filled_percentage',					value: '0.0 - 1.0' 								}
  ]"
/>

**Damage percent can exceed 100%.*

### Advanced

<MetricTable
  prefix="mekfission:"
  :metrics="[
    { name: 'actual_burn_rate', 	value: '0.0 - inf', unit: 'B/t' },
    { name: 'environmental_loss', value: '0.0 - 1.0' 							},
    { name: 'heating_rate', 			value: '0.0 - inf', unit: 'B/t' }
  ]"
/>

### Coolant

<MetricTable
  prefix="mekfission:"
  :metrics="[
    { name: 'coolant', 									value: '0.0 - inf', unit: 'B' },
    { name: 'coolant_capacity', 				value: '0 - inf', 	unit: 'B' },
    { name: 'coolant_needed', 					value: '0.0 - inf', unit: 'B' },
    { name: 'heated_coolant', 					value: '0.0 - inf', unit: 'B' },
    { name: 'heated_coolant_capacity', 	value: '0 - inf', 	unit: 'B' },
    { name: 'heated_coolant_needed', 		value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Fuel

<MetricTable
  prefix="mekfission:"
  :metrics="[
    { name: 'fuel', 					value: '0.0 - inf', unit: 'B' },
    { name: 'fuel_capacity', 	value: '0 - inf', 	unit: 'B' },
    { name: 'fuel_needed', 	value: '0.0 - inf', 	unit: 'B' }
  ]"
/>

### Waste

<MetricTable
  prefix="mekfission:"
  :metrics="[
    { name: 'waste', 					value: '0.0 - inf', unit: 'B' },
    { name: 'waste_capacity', value: '0 - inf', 	unit: 'B' },
    { name: 'waste_needed', 	value: '0.0 - inf', unit: 'B' }
  ]"
/>

### Formation

<MetricTable
  prefix="mekfission:"
  :metrics="[
    ...metrics.multiblock.formation,
    { name: 'force_disabled', 		value: '0 or 1' 							},
    { name: 'fuel_assemblies', 		value: '0 - inf' 							},
    { name: 'fuel_surface_area', 	value: '0 - inf', unit: 'm²' 	},
    { name: 'heat_capacity', 			value: '0 - inf', unit: 'J/K' },
    { name: 'boil_efficiency', 		value: '0.0 - 1.0' 						}
  ]"
/>