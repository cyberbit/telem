local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter = o.class()
OutputAdapter.type = 'OutputAdapter'

function OutputAdapter:constructor()
    assert(self.type ~= OutputAdapter.type, 'OutputAdapter cannot be instantiated')

    self.components = {}
end

function OutputAdapter:addComponentByPeripheralID (id)
    self.components.insert(peripheral.wrap(id))
end

function OutputAdapter:addComponentByPeripheralType (type)
    self.components.insert(peripheral.find(type))
end

function OutputAdapter:write (metrics)
    t.err(self.type .. ' has not implemented write()')
end

return OutputAdapter