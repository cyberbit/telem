local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local GraphOutputAdapter = o.class(OutputAdapter)
GraphOutputAdapter.type = 'GraphOutputAdapter'

function GraphOutputAdapter:constructor (endpoint, apiKey)
    self:super('constructor')

    self.endpoint = assert(endpoint, 'Endpoint is required')
    self.apiKey = assert(apiKey, 'API key is required')
end

function GraphOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    local outf = {}

    for _,v in pairs(collection.metrics) do
        local unitreal = (v.unit and v.unit ~= '' and ',unit=' .. v.unit) or ''
        local sourcereal = (v.source and v.source ~= '' and ',source=' .. v.source) or ''
        local adapterreal = (v.adapter and v.adapter ~= '' and ',adapter=' .. v.adapter) or ''

        table.insert(outf, v.name .. unitreal .. sourcereal .. adapterreal .. (' metric=%f'):format(v.value))
    end

    -- t.pprint(collection)

    local res = http.post({
        url = self.endpoint,
        body = table.concat(outf, '\n'),
        headers = { Authorization = ('Bearer %s'):format(self.apiKey) }
    })
end

return GraphOutputAdapter





--------------------
--------------------


-- local pprint = require('cc.pretty').pretty_print
-- local shortnum = require('shortnum')
-- local basalt = require 'basalt'

-- local MAX_ENTRIES = 50
-- local SCALE_TICK = 10

-- local base = basalt.createFrame('base'):setBackground(colors.black)
-- local frame = base:addFrame('frame')
--     :setSize('{parent.w}', '{parent.h}')
--     :setBackground(colors.black)

-- local fGraph = frame:addFrame('fGraph'):setBackground(colors.black)
--     :setPosition(1,1)
--     :setSize('{parent.w - 2}', '{parent.h - 6}')
--     -- :setFlexGrow(0)
--     -- :setFlexShrink(0)

-- local fLabel = frame:addFrame('fLabel'):setBackground(colors.black)
--     :setSize('{parent.w - 2}', 4)
--     :setPosition(1,'{parent.h - 5}')
--     :setBorder(colors.green)
--     -- :setFlexGrow(1)

-- local fLabelMax = frame:addFrame('fLabelMax'):setBackground(colors.black)
--     :setSize(6, 1)
--     :setPosition('{parent.w - 7}',1)

-- local fLabelMin = frame:addFrame('fLabelMin'):setBackground(colors.black)
--     :setSize(6, 1)
--     :setPosition('{parent.w - 7}','{fLabel.y - 2}')

-- local label = fLabel:addLabel()
--     :setText("-----")
--     :setFontSize(2)
--     :setPosition('{parent.w/2-self.w/2}', 2)
--     :setForeground(colors.white)
--     :setBackground(colors.black)
-- local graph = fGraph:addGraph()
--     :setPosition(1,1)
--     :setSize('{parent.w - 1}', '{parent.h - 1}')
--     :setMaxEntries(MAX_ENTRIES)
--     :setBackground(colors.black)
--     :setGraphColor(colors.red)
--     :setGraphSymbol('\127')

-- local graphscale = fGraph:addGraph()
--     :setGraphType('scatter')
--     :setPosition(1,'{parent.h - 1}')
--     :setSize('{parent.w - 1}', 2)
--     :setMaxEntries(MAX_ENTRIES)
--     :setBackground(colors.transparent)
--     -- :setGraphColor(colors.lightGray)
--     :setGraphSymbol('|')

-- local labelmax = fLabelMax:addLabel()
--     :setPosition(1,1)
--     -- :setSize(5,1)
--     :setText('-----')
--     :setForeground(colors.white)
--     :setBackground(colors.black)

-- local labelmin = fLabelMin:addLabel()
--     :setPosition(1,1)
--     -- :setSize(5,1)
--     :setText('-----')
--     :setForeground(colors.white)
--     :setBackground(colors.black)

-- local graphdata = {}

-- -- this breaks it really bad
-- -- graph:setMinValue(-100000):setMaxValue(-100000)
-- -- for i = 1,MAX_ENTRIES,1 do
-- --     graph:addDataPoint(-100000)
-- -- end
-- -- graph:setMinValue(0)

-- local function graphtrack (value)
--     -- print('graphtrack')
--     table.insert(graphdata, value)
--     while #graphdata>MAX_ENTRIES do
--         table.remove(graphdata,1)
--     end
-- end

-- local function graphtrackrange ()
--     -- print('graphtrackrange')
--     local min = graphdata[1]
--     local max = graphdata[1]
--     for k,v in ipairs(graphdata) do
--         if v < min then min = v end
--         if v > max then max = v end
--     end
--     -- print('min '..min..' max '..max)
--     return min,max
-- end

-- local currentmin = 0
-- local currentmax = 1000

-- local metric = 0
-- local tick = 0

-- graph:setMinValue(currentmin):setMaxValue(currentmax)

-- parallel.waitForAll(
--     basalt.autoUpdate,

--     function ()
--         while true do
--             local newnum = math.random(-90,100)
--             -- local newnum = math.random(90,100)
--             metric = metric + newnum

--             graphtrack(metric)

--             local newmin, newmax = graphtrackrange()
--             graph:setMinValue(newmin):setMaxValue(newmax)

--             graph:addDataPoint(metric)

--             label:setText(shortnum(metric))
            
--             if tick == SCALE_TICK then
--                 graphscale:addDataPoint(100)
--                 tick = 1
--             else
--                 graphscale:addDataPoint(50)
--                 tick = tick + 1
--             end

--             labelmax:setText(shortnum(newmax))
--             labelmin:setText(shortnum(newmin))

--             sleep(0.1)
--         end
--     end
-- )