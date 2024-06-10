local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local fluent = require('telem.vendor').fluent

local Metric     = require 'telem.lib.Metric'
local Middleware = require 'telem.lib.BaseMiddleware'

local CalcAverageMiddleware = o.class(Middleware)
CalcAverageMiddleware.type = 'CalcAverageMiddleware'

function CalcAverageMiddleware:constructor(windowSize)
  self:super('constructor')

  self.windowSize = windowSize or 50
  self.forceProcess = false

  self.history = {}
end

function CalcAverageMiddleware:force()
  self.forceProcess = true

  return self
end

function CalcAverageMiddleware:handle(target)
  assert(target.type == 'MetricCollection', 'CalcAverageMiddleware:handle :: target must be a MetricCollection')

  return self:handleCollection(target)
end

function CalcAverageMiddleware:handleCollection(collection)
  for _, v in ipairs(collection.metrics) do
    if self.forceProcess or v.source ~= 'middleware' then
      self.history[v.name] = self.history[v.name] or {}

      t.constrainAppend(self.history[v.name], v.value, self.windowSize)
    end
  end
  
  for k, v in pairs(self.history) do
    local sum

    for _, hv in ipairs(v) do
        sum = sum and sum + hv or hv
    end

    collection:insert(Metric{
      name = k .. '_avg',
      value = sum and sum / #v or 0,
      source = 'middleware'
    })
  end
  
  return collection
end

return CalcAverageMiddleware