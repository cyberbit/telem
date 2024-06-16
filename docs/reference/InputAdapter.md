---
outline: deep
---

# InputAdapter <Badge type="info" text="API" /> <RepoLink path="lib/InputAdapter.lua" />

InputAdapter is an [abstract](https://en.wikipedia.org/wiki/Abstract_type) class that functions as a metric producer. Typically, an InputAdapter implementation will accept one or more parameters to its constructor method. These properties define what data sources and/or peripherals it should query when `read()` is called.

## Properties

<PropertiesTable
  :properties="[
    {
      name: 'components',
      type: '{ [string]: table }',
      default: '{}',
      description: 'Dictionary of assigned peripherals.',
      setBy: 'subclass'
    },
    {
      name: 'prefix',
      type: 'string',
      default: '&quot;&quot;',
      description: 'Prefix to apply to metric names at read time.',
      setBy: 'subclass'
    }
  ]"
/>

## Methods

### `InputAdapter`

Creates a new InputAdapter instance.

::: danger
Because InputAdapter is an abstract class, this constructor should only be called from within classes inheriting `InputAdapter` by calling `self:super('constructor')`. This will set up any inherited properties with the correct default values. **Behavior of any other use is undefined.**
:::

### `setBoot`

```lua
InputAdapter:setBoot (proc: fun()): fun()
```

Sets the `boot()` function called at the top of `read()` and returns it. This should usually be used to prepare a function that reattaches any peripherals that may have changed states between cycles.

### `setAsyncCycleHandler`

```lua
InputAdapter:setAsyncCycleHandler (proc: fun(backplane: Backplane)): fun(backplane: Backplane)
```

Sets the async cycle handler to pass to [Backplane](Backplane) and returns it.

### `addComponentByPeripheralID`

```lua
InputAdapter:addComponentByPeripheralID (id: string)
```

This function calls `peripheral.wrap(id)` and appends the result to `self.components` with a key of `id`. If a peripheral was not found, an error is thrown.

### `addComponentByPeripheralType`

```lua
InputAdapter:addComponentByPeripheralType (type: string)
```

This function calls `peripheral.find(type)` and appends the result to `self.components` with a key of `'type_N'`, where `type` is the specified type and `N` is the current number of assigned components. Below is the result of calling this function multiple times.

```lua
-- in AutoChestInputAdapter.lua
function AutoChestInputAdapter:constructor ()
	self:addComponentByPeripheralType('minecraft:chest')
	self:addComponentByPeripheralType('minecraft:barrel')
end

-- after initializing an AutoChestInputAdapter on a computer
-- next to a chest and a barrel, self.components might look like this:
self.components = {
  ['minecraft:chest_0'] = { --[[ chest peripheral ]] },
  ['minecraft:barrel_1'] = { --[[ barrel peripheral ]] },
}
```

### `read` <Badge type="warning" text="abstract" />

```lua
InputAdapter:read (): MetricCollection
```

Reads data from implementation-defined sources into a [MetricCollection](MetricCollection) and returns it.