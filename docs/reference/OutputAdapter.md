---
outline: deep
---

# OutputAdapter <Badge type="info" text="API" /> <RepoLink path="lib/OutputAdapter.lua" />

OutputAdapter is an [abstract](https://en.wikipedia.org/wiki/Abstract_type) class that functions as a metric consumer. Typically, an OutputAdapter implementation will accept one or more parameters to its constructor method. These properties define what data sources and/or peripherals it should query when `read()` is called.

## Properties

<PropertiesTable
  :properties="[
    {
      name: 'components',
      type: '{ [string]: table }',
      default: '{}',
      description: 'Dictionary of assigned peripherals.',
      setBy: 'subclass'
    }
  ]"
/>

## Methods

### `OutputAdapter`

Creates a new OutputAdapter instance.

::: danger
Because OutputAdapter is an abstract class, this constructor should only be called from within classes inheriting `OutputAdapter` by calling `self:super('constructor')`. This will set up any inherited properties with the correct default values. **Behavior of any other use is undefined.**
:::

### `setBoot`

```lua
OutputAdapter:setBoot (proc: fun()): fun()
```

Sets the `boot()` function called at the top of `write()` and returns it. This should usually be used to prepare a function that reattaches any peripherals that may have changed states between cycles.

### `setAsyncCycleHandler`

```lua
OutputAdapter:setAsyncCycleHandler (proc: fun(backplane: Backplane)): fun(backplane: Backplane)
```

Sets the async cycle handler to pass to [Backplane](Backplane) and returns it.

### `addComponentByPeripheralID`

```lua
OutputAdapter:addComponentByPeripheralID (id: string)
```

This function calls `peripheral.wrap(id)` and appends the result to `self.components` with a key of `id`. If a peripheral was not found, an error is thrown.

### `addComponentByPeripheralType`

```lua
OutputAdapter:addComponentByPeripheralType (type: string)
```

This function calls `peripheral.find(type)` and appends the result to `self.components` with a key of `'type_N'`, where `type` is the specified type and `N` is the current number of assigned components. Below is the result of calling this function multiple times.

```lua
-- in AlarmOutputAdapter.lua
function AlarmOutputAdapter:constructor ()
	self:addComponentByPeripheralType('minecraft:note_block')
	self:addComponentByPeripheralType('computercraft:speaker')
end

-- after initializing an AlarmOutputAdapter on a computer
-- next to a note block and a speaker, self.components might look like this
self.components = {
  ['minecraft:note_block_0'] = { --[[ note block peripheral ]] },
  ['computercraft:speaker_1'] = { --[[ speaker peripheral ]] },
}
```

## `write`

```lua
OutputAdapter:write (metrics: MetricCollection)
```

Writes provided [MetricCollection](MetricCollection) to all assigned components. Specific behavior is implementation-dependent.

::: danger
Because OutputAdapter is an abstract class, calling this method on InputAdapter or on an incomplete implementation of InputAdapter will throw an error.
:::