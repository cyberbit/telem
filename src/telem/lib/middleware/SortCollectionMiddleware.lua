local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fluent = require 'telem.vendor'.fluent

local Middleware       = require 'telem.lib.BaseMiddleware'
local MetricCollection = require 'telem.lib.MetricCollection'

local SortCollectionMiddleware = o.class(Middleware)
SortCollectionMiddleware.type = 'SortCollectionMiddleware'

function SortCollectionMiddleware:constructor()
  self:super('constructor')
end

function SortCollectionMiddleware:handle(collection)
  assert(collection.type == 'MetricCollection', 'SortCollectionMiddleware:handle :: collection must be a MetricCollection')

  fluent(collection.metrics):sortBy('name')

  return collection
end

return SortCollectionMiddleware