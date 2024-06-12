---
outline: deep
---

# Custom Middleware <RepoLink path="lib/middleware/CustomMiddleware.lua" />

```lua
telem.middleware.custom (handler: fun(collection: MetricCollection): MetricCollection)
```

This middleware wraps a user-provided function for custom middleware implementations. Need to calculate the ratio between two metrics? Count the total number of items from an adapter? Measure a metric relative to an in-game day? Anything is possible!

<PropertiesTable
  :properties="[
    {
      name: 'handler',
      type: 'fun(collection: MetricCollection): MetricCollection',
      default: 'nil',
      description: 'Function executed when processing this middleware. The returned collection can be a new collection or a reference to the input collection.'
    }
  ]"
/>

## Usage

```lua{25-41}
local telem = require 'telem'
local mw = telem.middleware

local fluent = require('telem.vendor').fluent

local backplane = telem.backplane()
  :addInput('elements', telem.input.custom(function ()
    return {
      fire = 111,
      water = 222,
      earth = 333,
      air = 444,
    }
  end))

  :addInput('rare_elements', telem.input.custom(function ()
    return {
      gold = 777,
      silver = 888,
      platinum = 999,
    }
  end))

  -- calculate the sum of all metrics from the rare_elements adapter
  :middleware(mw.custom(function (collection)
    local sum = 0
    
    for _, metric in ipairs(collection) do
      if metric.adapter == 'rare_elements' then
        sum = sum + metric.value
      end
    end

    collection:insert(telem.metric{
      name = 'rare_elements_total',
      value = sum,
      source = 'middleware'
    })

    return collection
  end))
  :cycleEvery(1)()
```

This will result in the following collection:

<MetricTable
  show-heritage
  :metrics="[
    {
      name: 'fire',
      value: 111,
      adapter: 'elements'
    },
    {
      name: 'water',
      value: 222,
      adapter: 'elements'
    },
    {
      name: 'earth',
      value: 333,
      adapter: 'elements'
    },
    {
      name: 'air',
      value: 444,
      adapter: 'elements'
    },
    {
      name: 'gold',
      value: 777,
      adapter: 'rare_elements'
    },
    {
      name: 'silver',
      value: 888,
      adapter: 'rare_elements'
    },
    {
      name: 'platinum',
      value: 999,
      adapter: 'rare_elements'
    },
    {
      name: 'rare_elements_total',
      value: 2664,
      source: 'middleware'
    }
  ]"
/>