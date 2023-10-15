local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local Metric = o.class()
Metric.type = 'Metric'

function Metric:constructor (data, data2)
    local datum

    if type(data) == 'table' then
        datum = data
    else
        datum = { name = data, value = data2 }
    end

    assert(type(datum.value) == 'number', 'Metric value must be a number')

    self.name = assert(datum.name, 'Metric must have a name')
    self.value = assert(datum.value, 'Metric must have a value')
    self.unit = datum.unit or nil
    self.source = datum.source or nil
    self.adapter = datum.adapter or nil
end

function Metric:__tostring ()
    local label = self.name .. ' = ' .. self.value

    -- TODO unit source adapter
    local unit, source, adapter

    unit = self.unit and ' ' .. self.unit or ''
    source = self.source and ' (' .. self.source .. ')' or ''
    adapter = self.adapter and ' from ' .. self.adapter or ''

    -- t.pprint(unit)
    -- t.pprint(source)
    -- t.pprint(adapter)

    return label .. unit .. adapter .. source
end

return Metric