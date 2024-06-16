---
outline: deep
---

# Hello World Input <RepoLink path="lib/input/HelloWorldInputAdapter.lua" />

```lua
telem.input.helloWorld (checkval: number)
```

This adapter produces a single metric with a specified static value, primarily serving as a reference implementation of [InputAdapter](/reference/InputAdapter).

## Usage

```lua{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_hello', telem.input.helloWorld(123))
  :cycleEvery(1)()
```

This appends the following metric to the backplane:

<MetricTable
  :metrics="[
    {
      name: 'hello_world',
      value: 123,
      adapter: 'my_hello'
    }
  ]"
/>