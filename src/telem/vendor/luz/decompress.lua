local token_decode_tree = {{":name",{{",",":repeat0"},{"=",{"(",")"}}}},{{{{".",":number"},{":repeat1",":repeat2"}},{{":string","end"},{"local",{":repeat3",":repeat4"}}}},{{{{"if","then"},{{"+","-"},{"0","1"}}},{{{":repeat5",":repeat6"},{"==","["}},{{"]","do"},{"function","return"}}}},{{{{"{","}"},{{"#","*"},{"..","2"}}},{{{":",":repeat7"},{":repeat8","and"}},{{"else","for"},{"nil","or"}}}},{{{{"self","~="},{{"\"\"","/"},{":repeat10",":repeat9"}}},{{{";","<"},{">","elseif"}},{{"false","not"},{"string","true"}}}},{{{{"type",{"%","-1"}},{{"...",":repeat11"},{"<=",">="}}},{{{"error","in"},{"math","os"}},{{"print","sub"},{"table","while"}}}},{{{{{"\"number\"","\"string\""},{"\"table\"",":repeat12"}},{{":repeat13","_"},{"_G","bit32"}}},{{{"break","close"},{"coroutine","find"}},{{"ipairs","match"},{"open","pairs"}}}},{{{{"read","require"},{"setmetatable","tonumber"}},{{"tostring","unpack"},{"write",{"\"function\"","\"nil\""}}}},{{{{"\"r\"","\"w\""},{"^","_ENV"}},{{"__index","debug"},{"getmetatable","gsub"}}},{{{"io","package"},{"pcall","repeat"}},{{"select","until"},{{"\"boolean\"","__newindex"},{"load",{":end","__call"}}}}}}}}}}}}}}

local rshift, lshift, band = bit32.rshift, bit32.lshift, bit32.band
local byte, char = string.byte, string.char
local concat, unpack = table.concat, unpack or table.unpack
local min = math.min

local ORDER = {17, 18, 19, 1, 9, 8, 10, 7, 11, 6, 12, 5, 13, 4, 14, 3, 15, 2, 16}
local NBT = {2, 3, 7}
local CNT  = {144, 112, 24, 8}
local DPT = {8, 9, 7, 8}
local STATIC_HUFFMAN = {[0] = 5, 261, 133, 389, 69, 325, 197, 453, 37, 293, 165, 421, 101, 357, 229, 485, 21, 277, 149, 405, 85, 341, 213, 469, 53, 309, 181, 437, 117, 373, 245, 501}
local STATIC_BITS = 5
local b64str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
local b64lut = {}
for i = 1, #b64str do b64lut[string.char(i-1)] = b64str:sub(i, i) end

local function flushBits(stream, int)
    stream.bits = rshift(stream.bits, int)
    stream.count = stream.count - int
end

local function peekBits(stream, int)
    local buffer, bits, count, position = stream.buffer, stream.bits, stream.count, stream.position
    while count < int do
        if position > #buffer then return nil end
        bits = bits + lshift(byte(buffer, position), count)
        position = position + 1
        count = count + 8
    end
    stream.bits = bits
    stream.position = position
    stream.count = count
    return band(bits, lshift(1, int) - 1)
end

local function getBits(stream, int)
    local result = peekBits(stream, int)
    stream.bits = rshift(stream.bits, int)
    stream.count = stream.count - int
    return result
end

local function peekBitsR(stream, int)
    local buffer, bits, count, position = stream.buffer, stream.bits, stream.count, stream.position
    while count < int do
        if position > #buffer then return nil end
        bits = lshift(bits, 8) + byte(buffer, position)
        position = position + 1
        count = count + 8
    end
    stream.bits = bits
    stream.position = position
    stream.count = count
    return band(rshift(bits, count - int), lshift(1, int) - 1)
end

local function getBitsR(stream, int)
    local result = peekBitsR(stream, int)
    --stream.bits = rshift(stream.bits, int)
    stream.count = stream.count - int
    return result
