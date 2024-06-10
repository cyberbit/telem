local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local Middleware = o.class()
Middleware.type = 'Middleware'

function Middleware:constructor()
    assert(self.type ~= Middleware.type, 'Middleware cannot be instantiated')

    self.debugState = false
end

function Middleware:handle(backplane)
    error(self.type .. ' has not implemented handle()')
end

function Middleware:debug(debug)
    self.debugState = debug and true or false

    return self
end

function Middleware:dlog(msg)
    if self.debugState then t.log(msg) end
end

return Middleware