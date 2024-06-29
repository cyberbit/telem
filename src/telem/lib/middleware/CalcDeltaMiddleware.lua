local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local fluent = require('telem.vendor').fluent

local Metric     = require 'telem.lib.Metric'
local Middleware = require 'telem.lib.BaseMiddleware'

local CalcDeltaMiddleware = o.class(Middleware)
CalcDeltaMiddleware.type = 'CalcDeltaMiddleware'

local rateIntervalSourceFactors = { utc = 1000, ingame = 72000 }

function CalcDeltaMiddleware:constructor(windowSize)
  self:super('constructor')

  self.windowSize = windowSize or 50
  self.rateInterval = 1
  self.rateIntervalSource = 'utc'
  self.forceProcess = false

  self.history = {}
  self.times = {}
end

function CalcDeltaMiddleware:force()
  self.forceProcess = true

  return self
end

function CalcDeltaMiddleware:interval(interval, source)
  local factor, unit = interval:match('^(%d+)(%l)$')
  source = source or 'utc'

  assert(factor, 'CalcDeltaMiddleware:interval :: invalid interval format')
  assert(source == 'utc' or source == 'ingame', 'CalcDeltaMiddleware:interval :: interval source must be "utc" or "ingame"')

  self.rateInterval = tonumber(factor) * fluent(unit):toLookup({ t = 0.05, s = 1, m = 60, h = 3600, d = 86400 }):result()
  self.rateIntervalSource = source

  return self
end

function CalcDeltaMiddleware:handle(target)
  assert(target.type == 'MetricCollection', 'CalcDeltaMiddleware:handle :: target must be a MetricCollection')

  return self:handleCollection(target)
end

function CalcDeltaMiddleware:handleCollection(collection)
  local timestamp = os.epoch(self.rateIntervalSource) / rateIntervalSourceFactors[self.rateIntervalSource]

  for _, v in ipairs(collection.metrics) do
    if self.forceProcess or v.source ~= 'middleware' then
      self.history[v.name] = self.history[v.name] or {}
      self.times[v.name] = self.times[v.name] or {}

      t.constrainAppend(self.history[v.name], v.value, self.windowSize)
      t.constrainAppend(self.times[v.name], timestamp, self.windowSize)
    end
  end

  for k, v in pairs(self.history) do
    local idelta, delta, irate, rate = 0, 0, 0, 0

    if #v >= 2 then
      local vt = self.times[k]

      idelta = v[#v] - v[#v - 1]
      delta = v[#v] - v[1]

      local itimedelta = vt[#vt] - vt[#vt - 1]
      local timedelta = vt[#vt] - vt[1]

      irate = (idelta / itimedelta) * self.rateInterval
      rate = (delta / timedelta) * self.rateInterval
    end

    collection:insert(Metric{ name = k .. '_idelta', value = idelta, source = 'middleware' })
    collection:insert(Metric{ name = k ..  '_delta', value =  delta, source = 'middleware' })
    collection:insert(Metric{ name = k ..  '_irate', value =  irate, source = 'middleware' })
    collection:insert(Metric{ name = k ..   '_rate', value =   rate, source = 'middleware' })
  end
  
  return collection
end

return CalcDeltaMiddleware