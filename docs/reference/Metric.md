---
outline: deep
---

# Metric <Badge type="info" text="API" /> <RepoLink path="lib/Metric.lua" />

Metric is an object that wraps a scalar value, adding several properties to track its characteristics.

This type serves a critical role in the Telem lifecycle. Because of this, there are some limits that are followed within Telem in order to preserve compatibility across its systems. While not required, it is recommended that any custom adapters also follow these specifications to avoid issues in the future. Requirement levels ("MUST", "MAY", etc.) follow [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

- A Metric `name` **MUST NOT** be empty or null.
- A Metric `name` **MUST** only contain lowercase letters, numbers, colons (`:`), and underscores (`_`).
  ::: info
  Colons should be reserved as a semantic divider. For example, consider that the name `"storage:minecraft:redstone_block"` has the tokens `"storage"`, `"minecraft"`, and `"redstone_block"`. This separation of characteristics (resource type, mod, and item) may have value to consumers of the metric.
  :::
- A Metric `name` **MUST** start with a lowercase letter.
- A Metric `name` **MUST NOT** exceed 100 characters in length.
- A Metric `value` **MUST NOT** be empty or null.
- A Metric `value` **MUST** be an integer or floating point number.
- A Metric **MAY** have an assigned `adapter`, defined as a non-empty string not exceeding 32 characters in length.
- A Metric **MAY** have an assigned `source`, defined as a non-empty string not exceeding 32 characters in length.
- A Metric **MAY** have an assigned `unit`, defined as a non-empty string not exceeding 16 characters in length.

## Properties

<PropertiesTable
  :properties="[
    {
      name: 'name',
      type: 'string',
      default: 'nil',
      description: 'Name of the metric.'
    },
    {
      name: 'value',
      type: 'number',
      default: 'nil',
      description: 'Value of the metric.'
    },
    {
      name: 'adapter',
      type: 'string',
      default: 'nil',
      description: 'Name of the adapter that produced the metric.',
      setBy: 'Backplane'
    },
    {
      name: 'source',
      type: 'string',
      default: 'nil',
      description: 'Name of the component that produced the metric.',
      setBy: 'InputAdapter'
    },
    {
      name: 'unit',
      type: 'string',
      default: 'nil',
      description: 'Label describing the kind of value being measured.'
    }
  ]"
/>

## Methods

### `Metric`

```lua
Metric(name: string, value: number)
Metric({ name: string, value: number, unit?: string, source?: string, adapter?: string })
```

There are two Metric constructor signatures. Both only require a `name` and `value` to be passed in, but the detailed signature is more flexible.

 1. **Simple Metric**

    This constructor will create a metric with a specified name and value.

    ```lua
    local telem = require 'telem'

    local simpleMetric = telem.metric('metric_name', 123)
    ```

 2. **Detailed Metric**

    This constructor will create a metric using a table of properties, of which only `name` and `value` are required.

    ```lua
    local telem = require 'telem'

    local detailedMetric1 = telem.metric({
      name = 'speed',
      value = 123,
      unit = 'm/s',
    })

    -- you can also choose to remove the round brackets of the call
    local detailedMetric2 = telem.metric{ name = 'status', value = STATUS.ACTIVE, unit = 'm/s' }
    ```

## Metamethods

### `__tostring`

Converts this Metric into a string representation. The exact format will vary depending on what labels are present, but generally follows the below specification:

```lua
-- {PROPERTY} represents a property read from the Metric
-- [text] indicates an optional section

'{name} = {value}[ {unit}][ from {adapter}][ ({source})]'
```

Some examples of Metric string conversion:
  
```lua
local simpleMetric = telem.metric('metric_name', 123)
local detailedMetric1 = telem.metric({
  name = 'speed',
  value = 15.8,
  adapter = 'radar_in',
  source = 'radarComponent_0',
  unit = 'm/s',
})

print(simpleMetric)    -- metric_name = 123
print(detailedMetric1) -- speed = 15.8 m/s from radar_in (radarComponent_0)
```