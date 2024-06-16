local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fluent = require 'telem.vendor'.fluent

local Middleware       = require 'telem.lib.BaseMiddleware'
local MetricCollection = require 'telem.lib.MetricCollection'

local SortMiddleware = o.class(Middleware)
SortMiddleware.type = 'SortMiddleware'

function SortMiddleware:constructor()
  self:super('constructor')
end

function SortMiddleware:handle(collection)
  assert(collection.type == 'MetricCollection', 'SortMiddleware:handle :: collection must be a MetricCollection')

  fluent(collection.metrics):sortBy('name')

  return collection
end

return SortMiddleware