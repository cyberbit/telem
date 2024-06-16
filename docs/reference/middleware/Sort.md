---
outline: deep
---

# Sort Middleware <RepoLink path="lib/middleware/SortMiddleware.lua" />

```lua
telem.middleware.sort ()
```

Sorts the metrics in a collection by name.

## Usage

```lua{13}
local telem = require 'telem'
local mw = telem.middleware

local backplane = telem.backplane()
  :addInput('elements', telem.input.custom(function ()
    return {
      fire = 111,
      water = 222,
      earth = 333,
      air = 444,
    }
  end))
  :middleware(mw.sort())
  :cycleEvery(1)()
```

This will modify the collection to be sorted alphabetically by name:

<MetricTable
  :metrics="[
    {
      name: 'air',
      value: 444
    },
    {
      name: 'earth',
      value: 333
    },
    {
      name: 'fire',
      value: 111
    },
    {
      name: 'water',
      value: 222
    }
  ]"
/>