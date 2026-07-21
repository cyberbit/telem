---
outline: deep
---

# Hello World Input <Badge type="danger" text="deprecated" /> <RepoLink path="lib/input/HelloWorldInputAdapter.lua" />

```lua
telem.input.helloWorld (checkval: number)
```

::: danger Deprecated
This adapter is deprecated and will be removed in a future release. Use [Custom Input](/reference/input/Custom) instead.
:::

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