-- Telem Installer by cyberbit
-- MIT License
-- Version 2023-12-28

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

local termW, termH = term.getSize()

local boxSizing = {
    mainPadding = 2
}

boxSizing.contentBox = termW - boxSizing.mainPadding * 2 + 1
boxSizing.borderBox = boxSizing.contentBox - 1

local curt = function () return term.current() end

ui.clear()
ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Select install')

local installEntries = {
    "Release (minified)",
    "Release",
    "Source"
}

local installDescriptions = {
    'Minified module + dependencies. Choose "Release" for a debug-friendly build.',
    "Packaged module + dependencies.",
    "Full module and dependency sources. Recommended for development."
}

function string:overlay(overlay)
    return overlay .. self:sub(#overlay + 1)
end

local youWouldntDownloadATree = function (tree, updateProgress, updateBlob)
    local sourceCount = 0
    for _,_ in ipairs(tree.sources) do sourceCount = sourceCount + 1 end

    updateProgress(0)

    for i,v in ipairs(tree.sources) do
        local logicalPath = v.target or string.gsub(v.path, 'src/', '')
        local physicalPath = shell.resolve(logicalPath)

        updateBlob(string.gsub(logicalPath, 'telem/', ''))
        
        if v.type == 'tree' then
            fs.makeDir(physicalPath)
        elseif v.type == 'blob' then
            local bloburl = string.gsub(tree.url, '{sha}', tree.sha)
            bloburl = string.gsub(bloburl, '{path}', v.path)

            local blobreq = http.get(bloburl)
            
            local fout = fs.open(physicalPath, 'w')
            fout.write(blobreq.readAll())
            fout.flush()
            fout.close()
        end

        updateProgress(i / sourceCount)
    end
end

local parseAssets = function (assets)
    local parsed = {
        min = { size = 0 },
        max = { size = 0 }
    }
    for i,v in ipairs(assets) do
        if v.name == 'telem.lua' then
            parsed.max.lib = v.name
            parsed.max.size = parsed.max.size + v.size
        elseif v.name == 'telem.min.lua' then
            parsed.min.lib = v.name
            parsed.min.size = parsed.min.size + v.size
        elseif v.name == 'vendor.lua' then
            parsed.max.vendor = v.name
            parsed.max.size = parsed.max.size + v.size
        elseif v.name == 'vendor.min.lua' then
            parsed.min.vendor = v.name
            parsed.min.size = parsed.min.size + v.size
        end
    end
    return parsed
end

local showReleaseSelector = function ()
    ui.clear()

    ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Reading releases...')
    ui.borderBox(curt(), boxSizing.mainPadding + 1, 6, boxSizing.borderBox, 8)

    local releaseUrl = 'https://get.telem.cc/blob/releases'

    local req = http.get(releaseUrl)
    local jres = textutils.unserialiseJSON(req.readAll())

    local nonPreReleases = {}
    for i,v in ipairs(jres.releases) do
        if not v.prerelease then
            table.insert(nonPreReleases, v)
        end
    end

    local releaseLabels = {}
    local releaseNames = {}
    local releaseAssets = {}
    local releaseDescriptions = {}
    for i,v in ipairs(nonPreReleases) do
        local annotation = ''

        if v.latest then
            annotation = '[latest]'
        elseif v.prerelease then
            annotation = '[pre]'
        end

        annotation = string.format(('%%%is'):format(boxSizing.contentBox - 2), annotation)

        releaseLabels[i] = annotation:overlay(v.name)
        releaseNames[i] = v.name
        releaseAssets[i] = parseAssets(v.assets)
        releaseDescriptions[i] = ('%u bytes (%u bytes minified)'):format(releaseAssets[i].max.size, releaseAssets[i].min.size)
    end

    ui.clear()
    ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Select a release')

    ui.borderBox(curt(), boxSizing.mainPadding + 1, 6, boxSizing.borderBox, 8)
    local descriptionBox = ui.textBox(curt(), boxSizing.mainPadding, 15, boxSizing.contentBox, 5, releaseDescriptions[1])
    ui.selectionBox(curt(), boxSizing.mainPadding + 1, 6, boxSizing.contentBox, 8, releaseLabels, 'done', function (opt) descriptionBox(releaseDescriptions[opt]) end)

    local _, _, selection = ui.run()

    local releaseName
    local releaseAssetsParsed
    for i,v in ipairs(releaseLabels) do
        if v == selection then
            releaseName = releaseNames[i]
            releaseAssetsParsed = releaseAssets[i]
            break
        end
    end

    return releaseName, releaseAssetsParsed
end

local showComplete = function (installName)
    ui.clear()
    
    ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Complete')
    ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, ('%s has been installed. You may now close this installer.'):format(installName))

    ui.button(curt(), boxSizing.mainPadding, 18, "Finish", "done")
    ui.keyAction(keys.enter, "done")

    ui.run()
