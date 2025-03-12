---
telem:
  adapter:
    id: 'environmentDetector'
    name: 'Environment Detector'
    categories: '{ "basic" }'
---

# Advanced Peripherals Environment Detector Input <RepoLink path="lib/input/advancedPeripherals/EnvironmentDetectorInputAdapter.lua" />

<!--@include: ./common/preamble.md -->

### Basic

```lua
MOON_PHASES = {
  ['Full moon']     = 0,  ['Waning gibbous']  = 1,
  ['Third quarter'] = 2,  ['Waning crescent'] = 3,
  ['New moon']      = 4,  ['Waxing crescent'] = 5,
  ['First quarter'] = 6,  ['Waxing gibbous']  = 7
}
```

<MetricTable
  prefix="apenv:"
  :metrics="[
    { name: 'block_light_level',  value: '0 - 15',                          },
    { name: 'day_light_level',    value: '0 - 15',                          },
    { name: 'sky_light_level',    value: '0 - 15',                          },
    { name: 'moon_id',            value: 'MOON_PHASES value'                },
    { name: 'time',               value: '0 - inf'                          },
    { name: 'radiation',          value: '0.0 - inf',         unit: 'Sv/h'  },
    { name: 'can_sleep',          value: '0 or 1'                           },
    { name: 'raining',            value: '0 or 1'                           },
    { name: 'sunny',              value: '0 or 1'                           },
    { name: 'thundering',         value: '0 or 1'                           },
    { name: 'slime_chunk',        value: '0 or 1'                           }
  ]"
/>