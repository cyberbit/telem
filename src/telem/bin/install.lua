-- Telem Installer by cyberbit
-- MIT License
-- Version 2026-07-19

local pretty = require 'cc.pretty'
local pprint = pretty.pretty_print
local prender = function (data)
    return pretty.render(pretty.pretty(data))
end

local dryRun = false

local termW, termH = term.getSize()

local boxSizing = {
    mainPadding = 2
}

boxSizing.contentBox = termW - boxSizing.mainPadding * 2 + 1
boxSizing.borderBox = boxSizing.contentBox - 1

local curt = term.current

local ObjectModel = (function ()
    ---@diagnostic disable: deprecated
    --
    -- Lua object model implementation
    --
    -- By Shira-3749
    -- Source: https://github.com/Shira-3749/lua-object-model
    --

    local a='Lua 5.1'==_VERSION;local unpack=unpack or table.unpack;local function b(c,...)local d={}setmetatable(d,c)if c.constructor then c.constructor(d,...)end;return d end;local function e(d,f,...)if nil==d.___superScope then d.___superScope={}end;local g=d.___superScope[f]local h;if nil~=g then h=g.__parent else h=d.__parent end;d.___superScope[f]=h;local i={pcall(h[f],d,...)}local j=table.remove(i,1)d.___superScope[f]=g;if not j then error(i[1])end;return unpack(i)end;local function k(d,l)local c=getmetatable(d)while c do if c==l then return true end;c=c.__parent end;return false end;local function m(d)if d.destructor then d:destructor()end end;local function c(n)local c={}if n then for o,p in pairs(n)do c[o]=p end;c.__parent=n end;c.__index=c;if not n and not a then c.__gc=m end;if n then c.super=e end;local q={__call=b}setmetatable(c,q)return c end;return{class=c,instanceof=k,new=b,super=e}
end)()

local function httpGetRedirect(url, headers, binary)
    local maxRedirects = 5
    local redirects = 0

    while redirects < maxRedirects do
        local res, err, errRes = http.get(url, headers, binary)

        if not res then
            return nil, err, errRes
        end

        local statusCode = res.getResponseCode()

        if statusCode >= 300 and statusCode < 400 then
            local location = res.getResponseHeaders()['Location']

            if not location then
                return nil, 'Redirect location not provided'
            end

            url = location
            redirects = redirects + 1
        else
            return res
        end
    end

    return nil, 'Too many redirects'
end

local REST = (function ()
    local REST = ObjectModel.class()
    
    function REST:constructor()
        self.headers = {}
        self.baseURL = nil
    end
    
    function REST:setBaseURL(url)
        self.baseURL = url

        return self
    end
    
    function REST:setHeaders(headers)
        for k,v in pairs(headers) do
            self.headers[k] = v
        end

        return self
    end
    
    function REST:get(url, headers)
        if headers then
            self:setHeaders(headers)
        end
    
        local res, err, errRes = httpGetRedirect(self.baseURL .. url, self.headers, true)
    
        if not res then
            return res, err, errRes
        end
    
        local body = res.readAll()
        res.close()

        return textutils.unserializeJSON(body)
    end
    
    return REST
end)()