end

local installActions = {
    -- Release (minified)
    function ()
        local releaseName, releaseAssetsParsed = showReleaseSelector()

        ui.clear()
    
        ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Installing...')
        ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, 'Downloading minified release ' .. releaseName)
        local progress = ui.progressBar(curt(), boxSizing.mainPadding, 8, boxSizing.contentBox, nil, nil, true)
        local currentBlob = ui.textBox(curt(), boxSizing.mainPadding, 10, boxSizing.contentBox, 2, '-----')

        local fakeTree = {
            sha = releaseName,
            url = 'https://get.telem.cc/blob/asset/{sha}/{path}',
            sources = {
                { path = 'telem', type = 'tree' }
            }
        }
    
        ui.addTask(function ()
            if releaseAssetsParsed.min.lib then
                table.insert(fakeTree.sources, { path = 'telem.min.lua', target = 'telem/init.lua', type = 'blob' })
            end

            if releaseAssetsParsed.min.vendor then
                table.insert(fakeTree.sources, { path = 'vendor.min.lua', target = 'telem/vendor.lua', type = 'blob' })
            end

            youWouldntDownloadATree(fakeTree, progress, currentBlob)
    
            ui.resolve()
        end)
    
        ui.run()

        showComplete('Minified release')
    end,

    -- Release
    function ()
        local releaseName, releaseAssetsParsed = showReleaseSelector()

        ui.clear()
    
        ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Installing...')
        ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, 'Downloading release ' .. releaseName)
        local progress = ui.progressBar(curt(), boxSizing.mainPadding, 8, boxSizing.contentBox, nil, nil, true)
        local currentBlob = ui.textBox(curt(), boxSizing.mainPadding, 10, boxSizing.contentBox, 2, '-----')

        local fakeTree = {
            sha = releaseName,
            url = 'https://get.telem.cc/blob/asset/{sha}/{path}',
            sources = {
                { path = 'telem', type = 'tree' }
            }
        }
    
        ui.addTask(function ()
            if releaseAssetsParsed.min.lib then
                table.insert(fakeTree.sources, { path = 'telem.lua', target = 'telem/init.lua', type = 'blob' })
            end

            if releaseAssetsParsed.min.vendor then
                table.insert(fakeTree.sources, { path = 'vendor.lua', target = 'telem/vendor.lua', type = 'blob' })
            end

            youWouldntDownloadATree(fakeTree, progress, currentBlob)
    
            ui.resolve()
        end)
    
        ui.run()

        showComplete('Release')
    end,

    -- Source
    function ()
        ui.clear()

        ui.textBox(curt(), boxSizing.mainPadding, 2, boxSizing.contentBox, 5, 'Telem Installer - Installing...')
        local currentStep = ui.textBox(curt(), boxSizing.mainPadding, 6, boxSizing.contentBox, 8, '')
        local progress = ui.progressBar(term.current(), boxSizing.mainPadding, 8, boxSizing.contentBox, nil, nil, true)
        local currentBlob = ui.textBox(curt(), boxSizing.mainPadding, 10, boxSizing.contentBox, 2, 'reading source tree...')
    
        ui.addTask(function ()
            currentStep('Step 1 of 2: Modules')

            local treeUrl = 'https://get.telem.cc/blob/lib/main'
    
            local req = http.get(treeUrl)
            local res = textutils.unserialiseJSON(req.readAll())

            youWouldntDownloadATree(res, progress, currentBlob)

            currentStep('Step 2 of 2: Vendors')

            treeUrl = 'https://get.telem.cc/blob/vendor/main'
    
            req = http.get(treeUrl)
            res = textutils.unserialiseJSON(req.readAll())

            youWouldntDownloadATree(res, progress, currentBlob)
    
            ui.resolve()
        end)

        ui.run()
        
        showComplete('Source')
    end
}

local runInstallAction = function (releaseEntry)
    for i,v in ipairs(installEntries) do
        if v == releaseEntry then
            return installActions[i]()
        end
    end

    error('undefined release, aborting')
end

local descriptionBox = ui.textBox(curt(), boxSizing.mainPadding, 15, boxSizing.contentBox, 5, installDescriptions[1])

ui.borderBox(curt(), boxSizing.mainPadding + 1, 6, boxSizing.borderBox, 8)
ui.selectionBox(curt(), boxSizing.mainPadding + 1, 6, boxSizing.contentBox, 8, installEntries, 'done', function (opt) descriptionBox(installDescriptions[opt]) end)

local _, _, selection = ui.run()

runInstallAction(selection)

ui.clear()