local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local LabelOutputAdapter = o.class(OutputAdapter)
LabelOutputAdapter.type = 'LabelOutputAdapter'

function LabelOutputAdapter:constructor (frame, filter, bg, fg, fontSize)
    self:super('constructor')

    self.bBaseFrame = assert(frame, 'Frame is required')
    self.filter = assert(filter, 'Filter is required')
    self.nameScroll = 1
    self.nameText = '-----'

    self:register(bg, fg, fontSize)
end

function LabelOutputAdapter:register (bg, fg, fontSize)
    self.bInnerFrame = self.bBaseFrame

    -- TODO idk if this inner frame is necessary
    self.bInnerFrame = self.bBaseFrame:addFrame()
        :setBackground(bg)
        :setSize('{parent.w}', '{parent.h}')

    self.bLabelValue = self.bInnerFrame
        :addLabel()
        :setText("-----")
        :setFontSize(fontSize or 2)
        :setBackground(bg)
        :setForeground(fg)
        :setPosition('{parent.w/2-self.w/2}', '{parent.h/2-self.h/2}')
    
    self.bLabelName = self.bInnerFrame
        :addLabel()
        :setText(self.nameText)
        :setBackground(bg)
        :setForeground(fg)
        :setPosition(1,1)
    
    self.animThread = self.bInnerFrame:addThread()
        :start(function ()
            while true do
                local goslep = 0.2
                self.nameScroll = self.nameScroll + 1
                if self.nameScroll > self.nameText:len() + 3 then
                    self.nameScroll = 0
                    goslep = 3
                end
                self:refreshLabels()
                t.sleep(goslep)
            end
        end)
end

function LabelOutputAdapter:refreshLabels ()
    local width = self.bBaseFrame:getWidth()
    local newtext = '-----'
    
    if self.nameText:len() > width then
        newtext = (self.nameText .. ' ' .. string.char(183) .. ' ' .. self.nameText):sub(self.nameScroll)
    else
        newtext = self.nameText
    end

    self.bLabelName:setText(newtext)
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