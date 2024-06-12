---
outline: deep
---

# Middleware <Badge type="info" text="API" /> <RepoLink path="lib/BaseMiddleware.lua" />

Middleware is an [abstract](https://en.wikipedia.org/wiki/Abstract_type) class that functions as a mutator for [MetricCollection](MetricCollection) instances at specific points in a cycle, such as just before writing to outputs. Middleware is free to add, modify, and remove metrics from the collection, or replace it entirely if needed.

## Methods

### `Middleware`

Creates a new Middleware instance.

::: danger
Because Middleware is an abstract class, this constructor should only be called from within classes inheriting `Middleware` by calling `self:super('constructor')`. This will set up any inherited properties with the correct default values. **Behavior of any other use is undefined.**
:::

### `handle` <Badge type="warning" text="abstract" />

```lua
Middleware:handle (target: MetricCollection): MetricCollection
```

Process the provided MetricCollection and return the resulting MetricCollection. In-place modification or replacement are both supported.