end

local function getElement(stream, hufftable, int)
    local element = hufftable[peekBits(stream, int)]
    if not element then return nil end
    local length = band(element, 15)
    local result = rshift(element, 4)
    stream.bits = rshift(stream.bits, length)
    stream.count = stream.count - length
    return result
end

local function huffman(depths)
    local size = #depths
    local blocks, codes, hufftable = {[0] = 0}, {}, {}
    local bits, code = 1, 0
    for i = 1, size do
        local depth = depths[i]
        if depth > bits then
            bits = depth
        end
        blocks[depth] = (blocks[depth] or 0) + 1
    end
    for i = 1, bits do
        code = (code + (blocks[i - 1] or 0)) * 2
        codes[i] = code
    end
    for i = 1, size do
        local depth = depths[i]
        if depth > 0 then
            local element = (i - 1) * 16 + depth
            local rcode = 0
            for j = 1, depth do
                rcode = rcode + lshift(band(1, rshift(codes[depth], j - 1)), depth - j)
            end
            for j = 0, 2 ^ bits - 1, 2 ^ depth do
                hufftable[j + rcode] = element
            end
            codes[depth] = codes[depth] + 1
        end
    end
    return hufftable, bits
end

local function loop(output, stream, litTable, litBits, distTable, distBits)
    local index = #output + 1
    local lit
    repeat
        lit = getElement(stream, litTable, litBits)
        if not lit then return nil end
        if lit < 256 then
            output[index] = lit
            index = index + 1
        elseif lit > 256 then
            local bits, size, dist = 0, 3, 1
            if lit < 265 then
                size = size + lit - 257
            elseif lit < 285 then
                bits = rshift(lit - 261, 2)
                size = size + lshift(band(lit - 261, 3) + 4, bits)
            else
                size = 258

            end
            if bits > 0 then
                size = size + getBits(stream, bits)
            end
            local element = getElement(stream, distTable, distBits)
            if element < 4 then
                dist = dist + element
            else
                bits = rshift(element - 2, 1)
                dist = dist + lshift(band(element, 1) + 2, bits) + getBits(stream, bits)
            end
            local position = index - dist
            repeat
                output[index] = output[position] or 0
                index = index + 1
                position = position + 1
                size = size - 1
            until size == 0
        end
    until lit == 256
end

