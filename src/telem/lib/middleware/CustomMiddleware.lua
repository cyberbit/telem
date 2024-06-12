local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local Middleware = require 'telem.lib.BaseMiddleware'

local CustomMiddleware = o.class(Middleware)
CustomMiddleware.type = 'CustomMiddleware'

function CustomMiddleware:constructor(handler)
  self:super('constructor')

  self.handler = handler
end

function CustomMiddleware:handle(collection)
  assert(collection.type == 'MetricCollection', 'CustomMiddleware:handle :: collection must be a MetricCollection')

  local newCollection = assert(self.handler(collection), 'CustomMiddleware:handle :: handler must return a MetricCollection')

  return newCollection
end

return CustomMiddleware