local ui = (function ()
    -- PrimeUI by JackMacWindows
    -- Public domain/CC0
    -- Packaged from https://github.com/MCJack123/PrimeUI

    local a=require"cc.expect".expect;local b={}
    do local c={}local d;
        function b.addTask(e)a(1,e,"function")local f={coro=coroutine.create(e)}c[#c+1]=f;_,f.filter=coroutine.resume(f.coro)end;
        function b.resolve(...)coroutine.yield(c,...)end;
        function b.clear()term.setCursorPos(1,1)term.setCursorBlink(false)term.setBackgroundColor(colors.black)term.setTextColor(colors.white)term.clear()c={}d=nil end;
        function b.setCursorWindow(g)a(1,g,"table","nil")d=g and g.restoreCursor end;
        function b.getWindowPos(g,h,i)if g==term then return h,i end;while g~=term.native()and g~=term.current()do if not g.getPosition then return h,i end;local j,k=g.getPosition()h,i=h+j-1,i+k-1;_,g=debug.getupvalue(select(2,debug.getupvalue(g.isColor,1)),1)end;return h,i end;
        function b.run()while true do if d then d()end;local l=table.pack(os.pullEvent())for _,m in ipairs(c)do if m.filter==nil or m.filter==l[1]then local n=table.pack(coroutine.resume(m.coro,table.unpack(l,1,l.n)))if not n[1]then error(n[2],2)end;if n[2]==c then return table.unpack(n,3,n.n)end;m.filter=n[2]end end end end
    end;
    function b.borderBox(g,h,i,o,p,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")a(5,p,"number")q=a(6,q,"number","nil")or colors.white;r=a(7,r,"number","nil")or colors.black;g.setBackgroundColor(r)g.setTextColor(q)g.setCursorPos(h-1,i-1)g.write("\x9C"..("\x8C"):rep(o))g.setBackgroundColor(q)g.setTextColor(r)g.write("\x93")for s=1,p do g.setCursorPos(g.getCursorPos()-1,i+s-1)g.write("\x95")end;g.setBackgroundColor(r)g.setTextColor(q)for s=1,p do g.setCursorPos(h-1,i+s-1)g.write("\x95")end;g.setCursorPos(h-1,i+p)g.write("\x8D"..("\x8C"):rep(o).."\x8E")end;
    function b.button(g,h,i,t,u,q,r,v)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,t,"string")a(5,u,"function","string")q=a(6,q,"number","nil")or colors.white;r=a(7,r,"number","nil")or colors.gray;v=a(8,v,"number","nil")or colors.lightGray;g.setCursorPos(h,i)g.setBackgroundColor(r)g.setTextColor(q)g.write(" "..t.." ")b.addTask(function()local w=false;while true do local x,y,z,A=os.pullEvent()local B,C=b.getWindowPos(g,h,i)if x=="mouse_click"and y==1 and z>=B and z<B+#t+2 and A==C then w=true;g.setCursorPos(h,i)g.setBackgroundColor(v)g.setTextColor(q)g.write(" "..t.." ")elseif x=="mouse_up"and y==1 and w then if z>=B and z<B+#t+2 and A==C then if type(u)=="string"then b.resolve("button",u)else u()end end;g.setCursorPos(h,i)g.setBackgroundColor(r)g.setTextColor(q)g.write(" "..t.." ")end end end)end;
    -- function b.centerLabel(g,h,i,o,t,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")a(5,t,"string")q=a(6,q,"number","nil")or colors.white;r=a(7,r,"number","nil")or colors.black;assert(#t<=o,"string is too long")g.setCursorPos(h+math.floor((o-#t)/2),i)g.setTextColor(q)g.setBackgroundColor(r)g.write(t)end;
    -- function b.checkSelectionBox(g,h,i,o,p,D,u,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")a(5,p,"number")a(6,D,"table")a(7,u,"function","string","nil")q=a(8,q,"number","nil")or colors.white;r=a(9,r,"number","nil")or colors.black;local E=0;for _ in pairs(D)do E=E+1 end;local F=window.create(g,h,i,o,p)F.setBackgroundColor(r)F.clear()local G=window.create(F,1,1,o-1,E)G.setBackgroundColor(r)G.setTextColor(q)G.clear()local H={}local I,J=1,1;for K,m in pairs(D)do G.setCursorPos(1,I)G.write((m and(m=="R"and"[-] "or"[\xD7] ")or"[ ] ")..K)H[I]={K,not not m}I=I+1 end;if E>p then F.setCursorPos(o,p)F.setBackgroundColor(r)F.setTextColor(q)F.write("\31")end;G.setCursorPos(2,J)G.setCursorBlink(true)b.setCursorWindow(G)local B,C=b.getWindowPos(g,h,i)b.addTask(function()local L=1;while true do local l=table.pack(os.pullEvent())local M;if l[1]=="key"then if l[2]==keys.up then M=-1 elseif l[2]==keys.down then M=1 elseif l[2]==keys.space and D[H[J][1]]~="R"then H[J][2]=not H[J][2]G.setCursorPos(2,J)G.write(H[J][2]and"\xD7"or" ")if type(u)=="string"then b.resolve("checkSelectionBox",u,H[J][1],H[J][2])elseif u then u(H[J][1],H[J][2])else D[H[J][1]]=H[J][2]end;for s,m in ipairs(H)do local N=D[m[1]]=="R"and"R"or m[2]G.setCursorPos(2,s)G.write(N and(N=="R"and"-"or"\xD7")or" ")end;G.setCursorPos(2,J)end elseif l[1]=="mouse_scroll"and l[3]>=B and l[3]<B+o and l[4]>=C and l[4]<C+p then M=l[2]end;if M and(J+M>=1 and J+M<=E)then J=J+M;if J-L<0 or J-L>=p then L=L+M;G.reposition(1,2-L)end;G.setCursorPos(2,J)end;F.setCursorPos(o,1)F.write(L>1 and"\30"or" ")F.setCursorPos(o,p)F.write(L<E-p+1 and"\31"or" ")G.restoreCursor()end end)end;
    -- function b.drawImage(g,h,i,O,P,Q)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,O,"string","table")P=a(5,P,"number","nil")or 1;a(6,Q,"boolean","nil")if Q==nil then Q=true end;if type(O)=="string"then local R=assert(fs.open(O,"rb"))local S=R.readAll()R.close()O=assert(textutils.unserialize(S),"File is not a valid BIMG file")end;for T=1,#O[P]do g.setCursorPos(h,i+T-1)g.blit(table.unpack(O[P][T]))end;local U=O[P].palette or O.palette;if Q and U then for s=0,#U do g.setPaletteColor(2^s,table.unpack(U[s]))end end end;
    -- function b.drawText(g,t,V,q,r)a(1,g,"table")a(2,t,"string")a(3,V,"boolean","nil")q=a(4,q,"number","nil")or colors.white;r=a(5,r,"number","nil")or colors.black;g.setBackgroundColor(r)g.setTextColor(q)local W=term.redirect(g)local H=print(t)term.redirect(W)if V then local h,i=g.getPosition()local X=g.getSize()g.reposition(h,i,X,H)end;return H end;
    -- function b.horizontalLine(g,h,i,o,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")q=a(5,q,"number","nil")or colors.white;r=a(6,r,"number","nil")or colors.black;g.setCursorPos(h,i)g.setTextColor(q)g.setBackgroundColor(r)g.write(("\x8C"):rep(o))end;
    -- function b.inputBox(g,h,i,o,u,q,r,Y,Z,a0,a1)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")a(5,u,"function","string")q=a(6,q,"number","nil")or colors.white;r=a(7,r,"number","nil")or colors.black;a(8,Y,"string","nil")a(9,Z,"table","nil")a(10,a0,"function","nil")a(11,a1,"string","nil")local a2=window.create(g,h,i,o,1)a2.setTextColor(q)a2.setBackgroundColor(r)a2.clear()b.addTask(function()local a3=coroutine.create(read)local W=term.redirect(a2)local a4,n=coroutine.resume(a3,Y,Z,a0,a1)term.redirect(W)while coroutine.status(a3)~="dead"do local l=table.pack(os.pullEvent())W=term.redirect(a2)a4,n=coroutine.resume(a3,table.unpack(l,1,l.n))term.redirect(W)if not a4 then error(n)end end;if type(u)=="string"then b.resolve("inputBox",u,n)else u(n)end;while true do os.pullEvent()end end)end;
    function b.interval(a5,u)a(1,a5,"number")a(2,u,"function","string")local a6=os.startTimer(a5)b.addTask(function()while true do local _,a7=os.pullEvent("timer")if a7==a6 then local n;if type(u)=="string"then b.resolve("timeout",u)else n=u()end;if type(n)=="number"then a5=n end;if n~=false then a6=os.startTimer(a5)end end end end)return function()os.cancelTimer(a6)end end;
    function b.keyAction(a8,u)a(1,a8,"number")a(2,u,"function","string")b.addTask(function()while true do local _,a9=os.pullEvent("key")if a9==a8 then if type(u)=="string"then b.resolve("keyAction",u)else u()end end end end)end;
    -- function b.keyCombo(a8,aa,ab,ac,u)a(1,a8,"number")a(2,aa,"boolean")a(3,ab,"boolean")a(4,ac,"boolean")a(5,u,"function","string")b.addTask(function()local ad,ae,af=false,false,false;while true do local x,a9,ag=os.pullEvent()if x=="key"then if a9==a8 and ad==aa and ae==ab and af==ac and not ag then if type(u)=="string"then b.resolve("keyCombo",u)else u()end elseif a9==keys.leftCtrl or a9==keys.rightCtrl then ad=true elseif a9==keys.leftAlt or a9==keys.rightAlt then ae=true elseif a9==keys.leftShift or a9==keys.rightShift then af=true end elseif x=="key_up"then if a9==keys.leftCtrl or a9==keys.rightCtrl then ad=false elseif a9==keys.leftAlt or a9==keys.rightAlt then ae=false elseif a9==keys.leftShift or a9==keys.rightShift then af=false end end end end)end;
    function b.label(g,h,i,t,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,t,"string")q=a(5,q,"number","nil")or colors.white;r=a(6,r,"number","nil")or colors.black;g.setCursorPos(h,i)g.setTextColor(q)g.setBackgroundColor(r)g.write(t)end;
    function b.progressBar(g,h,i,o,q,r,ah)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")q=a(5,q,"number","nil")or colors.white;r=a(6,r,"number","nil")or colors.black;a(7,ah,"boolean","nil")local function ai(aj)a(1,aj,"number")if aj<0 or aj>1 then error("bad argument #1 (value out of range)",2)end;g.setCursorPos(h,i)g.setBackgroundColor(r)g.setBackgroundColor(q)g.write((" "):rep(math.floor(aj*o)))g.setBackgroundColor(r)g.setTextColor(q)g.write((ah and"\x7F"or" "):rep(o-math.floor(aj*o)))end;ai(0)return ai end;
    -- function b.scrollBox(g,h,i,o,p,ak,al,am,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")a(5,p,"number")a(6,ak,"number")a(7,al,"boolean","nil")a(8,am,"boolean","nil")q=a(9,q,"number","nil")or colors.white;r=a(10,r,"number","nil")or colors.black;if al==nil then al=true end;local F=window.create(g==term and term.current()or g,h,i,o,p)F.setBackgroundColor(r)F.clear()local G=window.create(F,1,1,o-(am and 1 or 0),ak)G.setBackgroundColor(r)G.clear()if am then F.setBackgroundColor(r)F.setTextColor(q)F.setCursorPos(o,p)F.write(ak>p and"\31"or" ")end;h,i=b.getWindowPos(g,h,i)b.addTask(function()local L=1;while true do local l=table.pack(os.pullEvent())ak=select(2,G.getSize())local M;if l[1]=="key"and al then if l[2]==keys.up then M=-1 elseif l[2]==keys.down then M=1 end elseif l[1]=="mouse_scroll"and l[3]>=h and l[3]<h+o and l[4]>=i and l[4]<i+p then M=l[2]end;if M and(L+M>=1 and L+M<=ak-p)then L=L+M;G.reposition(1,2-L)end;if am then F.setBackgroundColor(r)F.setTextColor(q)F.setCursorPos(o,1)F.write(L>1 and"\30"or" ")F.setCursorPos(o,p)F.write(L<ak-p and"\31"or" ")end end end)return G end;
    function b.selectionBox(g,h,i,o,p,an,u,ao,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")a(5,p,"number")a(6,an,"table")a(7,u,"function","string")a(8,ao,"function","string","nil")q=a(9,q,"number","nil")or colors.white;r=a(10,r,"number","nil")or colors.black;local ap=window.create(g,h,i,o-1,p)local aq,ar=1,1;local function as()ap.setVisible(false)ap.setBackgroundColor(r)ap.clear()for s=ar,ar+p-1 do local at=an[s]if not at then break end;ap.setCursorPos(2,s-ar+1)if s==aq then ap.setBackgroundColor(q)ap.setTextColor(r)else ap.setBackgroundColor(r)ap.setTextColor(q)end;ap.clearLine()ap.write(#at>o-1 and at:sub(1,o-4).."..."or at)end;ap.setCursorPos(o,1)ap.write(ar>1 and"\30"or" ")ap.setCursorPos(o,p)ap.write(ar<#an-p+1 and"\31"or" ")ap.setVisible(true)end;as()b.addTask(function()while true do local _,a8=os.pullEvent("key")if a8==keys.down and aq<#an then aq=aq+1;if aq>ar+p-1 then ar=ar+1 end;if type(ao)=="string"then b.resolve("selectionBox",ao,aq)elseif ao then ao(aq)end;as()elseif a8==keys.up and aq>1 then aq=aq-1;if aq<ar then ar=ar-1 end;if type(ao)=="string"then b.resolve("selectionBox",ao,aq)elseif ao then ao(aq)end;as()elseif a8==keys.enter then if type(u)=="string"then b.resolve("selectionBox",u,an[aq])else u(an[aq])end end end end)end;
    function b.textBox(g,h,i,o,p,t,q,r)a(1,g,"table")a(2,h,"number")a(3,i,"number")a(4,o,"number")a(5,p,"number")a(6,t,"string")q=a(7,q,"number","nil")or colors.white;r=a(8,r,"number","nil")or colors.black;local a2=window.create(g,h,i,o,p)function a2.getSize()return o,math.huge end;local function ai(au)a(1,au,"string")a2.setBackgroundColor(r)a2.setTextColor(q)a2.clear()a2.setCursorPos(1,1)local W=term.redirect(a2)print(au)term.redirect(W)end;ai(t)return ai end;
    -- function b.timeout(a5,u)a(1,a5,"number")a(2,u,"function","string")local a6=os.startTimer(a5)b.addTask(function()while true do local _,a7=os.pullEvent("timer")if a7==a6 then if type(u)=="string"then b.resolve("timeout",u)else u()end end end end)return function()os.cancelTimer(a6)end end;
    return b
end)()

local atom = {
    fs = {
        makeDir = function (path)
            if dryRun then
                print('** mkdir ' .. path)
            else
                fs.makeDir(path)
            end
        end,

        open = function (path, mode)
            if dryRun then
                -- print('** open ' .. mode .. ' ' .. path)

                return {
                    write = function (data)
                        print('** write ' .. path)
                    end,
                    flush = function () end,
                    close = function () end,
                }
            else
                return fs.open(path, mode)
            end
        end
    }
}

local endpoint = function (url)
    return function (...)
        return url:format(...)
    end
end

local client = REST()
    :setBaseURL('https://api.github.com/')
    :setHeaders({ ['X-GitHub-Api-Version'] = '2022-11-28' })

local api = {
    contents = endpoint('repos/%s/contents/%s?ref=%s'),
    tree = endpoint('repos/%s/git/trees/%s'),
    treeRecursive = endpoint('repos/%s/git/trees/%s?recursive=true'),
    raw = endpoint('https://raw.githubusercontent.com/%s/%s/%s'),
    releaseLatest = endpoint('repos/%s/releases/latest')
}

local downloadTree = function (targetRoot, blobs, updateBlob, updateBlobInfo)
    targetRoot = shell.resolve(targetRoot) .. '/'

    local totalTasks = #blobs
    local completedTasks = 0
    local totalBytes = 0
    local completedBytes = 0

    updateBlobInfo('Downloading blobs...')

    local blobChunks = {}
    local chunkSize = 25
    local currentChunk = 1

    local downloadState = {}

    for i,v in ipairs(blobs) do
        blobChunks[currentChunk] = blobChunks[currentChunk] or {}

        table.insert(blobChunks[currentChunk], v)
        table.insert(downloadState, i, 0)

        if i % chunkSize == 0 then
            currentChunk = currentChunk + 1
        end

        totalBytes = totalBytes + v.size
    end

    for chunkidx,chunk in ipairs(blobChunks) do
        local rawChunks = {}

        for i,blob in ipairs(chunk) do
            local blobidx = (chunkidx - 1) * chunkSize + i
            
            table.insert(rawChunks, function ()
                downloadState[blobidx] = 1
                
                local res, err, errRes = httpGetRedirect(blob.url)

                if not res then
                    print('Failed to get ' .. blob.path .. ': ' .. err)
                    print('URL: ' .. blob.url)
                    pprint(errRes.readAll())
                    return
                end

                local data = res.readAll()
                res.close()

                local blobOut = atom.fs.open(targetRoot .. blob.path, 'w')
                blobOut.write(data)
                blobOut.flush()
                blobOut.close()

                completedTasks = completedTasks + 1
                completedBytes = completedBytes + blob.size

                downloadState[blobidx] = 2

                -- generate state string
                local symbols = { ' ', '\x88', '\x8f' }
                local scaledState = {}

                for sidx=1, boxSizing.contentBox do
                    scaledState[sidx] = symbols[downloadState[math.ceil(sidx * #downloadState / boxSizing.contentBox)] + 1]
                end

                updateBlob(table.concat(scaledState))
                updateBlobInfo(('%.2f%% (%s/%s)'):format(completedTasks / totalTasks * 100, completedBytes, totalBytes))
            end)
        end

        parallel.waitForAll(table.unpack(rawChunks))
    end
end

local downloadRepoTree = function (repo, sha, sourceRoot, targetRoot, updateBlob, updateBlobInfo)
    updateBlobInfo('Getting root tree...')

    local pathParent = sourceRoot:match('(.*/)(.*)') or sourceRoot

    local parentContents = client:get(api.contents(repo, pathParent, sha))

    local subrootTreeHash
    for _,v in ipairs(parentContents) do
        if v.path == sourceRoot then
            subrootTreeHash = v.sha
            break
        end
    end

    if not subrootTreeHash then
        error('root tree ' .. sourceRoot .. ' not found')
    end

    updateBlobInfo('Expanding "' .. sourceRoot .. '" tree...')

    local srcTree = client:get(api.treeRecursive(repo, subrootTreeHash))

    local blobs = {}

    for _,v in ipairs(srcTree.tree) do
        if v.type == 'blob' then
            table.insert(blobs, {
                url = api.raw(repo, sha, sourceRoot .. '/' .. v.path),
                path = v.path,
                size = v.size
            })
        end
    end

    return downloadTree(targetRoot, blobs, updateBlob, updateBlobInfo)
end

local showConfirm = function (installName, targetRoot)
    ui.clear()
    
    ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Confirm')
    ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, ('Install %s into %s? Press Enter to confirm, or Q to abort.'):format(installName, targetRoot))

    ui.button(curt(), boxSizing.mainPadding, 18, "Confirm", "done")
    ui.button(curt(), boxSizing.mainPadding + 10, 18, "Abort", "abort")
    ui.keyAction(keys.enter, "done")
    ui.keyAction(keys.q, "abort")

    return ui.run()
end

local showComplete = function (installName)
    ui.clear()
    
    ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Complete')
    ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, ('%s has been installed. You may now close this installer.'):format(installName))

    ui.button(curt(), boxSizing.mainPadding, 18, "Finish", "done")
    ui.keyAction(keys.enter, "done")

    ui.run()
end

local getLatestReleaseBlobs = function (repo, assetMap)
    -- get latest core release
    local release, err, errRes = client:get(api.releaseLatest(repo))

    if not release then
        print('Failed to get latest ' .. repo .. ' release: ' .. err)
        pprint(errRes.readAll())
        return
    end

    -- example assetMap
    -- {
    --     map = {
    --         ['telem.lua'] = 'init.lua',
    --         ['vendor.lua'] = 'vendor.lua',
    --     },
    --     match = {
    --         ['%.luz$'] = 'modules/%s',
    --     },
    -- }

    local blobs = {}

    for _,v in ipairs(release.assets) do
        -- direct mapping from asset name to path
        if assetMap.map and assetMap.map[v.name] then
            table.insert(blobs, { url = v.browser_download_url, path = assetMap.map[v.name], size = v.size })
        
        -- pattern mapping from matched asset name to path template
        elseif assetMap.match then
            for pattern, format in pairs(assetMap.match) do
                if string.match(v.name, pattern) then
                    table.insert(blobs, { url = v.browser_download_url, path = format:format(v.name), size = v.size })
                    break
                end
            end
        end
    end

    return blobs
end

ui.clear()
ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Select install')

local installEntries = {
    "Release (compact)",
    "Release",
    "Source"
}

local installDescriptions = {
    'Compact core API package + Luz modules. Smallest footprint.',
    "Debug-friendly core API package + modules.",
    "Full sources of core API + modules. Recommended for development."
}

local descriptionBox = ui.textBox(curt(), boxSizing.mainPadding, 15, boxSizing.contentBox, 5, installDescriptions[1])

ui.borderBox(curt(), boxSizing.mainPadding + 1, 6, boxSizing.borderBox, 8)
ui.selectionBox(curt(), boxSizing.mainPadding + 1, 6, boxSizing.contentBox, 8, installEntries, 'done', function (opt) descriptionBox(installDescriptions[opt]) end)

local _, _, selection = ui.run()

local _, action = showConfirm(selection, '/' .. shell.resolve('telem'))

if action == 'abort' then
    ui.clear()
    ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Aborted')
    ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, 'Installation aborted. You may now close this installer.')

    ui.button(curt(), boxSizing.mainPadding, 18, "Finish", "done")
    ui.keyAction(keys.enter, "done")

    ui.run()
elseif selection then
    ui.clear()

    ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Installing...')
    local currentStep = ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, '')
    local currentBlob = ui.textBox(curt(), boxSizing.mainPadding, 8, boxSizing.contentBox, 2, '', colors.white)
    local currentBlobInfo = ui.textBox(curt(), boxSizing.mainPadding, 10, boxSizing.contentBox, 2, 'reading tree...', colors.lightGray)

    if selection == 'Release (compact)' then
        ui.addTask(function ()
            currentStep('Step 1 of 2: Core')

            local coreBlobs = getLatestReleaseBlobs('cyberbit/telem', {
                map = {
                    ['telem.min.lua'] = 'init.lua',
                    ['vendor.min.lua'] = 'vendor.lua',
                }
            })

            downloadTree('telem', coreBlobs, currentBlob, currentBlobInfo)

            currentStep('Step 2 of 2: Modules')

            local moduleBlobs = getLatestReleaseBlobs('cyberbit/telem-modules', {
                match = {
                    ['%.luz$'] = 'modules/%s',
                }
            })

            downloadTree('telem', moduleBlobs, currentBlob, currentBlobInfo)

            ui.resolve()
        end)

        ui.run()
    elseif selection == 'Release' then
        ui.addTask(function ()
            currentStep('Step 1 of 2: Core')

            local coreBlobs = getLatestReleaseBlobs('cyberbit/telem', {
                map = {
                    ['telem.lua'] = 'init.lua',
                    ['vendor.lua'] = 'vendor.lua',
                }
            })
    
            downloadTree('telem', coreBlobs, currentBlob, currentBlobInfo)
    
            currentStep('Step 2 of 2: Modules')

            local moduleBlobs = getLatestReleaseBlobs('cyberbit/telem-modules', {
                match = {
                    ['%.lua$'] = 'modules/%s',
                }
            })
    
            downloadTree('telem', moduleBlobs, currentBlob, currentBlobInfo)
    
            ui.resolve()
        end)
    
        ui.run()
    elseif selection == 'Source' then
        ui.addTask(function ()
            currentStep('Step 1 of 2: Core')

            downloadRepoTree('cyberbit/telem', 'main', 'src/telem', 'telem', currentBlob, currentBlobInfo)

            currentStep('Step 2 of 2: Modules')

            downloadRepoTree('cyberbit/telem-modules', 'main', 'src/telem/modules', 'telem/modules', currentBlob, currentBlobInfo)

            ui.resolve()
        end)

        ui.run()
    end

    showComplete(selection)
end

ui.clear()