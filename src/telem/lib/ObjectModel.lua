--
-- Lua object model implementation
--
-- By Shira-3749
-- Source: https://github.com/Shira-3749/lua-object-model
--

local a='Lua 5.1'==_VERSION;local unpack=unpack or table.unpack;local function b(c,...)local d={}setmetatable(d,c)if c.constructor then c.constructor(d,...)end;return d end;local function e(d,f,...)if nil==d.___superScope then d.___superScope={}end;local g=d.___superScope[f]local h;if nil~=g then h=g.__parent else h=d.__parent end;d.___superScope[f]=h;local i={pcall(h[f],d,...)}local j=table.remove(i,1)d.___superScope[f]=g;if not j then error(i[1])end;return unpack(i)end;local function k(d,l)local c=getmetatable(d)while c do if c==l then return true end;c=c.__parent end;return false end;local function m(d)if d.destructor then d:destructor()end end;local function c(n)local c={}if n then for o,p in pairs(n)do c[o]=p end;c.__parent=n end;c.__index=c;if not n and not a then c.__gc=m end;if n then c.super=e end;local q={__call=b}setmetatable(c,q)return c end;return{class=c,instanceof=k,new=b,super=e}