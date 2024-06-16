---
outline: deep
---

# Secure Modem Output <RepoLink path="lib/output/SecureModemOutputAdapter.lua" />

```lua
telem.output.secureModem (peripheralID: string)
```

Responds to requests from [SecureModemInputAdapter](/reference/input/SecureModem) clients. Connections between computers are established over wired or wireless modems, through encrypted tunnels using the ECNet2 protocol. Clients must be on the same network as this output adapter.

## Usage

::: code-group

```lua{9} [Computer 1: Transmitter]
local telem = require 'telem'

-- contents of /.ecnet2/address.txt: "abc123="

local backplane = telem.backplane()
  :addInput('custom_short', telem.input.custom(function ()
    return { custom_short_1 = 929, custom_short_2 = 424.2 }
  end))
  :addOutput('secure_out', telem.output.secureModem('modemID'))

parallel.waitForAny(backplane:cycleEvery(1))
```

```lua{4} [Computer 2: Receiver]
local telem = require 'telem'

local backplane = telem.backplane()
	:addInput('my_securemodem', telem.input.secureModem('modemID', 'abc123='))

parallel.waitForAny(backplane:cycleEvery(1))
```

:::

## Behavior

This adapter does not participate in scheduled cycles like other output adapters. Instead, it utilizes [`setAsyncCycleHandler()`](/reference/OutputAdapter#setasynccyclehandler) to register a coroutine that listens for ECNet2 connections and responds to metric requests immediately.

The collection used for responses is pulled from the `collection` property of this adapter's associated [Backplane](/reference/Backplane), which will be updated with metrics produced during scheduled cycles.