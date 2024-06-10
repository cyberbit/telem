local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local Middleware = require 'telem.lib.BaseMiddleware'

local HandleCollection = o.class(Middleware)
HandleCollection.type = 'HandleCollection'

function HandleCollection:constructor(handler)
  self:super('constructor')

  self.handler = handler
end

function HandleCollection:handle(collection)
  assert(collection.type == 'MetricCollection', 'HandleCollection:handle :: collection must be a MetricCollection')

  local newCollection = assert(self.handler(collection), 'HandleCollection:handle :: handler must return a MetricCollection')

  return newCollection
end

return HandleCollection