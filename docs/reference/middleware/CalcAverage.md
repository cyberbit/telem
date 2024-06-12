---
outline: deep
---

# Calculate Average Middleware <RepoLink path="lib/middleware/CalcAverageMiddleware.lua" />

```lua
telem.middleware.calcAvg (windowSize?: integer)
```

Calculates the average of each metric in a collection, observed over a number of cycles. Each average is appended to the collection as a new metric, with an `_avg` suffix appended to the name, and the source set to `middleware`.

<PropertiesTable
  :properties="[
    {
      name: 'windowSize',
      type: 'integer',
      default: '50',
      description: 'Number of cycles to include when calculating the average.'
    }
  ]"
/>

## Methods

### `force`

```lua
CalcAverageMiddleware:force (): self
```

Force the middleware to process metrics from other middleware (`source = 'middleware'`), default is to ignore metrics from other middleware.

## Usage

```lua{8}
local telem = require 'telem'
local mw = telem.middleware

local backplane = telem.backplane()
  :addInput('random', telem.input.custom(function ()
    return { rand = math.random(1, 2) }
  end))
  :middleware(mw.calcAvg())
  :cycleEvery(0.1)()
```

This will result in the following collection:

<MetricTable
  show-heritage
  :metrics="[
    {
      name: 'rand',
      value: '1 or 2',
      adapter: 'random'
    },
    {
      name: 'rand_avg',
      value: '~ 1.5',
      source: 'middleware'
    }
  ]"
/>

Observing the value over time shows that the average converges to the expected value:

![Output of rand_avg over time](/assets/middleware-calc-avg.png)