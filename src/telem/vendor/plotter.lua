-- Plotter by cyberbit
-- MIT License
-- Version 0.0.3

local pixelbox2 = (function ()
    -- Pixelbox Lite v2 by 9551-Dev
    -- (v1: https://github.com/9551-Dev/apis/blob/main/pixelbox_lite.lua)

    local pixelbox   = {}
    local box_object = {}

    local t_cat  = table.concat

    -- local sampling_lookup = {
    --     {2,3,4,5,6},
    --     {4,1,6,3,5},
    --     {1,4,5,2,6},
    --     {2,6,3,5,1},
    --     {3,6,1,4,2},
    --     {4,5,2,3,1}
    -- }

    local sampling_lookup = {
        {3,5,2,4,6},
        {4,6,1,3,5},
        {1,5,2,4,6},
        {2,6,1,3,5},
        {1,3,6,4,2},
        {4,2,5,3,1}
    }

    local texel_character_lookup  = {}
    local texel_foreground_lookup = {}
    local texel_background_lookup = {}
    local to_blit = {}

    local factorial_1 = 1
    local factorial_2 = factorial_1 * 2
    local factorial_3 = factorial_2 * 3
    local factorial_4 = factorial_3 * 4
    local factorial_5 = factorial_4 * 5

    local function generate_identifier(s1,s2,s3,s4,s5,s6)
        return  s2 * factorial_1 +
                s3 * factorial_2 +
                s4 * factorial_3 +
                s5 * factorial_4 +
                s6 * factorial_5
    end

    local function calculate_texel(v1,v2,v3,v4,v5,v6)
        local texel_data = {v1,v2,v3,v4,v5,v6}

        local state_lookup = {}
        for i=1,6 do
            local subpixel_state = texel_data[i]
            local current_count = state_lookup[subpixel_state]

            state_lookup[subpixel_state] = current_count and current_count + 1 or 1
        end

        local sortable_states = {}
        for k,v in pairs(state_lookup) do
            sortable_states[#sortable_states+1] = {
                value = k,
                count = v
            }
        end

        table.sort(sortable_states,function(a,b)
            return a.count > b.count
        end)

        local texel_stream = {}
        for i=1,6 do
            local subpixel_state = texel_data[i]

            if subpixel_state == sortable_states[1].value then
                texel_stream[i] = 1
            elseif subpixel_state == sortable_states[2].value then
                texel_stream[i] = 0
            else
                local sample_points = sampling_lookup[i]
                for sample_index=1,5 do
                    local sample_subpixel_index = sample_points[sample_index]
                    local sample_state          = texel_data   [sample_subpixel_index]

                    local common_state_1 = sample_state == sortable_states[1].value
                    local common_state_2 = sample_state == sortable_states[2].value

                    if common_state_1 or common_state_2 then
                        texel_stream[i] = common_state_1 and 1 or 0

                        break
                    end
                end
            end
        end

        local char_num = 128
        local stream_6 = texel_stream[6]
        if texel_stream[1] ~= stream_6 then char_num = char_num + 1  end
        if texel_stream[2] ~= stream_6 then char_num = char_num + 2  end
        if texel_stream[3] ~= stream_6 then char_num = char_num + 4  end
        if texel_stream[4] ~= stream_6 then char_num = char_num + 8  end
        if texel_stream[5] ~= stream_6 then char_num = char_num + 16 end

        local state_1,state_2
        if #sortable_states > 1 then
            state_1 = sortable_states[  stream_6+1].value
            state_2 = sortable_states[2-stream_6  ].value
        else
            state_1 = sortable_states[1].value
            state_2 = sortable_states[1].value
        end

        return char_num,state_1,state_2
    end

    local function base_n_rshift(n,base,shift)
        return math.floor(n/(base^shift))
    end

    local real_entries = 0
    local function generate_lookups()
        for i = 0, 15 do
            to_blit[2^i] = ("%x"):format(i)
        end

        for encoded_pattern=0,6^6 do
            local subtexel_1 = base_n_rshift(encoded_pattern,6,0) % 6
            local subtexel_2 = base_n_rshift(encoded_pattern,6,1) % 6
            local subtexel_3 = base_n_rshift(encoded_pattern,6,2) % 6
            local subtexel_4 = base_n_rshift(encoded_pattern,6,3) % 6
            local subtexel_5 = base_n_rshift(encoded_pattern,6,4) % 6
            local subtexel_6 = base_n_rshift(encoded_pattern,6,5) % 6

            local pattern_lookup = {}
            pattern_lookup[subtexel_6] = 5
            pattern_lookup[subtexel_5] = 4
            pattern_lookup[subtexel_4] = 3
            pattern_lookup[subtexel_3] = 2
            pattern_lookup[subtexel_2] = 1
            pattern_lookup[subtexel_1] = 0

            local pattern_identifier = generate_identifier(
                pattern_lookup[subtexel_1],pattern_lookup[subtexel_2],
                pattern_lookup[subtexel_3],pattern_lookup[subtexel_4],
                pattern_lookup[subtexel_5],pattern_lookup[subtexel_6]
            )

            if not texel_character_lookup[pattern_identifier] then
                real_entries = real_entries + 1
                local character,sub_state_1,sub_state_2 = calculate_texel(
                    subtexel_1,subtexel_2,
                    subtexel_3,subtexel_4,
                    subtexel_5,subtexel_6
                )

                local color_1_location = pattern_lookup[sub_state_1] + 1
                local color_2_location = pattern_lookup[sub_state_2] + 1

                texel_foreground_lookup[pattern_identifier] = color_1_location
                texel_background_lookup[pattern_identifier] = color_2_location

                texel_character_lookup[pattern_identifier] = string.char(character)
            end
        end
    end

    function pixelbox.restore(box,color,keep_existing)
        if not keep_existing then
            local new_canvas = {}

            for y=1,box.height do
                for x=1,box.width do
                    if not new_canvas[y] then new_canvas[y] = {} end
                    new_canvas[y][x] = color
                end
            end

            box.canvas = new_canvas
        else
            local canvas = box.canvas

            for y=1,box.height do
                for x=1,box.width do
                    if not bc[y] then bc[y] = {} end

                    if not canvas[y][x] then
                        canvas[y][x] = color
                    end
                end
            end
        end
    end

    local color_lookup  = {}
    local texel_body    = {0,0,0,0,0,0}
    function box_object:render()
        local t = self.term
        local blit_line,set_cursor = t.blit,t.setCursorPos

        local canv = self.canvas

        local char_line,fg_line,bg_line = {},{},{}

        local width,height = self.width,self.height

        local sy = 0
        for y=1,height,3 do
            sy = sy + 1
            local layer_1 = canv[y]
            local layer_2 = canv[y+1]
            local layer_3 = canv[y+2]

            local n = 0
            for x=1,width,2 do
                local xp1 = x+1
                local b1,b2,b3,b4,b5,b6 =
                    layer_1[x],layer_1[xp1],
                    layer_2[x],layer_2[xp1],
                    layer_3[x],layer_3[xp1]

                local char,fg,bg = " ",1,b1

                local single_color = b2 == b1
                                and  b3 == b1
                                and  b4 == b1
                                and  b5 == b1
                                and  b6 == b1

                if not single_color then
                    color_lookup[b6] = 5
                    color_lookup[b5] = 4
                    color_lookup[b4] = 3
                    color_lookup[b3] = 2
                    color_lookup[b2] = 1
                    color_lookup[b1] = 0

                    local pattern_identifier =
                        color_lookup[b2]       +
                        color_lookup[b3] * 2   +
                        color_lookup[b4] * 6   +
                        color_lookup[b5] * 24  +
                        color_lookup[b6] * 120

                    local fg_location = texel_foreground_lookup[pattern_identifier]
                    local bg_location = texel_background_lookup[pattern_identifier]

                    texel_body[1] = b1
                    texel_body[2] = b2
                    texel_body[3] = b3
                    texel_body[4] = b4
                    texel_body[5] = b5
                    texel_body[6] = b6

                    fg = texel_body[fg_location]
                    bg = texel_body[bg_location]

                    char = texel_character_lookup[pattern_identifier]
                end

                n = n + 1
                char_line[n] = char
                fg_line  [n] = to_blit[fg]
                bg_line  [n] = to_blit[bg]
            end

            set_cursor(1,sy)
            blit_line(
                t_cat(char_line,""),
                t_cat(fg_line,  ""),
                t_cat(bg_line,  "")
            )
        end
    end

    function box_object:clear(color)
        pixelbox.restore(self,color)
    end

    function box_object:set_pixel(x,y,color)
        -- print('set_pixel',x,y,color)
        self.canvas[y][x] = color
    end

    function box_object:resize(w,h,color)
        self.term_width  = w
        self.term_height = h
        self.width  = w*2
        self.height = h*3

        pixelbox.restore(self,color or self.background,true)
    end

    local first_run = true

    function pixelbox.new(terminal,bg)
        local box = {}

        box.background = bg or terminal.getBackgroundColor() or colors.black

        local w,h = terminal.getSize()
        box.term  = terminal

        setmetatable(box,{__index = box_object})

        box.term_width  = w
        box.term_height = h
        box.width       = w*2
        box.height      = h*3

        pixelbox.restore(box,box.background)

        if first_run then
            generate_lookups()

            first_run = false
        end

        return box
    end

    return pixelbox
end)()

local Plotter = setmetatable({ _VERSION = '0.0.3' }, {
    __call = function (class, ...)
        local object = setmetatable({}, class)
        
        class.constructor(object, ...)
        
        return object
    end
})
Plotter.__index = Plotter

-- constants
Plotter.NAN = '_NAN'
Plotter.RANGE_MIN = 0.000001

Plotter.math = {
    --- round a number to the nearest integer
    --- @param x number
    --- @return integer
    round = function (x)
        return math.floor(x + 0.5)
    end,

    --- scale s from smin and smax to tmin and tmax
    --- something t
    --- (via https://stats.stackexchange.com/a/281164)
    --- @param s number
    --- @param smin number
    --- @param smax number
    --- @param tmin number
    --- @param tmax number
    --- @return number
    scale = function (s, smin, smax, tmin, tmax)
        return ((s - smin) / (smax - smin)) * (tmax - tmin) + tmin
    end
}

--- make a new plotter, filling the provided window
--- @param win window
function Plotter:constructor(win)
    self.box = pixelbox2.new(win)
end

--- draw a line using canvas coordinates. OOB pixels will be processed, but not drawn.
---@param x1 integer start x
---@param y1 integer start y
---@param x2 integer end x
---@param y2 integer end y
---@param color colors drawing color
function Plotter:drawLine(x1, y1, x2, y2, color)
    self:drawLineSometimes(x1, y1, x2, y2, color, 1, 0)
end

--- draw a line using canvas coordinates, with specified on/off pattern. OOB pixels
--- will be processed, but not drawn. returns next pattern offset
---@param x1 integer start x
---@param y1 integer start y
---@param x2 integer end x
---@param y2 integer end y
---@param color colors drawing color
---@param onrate integer consecutive on pixels
---@param offrate? integer consecutive off pixels, defaults to onrate
---@param oncount? integer offset for on pixels, defaults to 0
---@param offcount? integer offset for off pixels, defaults to 0
---@return integer oncount next oncount
---@return integer offcount next offcount
function Plotter:drawLineSometimes(x1, y1, x2, y2, color, onrate, offrate, oncount, offcount)
    if not offrate then offrate = onrate end

    if not oncount then oncount = 0 end
    if not offcount then offcount = 0 end

    local dx = math.abs(x2 - x1)
    local dy = -math.abs(y2 - y1)
    local sx = x1 < x2 and 1 or -1
    local sy = y1 < y2 and 1 or -1
    local err = dx + dy

    while true do
        -- don't draw OOB, but continue processing the line
        if x1 < 1 or y1 < 1 or x1 > self.box.width or y1 > self.box.height then
            -- no draw
        else
            if onrate > 0 and offrate == 0 then
                self.box:set_pixel(x1, y1, color)
            else
                if oncount < onrate then
                    self.box:set_pixel(x1, y1, color)

                    oncount = oncount + 1
                elseif offcount < offrate then
                    -- skip pixel
                    offcount = offcount + 1
                else
                    self.box:set_pixel(x1, y1, color)

                    oncount = 1
                    offcount = 0
                end
            end
        end

        if x1 == x2 and y1 == y2 then
            break
        end

        local e2 = 2 * err

        if e2 > dy then
            err = err + dy
            x1 = x1 + sx
        end

        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end

    return oncount, offcount
end

--- draw a line using canvas coordinates, filling the vertical space
--- between the line and a baseline
---@param x1 integer start x
---@param y1 integer start y
---@param x2 integer end x
---@param y2 integer end y
---@param yfrom integer y level for area baseline. the space between this y level and the drawn line will be filled
---@param color colors drawing color
function Plotter:drawAreaLine(x1, y1, x2, y2, yfrom, color)
    self:drawAreaLineSometimes(x1, y1, x2, y2, yfrom, color, 1, 0)
end

--- draw a line using canvas coordinates, filling the vertical space
--- between the line and a baseline, with specified on/off pattern.
---@param x1 integer start x
---@param y1 integer start y
---@param x2 integer end x
---@param y2 integer end y
---@param yfrom integer y level for area baseline. the space between yfrom and the drawn line will be filled
---@param color colors drawing color
---@param onrate integer consecutive on pixels
---@param offrate? integer consecutive off pixels, defaults to onrate
---@param oncount? integer offset for on pixels, defaults to 0
---@param offcount? integer offset for off pixels, defaults to 0
---@return integer oncount next oncount
---@return integer offcount next offcount
function Plotter:drawAreaLineSometimes(x1, y1, x2, y2, yfrom, color, onrate, offrate, oncount, offcount)
    if not offrate then offrate = onrate end

    if not oncount then oncount = 0 end
    if not offcount then offcount = 0 end

    local dx = math.abs(x2 - x1)
    local dy = -math.abs(y2 - y1)
    local sx = x1 < x2 and 1 or -1
    local sy = y1 < y2 and 1 or -1
    local err = dx + dy

    while true do
        if onrate > 0 and offrate == 0 then
            self:drawLineSometimes(x1, y1, x1, yfrom, color, onrate, offrate)
        else
            if oncount < onrate then
                self:drawLineSometimes(x1, y1, x1, yfrom, color, onrate, offrate)

                oncount = oncount + 1
            elseif offcount < offrate then
                -- skip pixel
                offcount = offcount + 1
            else
                self:drawLineSometimes(x1, y1, x1, yfrom, color, onrate, offrate)

                oncount = 1
                offcount = 0
            end
        end

        if x1 == x2 and y1 == y2 then
            break
        end

        local e2 = 2 * err

        if e2 > dy then
            err = err + dy
            x1 = x1 + sx
        end

        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end

    return oncount, offcount
end

--- draw a box using canvas coordinates
---@param x1 integer start x
---@param y1 integer start y
---@param x2 integer end x
---@param y2 integer end y
---@param color colors drawing color
function Plotter:drawBox(x1, y1, x2, y2, color)
    self:drawBoxSometimes(x1, y1, x2, y2, color, 1, 0)
end

--- draw a box using canvas coordinates, with specified on/off pattern.
--- returns next pattern offset. lines are drawn in a circular fashion
---@param x1 integer start x
---@param y1 integer start y
---@param x2 integer end x
---@param y2 integer end y
---@param color colors drawing color
---@param onrate integer consecutive on pixels
---@param offrate? integer consecutive off pixels, defaults to onrate
---@param oncount? integer offset for on pixels, defaults to 0
---@param offcount? integer offset for off pixels, defaults to 0
function Plotter:drawBoxSometimes(x1, y1, x2, y2, color, onrate, offrate, oncount, offcount)
    if not offrate then offrate = onrate end

    if not oncount then oncount = 0 end
    if not offcount then offcount = 0 end

    oncount, offcount = self:drawLineSometimes(x1, y1, x2 - 1, y1, color, onrate, offrate, oncount, offcount)
    oncount, offcount = self:drawLineSometimes(x2, y1, x2, y2 - 1, color, onrate, offrate, oncount, offcount)
    oncount, offcount = self:drawLineSometimes(x2, y2, x1 + 1, y2, color, onrate, offrate, oncount, offcount)
    oncount, offcount = self:drawLineSometimes(x1, y2, x1, y1 + 1, color, onrate, offrate, oncount, offcount)
end

--- fill a box using canvas coordinates
---@param x1 integer start x
---@param y1 integer start y
---@param x2 integer end x
---@param y2 integer end y
---@param color colors drawing color
function Plotter:fillBox(x1, y1, x2, y2, color)
    for x = x1, x2 do
        for y = y1, y2 do
            self.box:set_pixel(x, y, color)
        end
    end
end

--- plot one-dimensional data as a line in scaled coordinates, where
--- the data index is used as the horizontal axis
--- @param data table data to plot. index = x, value = y
--- @param dataw integer number of data indexes to fit in the plot area (left to right)
--- @param miny number minimum of data values to fit in the plot area (bottom)
--- @param maxy number maximum of data values to fit in the plot area (top)
--- @param color colors drawing color
function Plotter:chartLine(data, dataw, miny, maxy, color)
    local boxminx = 1
    local boxmaxx = self.box.width
    local boxminy = 1
    local boxmaxy = self.box.height

    local lastx, lasty

    for x, y in ipairs(data) do
        -- plotter.NAN values are not charted
        if y == self.NAN then
            lasty = nil
        else
            local nextx = self.math.round(self.math.scale(x, 1, dataw, boxminx, boxmaxx))
            local nexty = 1 + boxmaxy - self.math.round(self.math.scale(y, miny, maxy, boxminy, boxmaxy))

            if nextx < boxminx or nexty < boxminy or nextx > boxmaxx or nexty > boxmaxy then
                -- do nothing for OOB points
            else
                if type(lasty) == 'nil' then
                    self:drawLine(nextx, nexty, nextx, nexty, color)

                    lastx = nextx
                    lasty = nexty
                else
                    self:drawLine(lastx, lasty, nextx, nexty, color)
                    
                    lastx = nextx
                    lasty = nexty
                end
            end
        end
    end
end

--- plot one-dimensional data as a line in scaled coordinates, where
--- the data index is used as the horizontal axis. chart will scale
--- data indexes to fit all provided data.
--- @param data table data to plot. index = x, value = y
--- @param color colors drawing color
function Plotter:chartLineAuto(data, color)
    local dataw = #data

    local actualmin, actualmax = math.huge, -math.huge

    for _, v in ipairs(data) do
        -- skip NAN
        if v ~= self.NAN then
            if v < actualmin then actualmin = v end
            if v > actualmax then actualmax = v end
        end
    end

    -- center static data
    if actualmin == actualmax then
        actualmin = actualmin - self.RANGE_MIN / 2
        actualmax = actualmax + self.RANGE_MIN / 2
    end

    self:chartLine(data, dataw, actualmin, actualmax, color)

    return actualmin, actualmax
end

--- plot one-dimensional data as an area in scaled coordinates, where
--- the data index is used as the horizontal axis
--- @param data table data to plot. index = x, value = y
--- @param dataw integer number of data indexes to fit in the plot area (left to right)
--- @param miny number minimum of data values to fit in the plot area (bottom)
--- @param maxy number maximum of data values to fit in the plot area (top)
--- @param areay number data value to use as baseline for area fill. larger values will fill towards -y, smaller values will fill towards +y.
--- @param color colors drawing color
function Plotter:chartArea(data, dataw, miny, maxy, areay, color)
    local boxminx = 1
    local boxmaxx = self.box.width
    local boxminy = 1
    local boxmaxy = self.box.height

    local lastx, lasty

    for x, y in ipairs(data) do
        -- plotter.NAN values are not charted
        if y == self.NAN then
            lasty = nil
        else
            local nextx = self.math.round(self.math.scale(x, 1, dataw, boxminx, boxmaxx))
            local nexty = 1 + boxmaxy - self.math.round(self.math.scale(y, miny, maxy, boxminy, boxmaxy))
            local nextareay = 1 + boxmaxy - self.math.round(self.math.scale(areay, miny, maxy, boxminy, boxmaxy))

            if nextareay > boxmaxy then nextareay = boxmaxy end
            if nextareay < boxminy then nextareay = boxminy end

            if nextx < boxminx or nexty < boxminy or nextx > boxmaxx or nexty > boxmaxy then
                -- do nothing for OOB points
            else
                if type(lasty) == 'nil' then
                    self:drawAreaLine(nextx, nexty, nextx, nexty, nextareay, color)

                    lastx = nextx
                    lasty = nexty
                else
                    self:drawAreaLine(lastx, lasty, nextx, nexty, nextareay, color)

                    lastx = nextx
                    lasty = nexty
                end
            end
        end
    end
end

--- plot one-dimensional data as an area in scaled coordinates, where
--- the data index is used as the horizontal axis. chart will scale
--- data indexes to fit all provided data.
--- @param data table data to plot. index = x, value = y
--- @param areay number data value to use as baseline for area fill. larger values will fill towards -y, smaller values will fill towards +y.
--- @param color colors drawing color
function Plotter:chartAreaAuto(data, areay, color)
    local dataw = #data

    local actualmin, actualmax = math.huge, -math.huge

    for _, v in ipairs(data) do
        -- skip NAN
        if v ~= self.NAN then
            if v < actualmin then actualmin = v end
            if v > actualmax then actualmax = v end
        end
    end

    -- center static data
    if actualmin == actualmax then
        actualmin = actualmin - self.RANGE_MIN / 2
        actualmax = actualmax + self.RANGE_MIN / 2
    end

    self:chartArea(data, dataw, actualmin, actualmax, areay, color)

    return actualmin, actualmax
end

--- plot two-dimensional data as points in scaled coordinates, where
--- the data is a table of {x, y} pairs.
--- @param data table data to plot. at each index: {x, y}
--- @param minx number minimum of data values to fit in the plot area (left)
--- @param maxx number maximum of data values to fit in the plot area (right)
--- @param miny number minimum of data values to fit in the plot area (bottom)
--- @param maxy number maximum of data values to fit in the plot area (top)
--- @param color colors drawing color
function Plotter:chartXY(data, minx, maxx, miny, maxy, color)
    local boxminx = 1
    local boxmaxx = self.box.width
    local boxminy = 1
    local boxmaxy = self.box.height

    for _, v in ipairs(data) do
        local x, y = table.unpack(v)

        local nextx = self.math.round(self.math.scale(x, minx, maxx, boxminx, boxmaxx))
        local nexty = 1 + boxmaxy - self.math.round(self.math.scale(y, miny, maxy, boxminy, boxmaxy))

        if nextx < boxminx or nexty < boxminy or nextx > boxmaxx or nexty > boxmaxy then
            -- do nothing for OOB points
        else
            self:drawLine(nextx, nexty, nextx, nexty, color)
        end
    end
end

function Plotter:chartGrid(dataw, miny, maxy, xOffset, color, styles)
    local xGap, yLinesMin, yLinesFactor = 10, 5, 2

    if not color then color = colors.gray end

    -- override grid styles
    if type(styles) == 'table' then
        xGap = styles.xGap or xGap
        yLinesMin = styles.yLinesMin or yLinesMin
        yLinesFactor = styles.yLinesFactor or yLinesFactor
    end

    local gridData = {}

    local yPow = math.floor(math.log(maxy - miny, yLinesFactor))

    local ySpace = yLinesFactor ^ yPow / yLinesMin

    local yOffset = miny % ySpace

    for x = xOffset + 1, dataw, xGap do
        for y = miny - yOffset, maxy, ySpace do
            table.insert(gridData, {x, y})
        end
    end

    self:chartXY(gridData, 1, dataw, miny, maxy, color)
end

--- clear plot using specified color
--- @param color colors
function Plotter:clear(color)
    self.box:clear(color)
end

--- render plot
function Plotter:render()
    self.box:render()
end

return Plotter