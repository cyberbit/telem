local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local vendor
local plotterFactory

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local ChartAreaOutputAdapter = o.class(OutputAdapter)
ChartAreaOutputAdapter.type = 'ChartAreaOutputAdapter'

ChartAreaOutputAdapter.BASELINE = 0
ChartAreaOutputAdapter.MAX_ENTRIES = 50
ChartAreaOutputAdapter.X_TICK = 10

function ChartAreaOutputAdapter:constructor (win, filter, bg, fg, baseline, maxEntries)
    self:super('constructor')

    self:cacheable()

    self.win = assert(win, 'Window is required')
    self.filter = assert(filter, 'Filter is required')

    self.plotter = nil
    self.plotData = {}
    self.gridOffsetX = 0

    self.filter = filter

    self.bg = bg or win.getBackgroundColor() or colors.black
    self.fg = fg or win.getTextColor() or colors.white
    self.BASELINE = baseline or 0
    self.MAX_ENTRIES = maxEntries or self.MAX_ENTRIES

    self:register()
end

function ChartAreaOutputAdapter:register ()
    if not vendor then
        self:dlog('ChartAreaOutputAdapter:boot :: Loading vendor modules...')

        vendor = require 'telem.vendor'

        self:dlog('ChartAreaOutputAdapter:boot :: Vendor modules ready.')
    end

    if not plotterFactory then
        self:dlog('ChartAreaOutputAdapter:boot :: Loading plotter...')

        plotterFactory = vendor.plotter

        self:dlog('ChartAreaOutputAdapter:boot :: plotter ready.')
    end

    self:updateLayout()

    for i = 1, self.MAX_ENTRIES do
        t.constrainAppend(self.plotData, self.plotter.NAN, self.MAX_ENTRIES)
    end
end

function ChartAreaOutputAdapter:updateLayout (bypassRender)
    self.plotter = plotterFactory(self.win)

    if not bypassRender then
        self:render()
    end
end

function ChartAreaOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    local resultMetric = collection:find(self.filter)

    assert(resultMetric, 'could not find metric')

    -- TODO data width setting
    self.gridOffsetX = self.gridOffsetX - t.constrainAppend(self.plotData, resultMetric and resultMetric.value or self.plotter.NAN, self.MAX_ENTRIES)

    -- TODO X_TICK setting
    if self.gridOffsetX % self.X_TICK == 0 then
        self.gridOffsetX = 0
    end

    -- lazy layout update
    local winw, winh = self.win.getSize()
    if winw ~= self.plotter.box.term_width or winh ~= self.plotter.box.term_height then
        self:updateLayout(true)
    end

    self:render()
    
    return self
end

function ChartAreaOutputAdapter:getState ()
    local plotData = {}

    for k,v in ipairs(self.plotData) do
        plotData[k] = v
    end

    return {
        plotData = plotData,
        gridOffsetX = self.gridOffsetX
    }
end

function ChartAreaOutputAdapter:loadState (state)
    self.plotData = state.plotData
    self.gridOffsetX = state.gridOffsetX
end

function ChartAreaOutputAdapter:render ()
    local dataw = #{self.plotData}

    local actualmin, actualmax = math.huge, -math.huge

    for _, v in ipairs(self.plotData) do
        -- skip NAN
        if v ~= self.plotter.NAN then
            if v < actualmin then actualmin = v end
            if v > actualmax then actualmax = v end
        end
    end
    
    local flatlabel = nil

    -- NaN data
    if actualmin == math.huge then
        flatlabel = 'NaN'

        actualmin, actualmax = 0, 0
    end

    -- flat data
    if actualmin == actualmax then
        local minrange = 0.000001

        if not flatlabel then
            flatlabel = t.shortnum2(actualmin)
        end

        actualmin = actualmin - minrange / 2
        actualmax = actualmax + minrange / 2
    end
    
    self.plotter:clear(self.bg)

    self.plotter:chartGrid(self.MAX_ENTRIES, actualmin, actualmax, self.gridOffsetX, colors.gray, {
        xGap = 10,
        yLinesMin = 5, -- yLinesMin: number >= 1
        yLinesFactor = 2 -- yLinesFactor: integer >= 2
        -- effective max density = yMinDensity * yBasis
    })

    self.plotter:chartArea(self.plotData, self.MAX_ENTRIES, actualmin, actualmax, self.BASELINE, self.fg)

    local maxString = t.shortnum2(actualmax)
    local minString = t.shortnum2(actualmin)

    self.win.setVisible(false)

    self.plotter:render()

    self.win.setTextColor(self.fg)
    self.win.setBackgroundColor(self.bg)
    if not flatlabel then
        self.win.setCursorPos(self.plotter.box.term_width - #maxString + 1, 1)
        self.win.write(maxString)

        self.win.setCursorPos(self.plotter.box.term_width - #minString + 1, self.plotter.box.term_height)
        self.win.write(minString)
    else
        self.win.setCursorPos(self.plotter.box.term_width - #flatlabel + 1, self.plotter.math.round(self.plotter.box.term_height / 2))
        self.win.write(flatlabel)
    end

    self.win.setVisible(true)
end

return ChartAreaOutputAdapter