---
outline: deep
---

# Calculate Delta Middleware <RepoLink path="lib/middleware/CalcDeltaMiddleware.lua" />

```lua
telem.middleware.calcDelta (windowSize?: integer)
```

Measures the delta and rate of each metric in a collection, in both instant and ranged variants. Each measurement is appended to the collection as a new metric, with a suffix appended to the name, and the source set to `middleware`.

The instant delta is calculated as the difference between the current and previous values, and the instant rate is calculated as the delta divided by the observed time between cycles. The ranged delta and rate are similar, but the previous value is taken from `windowSize` cycles ago.

<PropertiesTable
  :properties="[
    {
      name: 'windowSize',
      type: 'integer',
      default: '50',
      description: 'Number of cycles to include when calculating the delta and rate.'
    }
  ]"
/>

## Methods

### `force`

```lua
CalcDeltaMiddleware:force (): self
```

Force the middleware to process metrics from other middleware (`source = 'middleware'`), default is to ignore metrics from other middleware.

### `interval`

```lua
CalcDeltaMiddleware:interval (interval: string): self
```

Set the interval used to calculate the rate. The default is `1s`, which will result in the rate being calculated in units per second.

The format is `(unitScale)(unit)`, where `unitScale` is an integer greater than 0, and `unit` is one of: `s` (second), `m` (minute), `h` (hour), `d` (day). Note that "day" is a 24-hour day, not an in-game day.

## Usage

```lua{12}
local telem = require 'telem'
local mw = telem.middleware

local state = 0

local backplane = telem.backplane()
  :addInput('increments', telem.input.custom(function ()
    state = state + 1

    return { inc = state }
  end))
  :middleware(mw.calcDelta():interval('1m'))
  :cycleEvery(0.1)()
```

This will result in the following collection:

<MetricTable
  show-heritage
  :metrics="[
    {
      name: 'inc',
      value: '0 - inf',
      adapter: 'increments'
    },
    {
      name: 'inc_idelta',
      value: '1',
      source: 'middleware'
    },
    {
      name: 'inc_delta',
      value: '~ 49',
      source: 'middleware'
    },
    {
      name: 'inc_irate',
      value: '~ 600',
      source: 'middleware'
    },
    {
      name: 'inc_rate',
      value: '~ 600',
      source: 'middleware'
    }
  ]"
/>

Observing the value over time looks something like this:

![Output of delta middleware over time](/assets/middleware-calc-delta.png)