local function dynamic(output, stream)
    local n = getBits(stream, 5)
    if not n then return nil end
    local lit, dist, length = 257 + n, 1 + getBits(stream, 5), 4 + getBits(stream, 4)
    local depths = {}
    for i = 1, length do
        depths[ORDER[i]] = getBits(stream, 3)
    end
    for i = length + 1, 19 do
        depths[ORDER[i]] = 0
    end
    local lengthTable, lengthBits = huffman(depths)
    local i = 1
    local total = lit + dist + 1
    repeat
        local element = getElement(stream, lengthTable, lengthBits)
        if element < 16 then
            depths[i] = element
            i = i + 1
        elseif element < 19 then
            local int = NBT[element  - 15]
            local count = 0
            local num = 3 + getBits(stream, int)
            if element == 16 then
                count = depths[i - 1]
            elseif element == 18 then
                num = num + 8
            end
            for _ = 1, num do
                depths[i] = count
                i = i + 1
            end
        end
    until i == total
    local litDepths, distDepths = {}, {}
    for j = 1, lit do
        litDepths[j] = depths[j]
    end
    for j = lit + 1, #depths do
        distDepths[#distDepths + 1] = depths[j]
    end
    local litTable, litBits = huffman(litDepths)
    local distTable, distBits = huffman(distDepths)
    loop(output, stream, litTable, litBits, distTable, distBits)
end

local function static(output, stream)
    local depths = {}
    for i = 1, 4 do
        local depth = DPT[i]
        for _ = 1, CNT[i] do
            depths[#depths + 1] = depth
        end
    end
    local litTable, litBits = huffman(depths)
    loop(output, stream, litTable, litBits, STATIC_HUFFMAN, STATIC_BITS)
end

local function uncompressed(output, stream)
    flushBits(stream, band(stream.count, 7))
    local length = getBits(stream, 16); getBits(stream, 16)
    if not length then return nil end
    local buffer, position = stream.buffer, stream.position
    for i = position, position + length - 1 do
        output[#output + 1] = byte(buffer, i, i)
    end
    stream.position = position + length
end

local function varint(stream)
    local num = 0
    repeat
        local n = getBitsR(stream, 8)
        num = num * 128 + n % 128
    until n < 128
    return num
end

local function number(stream)
    local type = getBitsR(stream, 2)
    if type >= 2 then
        local esign = getBitsR(stream, 1)
        local e = 0
        repeat
            local n = getBitsR(stream, 4)
            e = lshift(e, 3) + band(n, 7)
        until n < 8
        if esign == 1 then e = -e end
        local m = varint(stream) / 0x20000000000000 + 0.5
        return math.ldexp(m, e) * (type == 2 and 1 or -1)
    else
        return varint(stream) * (type == 0 and 1 or -1)
    end
end

local rlemap = {2, 6, 22}

local function readrle(stream, len)
    local bits = getBitsR(stream, 2)
    if bits == 0 then return 1, getBitsR(stream, len) end
    local rep = getBitsR(stream, bits * 2) + rlemap[bits]
    return rep, getBitsR(stream, len)
end

local function nametree(stream, list)
    -- read identifier code lengths
    local maxlen = getBitsR(stream, 4)
    if maxlen == 0 then
        if getBitsR(stream, 1) == 0 then return nil
        else return varint(stream) end
    end
    local bitlen = {}
    local n, c = 0
    for i = 1, #list do
        if n == 0 then
            n, c = readrle(stream, maxlen)
            --print(n, c)
        end
        if c > 0 then bitlen[#bitlen+1] = {s = list[i], l = c} end
        n = n - 1
    end
    assert(n == 0, n)
    table.sort(bitlen, function(a, b) if a.l == b.l then return a.s < b.s else return a.l < b.l end end)
    bitlen[1].c = 0
    for j = 2, #bitlen do bitlen[j].c = bit32.lshift(bitlen[j-1].c + 1, bitlen[j].l - bitlen[j-1].l) end
    -- create tree from codes
    local codetree = {}
    for j = 1, #bitlen do
        local c = bitlen[j].c
        local node = codetree
        for k = bitlen[j].l - 1, 1, -1 do
            local n = bit32.extract(c, k, 1)
            if not node[n+1] then node[n+1] = {} end
            node = node[n+1]
        end
        local n = bit32.extract(c, 0, 1)
        node[n+1] = bitlen[j].s
    end
    return codetree
end

local function decompress(data)
    if data:sub(1, 5) ~= "\27LuzQ" then error("invalid format", 2) end
    -- deflate string table
    local self = {buffer = data, position = 6, bits = 0, count = 0}
    local stringtable, identliststr
    do
        local output, buffer = {}, {}
        local last, typ
        repeat
            last, typ = getBits(self, 1), getBits(self, 2)
            if not last or not typ then break end
            typ = typ == 0 and uncompressed(output, self) or typ == 1 and static(output, self) or typ == 2 and dynamic(output, self)
        until last == 1
        local size = #output
        for i = 1, size, 4096 do
            buffer[#buffer + 1] = char(unpack(output, i, min(i + 4095, size)))
        end
        stringtable = concat(buffer)
        if self.count % 8 > 0 then flushBits(self, self.count % 8) end
    end
    -- deflate identifier list
    do
        local output, buffer = {}, {}
        local last, typ
        repeat
            last, typ = getBits(self, 1), getBits(self, 2)
            if not last or not typ then break end
            typ = typ == 0 and uncompressed(output, self) or typ == 1 and static(output, self) or typ == 2 and dynamic(output, self)
        until last == 1
        local size = #output
        for i = 1, size, 4096 do
            buffer[#buffer + 1] = char(unpack(output, i, min(i + 4095, size)))
        end
        identliststr = concat(buffer)
        if self.count % 8 > 0 then flushBits(self, self.count % 8) end
    end
    -- split identifiers
    local identifiers = {}
    for ident in identliststr:gmatch "([%z\1-\62]+)\63" do identifiers[#identifiers+1] = ident:gsub(".", b64lut) end
    -- read distance & identifier code lengths
    local disttree = nametree(self, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29})
    local codetree = nametree(self, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29})
    local tokentree
    if getBitsR(self, 1) == 1 then
        local tokenlist, m = {}, {}
        local function extract(node)
            if type(node) == "string" then tokenlist[#tokenlist+1], m[node] = node, true
            else extract(node[1]) extract(node[2]) end
        end
        extract(token_decode_tree)
        for i = 0, 29 do if not m[":repeat" .. i] then tokenlist[#tokenlist+1] = ":repeat" .. i end end
        table.sort(tokenlist)
        tokentree = nametree(self, tokenlist)
    else tokentree = token_decode_tree end
    -- read tokens
    local stringpos, namepos = 1, 1
    local tokens = {}
    local namelist = {}
    while true do
        local node = tokentree
        while type(node) == "table" do node = node[getBitsR(self, 1)+1] end
        if node == ":end" then break
        elseif node == ":name" then
            node = codetree
            while type(node) == "table" do node = node[getBitsR(self, 1)+1] end
            local ebits, distcode = math.max(math.floor(node / 2) - 1, 0)
            if ebits > 0 then
                local extra = getBitsR(self, ebits)
                distcode = bit32.bor(extra, bit32.lshift(bit32.band(node, 1) + 2, ebits))
            else distcode = node end
            if distcode == 0 then
                tokens[#tokens+1] = identifiers[namepos]
                table.insert(namelist, 1, identifiers[namepos])
                namepos = namepos + 1
            else
                local name = table.remove(namelist, distcode)
                tokens[#tokens+1] = name
                table.insert(namelist, 1, name)
            end
        elseif node == ":string" then
            local len = varint(self)
            tokens[#tokens+1] = ("%q"):format(stringtable:sub(stringpos, stringpos + len - 1)):gsub("\\?\n", "\\n"):gsub("\t", "\\t"):gsub("[%z\1-\31\127-\255]", function(n) return ("\\%03d"):format(n:byte()) end)
            stringpos = stringpos + len
        elseif node == ":number" then
            tokens[#tokens+1] = tostring(number(self))
        elseif node:find "^:repeat" then
            local lencode = tonumber(node:match "^:repeat(%d+)")
            local ebits = math.max(math.floor(lencode / 2) - 1, 0)
            if ebits > 0 then
                local extra = getBitsR(self, ebits)
                lencode = bit32.bor(extra, bit32.lshift(bit32.band(lencode, 1) + 2, ebits)) + 3
            else lencode = lencode + 3 end
            node = disttree
            while type(node) == "table" do node = node[getBitsR(self, 1)+1] end
            local distcode
            ebits = math.max(math.floor(node / 2) - 1, 0)
            if ebits > 0 then
                local extra = getBitsR(self, ebits)
                distcode = bit32.bor(extra, bit32.lshift(bit32.band(node, 1) + 2, ebits)) + 1
            else distcode = node + 1 end
            for _ = 1, lencode do tokens[#tokens+1] = tokens[#tokens-distcode+1] end
        else tokens[#tokens+1] = node end
    end
    -- create source
    local retval = ""
    local lastchar, lastdot = false, false
    for _, v in ipairs(tokens) do
        if (lastchar and v:match "^[A-Za-z0-9_]") or (lastdot and v:match "^%.") then retval = retval .. " " end
        retval = retval .. v
        lastchar, lastdot = v:match "[A-Za-z0-9_]$", v:match "%.$"
    end
    return retval
end

return decompress