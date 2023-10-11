local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local LabelOutputAdapter = o.class(OutputAdapter)
LabelOutputAdapter.type = 'LabelOutputAdapter'

function LabelOutputAdapter:constructor (frame, filter, bg, fg)
    self:super('constructor')

    self.bBaseframe = assert(frame, 'Frame is required')
    self.filter = assert(filter, 'Filter is required')
    self.nameScroll = 1
    self.nameText = '-----'

    self:register(bg, fg)
end

function LabelOutputAdapter:register (bg, fg)
    self.bInnerframe = self.bBaseframe
        :addFrame()
        :setBackground(bg)
        :setSize('{parent.w}', '{parent.h}')

    self.bLabelValue = self.bInnerframe
        :addLabel()
        :setText("-----")
        :setFontSize(2)
        :setBackground(bg)
        :setForeground(fg)
        :setPosition('{parent.w/2-self.w/2}', '{parent.h/2-self.h/2}')
    
    self.bLabelName = self.bInnerframe
        :addLabel()
        :setText(self.nameText)
        :setBackground(bg)
        :setForeground(fg)
        :setPosition(1,1)
    
    self.animThread = self.bInnerframe:addThread()
    self.animThread:start(function ()
        while true do
            local goslep = 0.2
            print (self.nameScroll)
            print(self.nameText)
            self.nameScroll = self.nameScroll + 1
            if self.nameScroll > self.nameText:len() + 1 then
                self.nameScroll = 0
                goslep = 3
            end
            self:refreshLabels()
            sleep(goslep)
        end
    end)
end

function LabelOutputAdapter:refreshLabels ()
    self.bLabelName:setText(self.nameText:sub(self.nameScroll))
end

function LabelOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    local resultMetric = collection:find(self.filter)

    assert(resultMetric, 'could not find metric')

    self.bLabelValue:setText(t.shortnum(resultMetric.value))
    self.nameText = resultMetric.name
    self:refreshLabels()

    return self
end

return LabelOutputAdapter