---
outline: deep
---

# Hello World Output <RepoLink path="lib/output/HelloWorldOutputAdapter.lua" />

```lua
telem.output.helloWorld ()
```

Writes all metrics out in a reduced format to the terminal, primarily serving as a reference implementation for [OutputAdapter](/reference/OutputAdapter) and a simple metric logger.

## Usage

```lua{5}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_hello', telem.input.helloWorld(123))
  :addOutput('my_hello', telem.output.helloWorld())
  :cycleEvery(1)()
```

## Behavior

The example usage will produce the following output every cycle:

```
Hello, hello_world = 123!
```