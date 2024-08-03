```lua-vue
telem.input.mekanism.{{ $frontmatter.telem.adapter.id || 'ADAPTER.ID' }} (
  peripheralID: string,
  categories?: string[] | '*'
)
```

::: warning Mod Dependencies
<template v-if="$frontmatter.telem.adapter.requiresMekGen">

Requires **Mekanism** and **Mekanism Generators**.

</template>
<template v-else>

Requires **Mekanism**.

</template>
:::

See the Usage section for a complete list of the metrics in each category.

<PropertiesTable
  :properties="[
    {
      name: 'peripheralID',
      type: 'string',
      default: 'nil',
      description: 'Peripheral ID of the ' + ($frontmatter.telem.adapter.name || 'ADAPTER.NAME')
    },
    {
      name: 'categories',
      type: 'string[] | &quot;*&quot;',
      default: '{ &quot;basic&quot; }'
    }
  ]"
>
<template v-slot:categories>

List of metric categories to query. The value `"*"` can be used to include all categories, which are listed below.

```lua-vue
{{ $frontmatter.telem.adapter.categories || 'ADAPTER.CATEGORIES' }}
```
</template>
</PropertiesTable>

## Usage

```lua-vue{4}
local telem = require 'telem'

local backplane = telem.backplane()
  :addInput('my_{{ $frontmatter.telem.adapter.id || 'ADAPTER.ID' }}', telem.input.mekanism.{{ $frontmatter.telem.adapter.id || 'ADAPTER.ID' }}('right', '*'))
  :cycleEvery(5)()
```

Given a {{ $frontmatter.telem.adapter.name || 'ADAPTER.NAME' }} peripheral on the `right` side of the computer, this appends the following metrics to the backplane (grouped by category here for clarity):