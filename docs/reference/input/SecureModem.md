---
outline: deep
---

# Secure Modem Input <RepoLink path="lib/input/SecureModemInputAdapter.lua" />

```lua
telem.input.secureModem (peripheralID: string, address: string)
```

This adapter requests metrics from a specified in-game network address running a [SecureModemOutputAdapter](/reference/output/SecureModem). Connections between computers are established over wired or wireless modems, through encrypted tunnels using the ECNet2 protocol. The target address must be on the same network as this input adapter.

## Usage

::: code-group

```lua{11} [Computer 1: Transmitter]
local telem = require 'telem'

-- contents of /.ecnet2/address.txt: "abc123="

local backplane = telem.backplane()
  :addInput('custom_in', telem.input.custom(function ()
    return
      telem.metric{ name = 'custom_short_1', value = 929, unit = 'bars', source = 'custom_source_1' },
      telem.metric{ name = 'custom_long_2', value = 424.2, source = 'custom_source_2' }
  end))
  :addOutput('secure_out', telem.output.secureModem('right'))

parallel.waitForAny(backplane:cycleEvery(1))
```

```lua{4} [Computer 2: Receiver]
local telem = require 'telem'

local backplane = telem.backplane()
	:addInput('my_securemodem', telem.input.secureModem('right', 'abc123='))

parallel.waitForAny(backplane:cycleEvery(1))
```

:::

Given a modem on the `right` side of both computers, this appends the following metrics to the receiver's backplane:

<MetricTable
  show-heritage
  :metrics="[
    {
      name: 'custom_short_1',
      value: 929,
      unit: 'bars',
      adapter: 'my_securemodem:custom_in',
      source: 'custom_source_1'
    },
    {
      name: 'custom_long_2',
      value: 424.2,
      adapter: 'my_securemodem:custom_in',
      source: 'custom_source_2'
    }
  ]"
/>