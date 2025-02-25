# Advanced Peripherals Player Detector Input <RepoLink path="lib/input/advancedPeripherals/PlayerDetectorInputAdapter.lua" />

```lua
telem.input.advancedPeripherals.playerDetector (
  peripheralID: string,
  categories?: string[] | '*',
  playerName?: string
)
```

::: warning Mod Dependencies
Requires **Advanced Peripherals**.
:::

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the Player Detector'
    },
    {
      name: 'categories',
      type: 'string[] | &quot;*&quot;',
      default: '{ &quot;basic&quot; }'
    },
    {
      name: 'playerName',
      type: 'string',
      default: 'nil',
      description: 'Name of the player to query for additional metrics'
    }
  ]"
>
<template v-slot:categories>

List of metric categories to query. The value `"*"` can be used to include all categories, which are listed below.

```lua
{ "basic", "player" }
```
</template>
</PropertiesTable>

## Usage

```lua{4-8}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput(
    'my_playerDetector',
    telem.input.advancedPeripherals.playerDetector('right', '*'),
    'PlayerName'
  )
  :cycleEvery(5)()
```

Given a Player Detector peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):

### Basic

<MetricTable
  prefix="applayer:"
  :metrics="[
    { name: 'online_player_count',  value: '0 - inf' }
  ]"
/>

### Player

If `playerName` is provided, the following additional metrics are appended to the backplane, tracking the specified player's status:

<MetricTable
  prefix="applayer:"
  :metrics="[
    { name: 'player_eye_height',  value: '0 - inf',     unit: 'm' },
    { name: 'player_pitch',       value: '-90 - 90',    unit: '°' },
    { name: 'player_yaw',         value: '-180 - 180',  unit: '°' },
    { name: 'player_health',      value: '0 - inf'                },
    { name: 'player_air_supply',  value: '0 - inf'                },
    { name: 'player_max_health',  value: '0 - inf'                }
  ]"
/>
