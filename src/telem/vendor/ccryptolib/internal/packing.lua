--- High-performance binary packing of integers.
---
--- Remark (and warning):
--- For performance reasons, **the generated functions do not check types,
--- lengths, nor ranges**. You must ensure that the passed arguments are
--- well-formed and respect the format string yourself.

local fmt = string.format

local function mkPack(words, BE)
    local out = "local C=string.char return function(_,"
    local nb = 0
    for i = 1, #words do
        out = out .. fmt("n%d,", i)
        nb = nb + words[i]
    end
    out = out:sub(1, -2) .. ")local "
    for i = 1, nb do
        out = out .. fmt("b%d,", i)
    end
    out = out:sub(1, -2) .. " "
    local bi = 1
    for i = 1, #words do
        for _ = 1, words[i] - 1 do
            out = out .. fmt("b%d=n%d%%2^8 n%d=(n%d-b%d)*2^-8 ", bi, i, i, i, bi)
            bi = bi + 1
        end
        bi = bi + 1
    end
    out = out .. "return C("
    bi = 1
    if not BE then
        for i = 1, #words do
            for _ = 1, words[i] - 1 do
                out = out .. fmt("b%d,", bi)
                bi = bi + 1
            end
            out = out .. fmt("n%d%%2^8,", i)
            bi = bi + 1
        end
    else
        for i = 1, #words do
            out = out .. fmt("n%d%%2^8,", i)
            bi = bi + words[i] - 2
            for _ = 1, words[i] - 1 do
                out = out .. fmt("b%d,", bi)
                bi = bi - 1
            end
            bi = bi + words[i] + 1
        end
    end
    out = out:sub(1, -2) .. ")end"
    return load(out)()
end

local function mkUnpack(words, BE)
    local out = "local B=string.byte return function(_,s,i)local "
    local bi = 1
    if not BE then
        for i = 1, #words do
            for _ = 1, words[i] do
                out = out .. fmt("b%d,", bi)
                bi = bi + 1
            end
        end
    else
        for i = 1, #words do
            bi = bi + words[i] - 1
            for _ = 1, words[i] do
                out = out .. fmt("b%d,", bi)
                bi = bi - 1
            end
            bi = bi + words[i] + 1
        end
    end
    out = out:sub(1, -2) .. fmt("=B(s,i,i+%d)return ", bi - 2)
    bi = 1
    for i = 1, #words do
        out = out .. fmt("b%d", bi)
        bi = bi + 1
        for j = 2, words[i] do
            out = out .. fmt("+b%d*2^%d", bi, 8 * j - 8)
            bi = bi + 1
        end
        out = out .. ","
    end
    out = out .. fmt("i+%d end", bi - 1)
    return load(out)()
end

-- Check whether string.pack is implemented in a high-speed language.
if not string.pack or pcall(string.dump, string.pack) then
    local function compile(fmt, fn)
        local e = assert(fmt:match("^([><])I[I%d]+$"), "invalid format string")
        local w = {}
        for i in fmt:gmatch("I([%d]+)") do
            local n = tonumber(i) or 4
            assert(n > 0 and n <= 16, "integral size out of limits")
            w[#w + 1] = n
        end
        return fn(w, e == ">")
    end

    local packCache = {}
    local unpackCache = {}

    -- I CAN'T EVEN WITH THIS EXTENSION, WHY CAN'T IT HANDLE MORE THAN A SINGLE
    -- LINE OF RETURN DESCRIPTION? LOOK AT IT!!! THE COMMENT GOES OVER THERE ------------------------------------------------------------------> look! ↓ ↓ ↓

    --- (string.pack is nil) Compiles a binary packing function.
    ---
    --- Errors if the format string is invalid or has an invalid integral size,
    --- or if the compiled function turns out too large.
    ---
    --- @param fmt string A string matched by `^([><])I[I%d]+$`.
    --- @return fun(_ignored: any, ...: any): string pack A function that behaves like an unsafe version of `string.pack` for the given format string.
    --- @return string fmt
    local function compilePack(fmt)
        if not packCache[fmt] then
            packCache[fmt] = compile(fmt, mkPack)
        end
        return packCache[fmt], fmt
    end

    --- (string.pack is nil) Compiles a binary unpacking function.
    ---
    --- Errors if the format string is invalid or has an invalid integral size,
    --- or if the compiled function turns out too large.
    ---
    --- @param fmt string A string matched by `^([><])I[I%d]+$`.
    --- @return fun(_ignored: any, str: string, pos: number) unpack A function that behaves like an unsafe version of `string.unpack` for the given format string. Note that the third argument isn't optional.
    --- @return string fmt
    local function compileUnpack(fmt)
        if not unpackCache[fmt] then
            unpackCache[fmt] = compile(fmt, mkUnpack)
        end
        return unpackCache[fmt], fmt
    end

    return {
        compilePack = compilePack,
        compileUnpack = compileUnpack,
    }
else
    --- (string.pack isn't nil) It's string.pack! It returns string.pack!
    --- @param fmt string
    --- @return fun(fmt: string, ...: any): string pack string.pack!
    --- @return string fmt
    local function compilePack(fmt) return string.pack, fmt end

    --- (string.pack isn't nil) It's string.unpack! It returns string.unpack!
    --- @param fmt string
    --- @return fun(fmt: string, str: string, pos: number) unpack string.unpack!
    --- @return string fmt
    local function compileUnpack(fmt) return string.unpack, fmt end

    return {
        compilePack = compilePack,
        compileUnpack = compileUnpack,
    }
end
