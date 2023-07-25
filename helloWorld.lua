package.path = package.path .. ';src/?.lua;src/?/init.lua'

local telem = require 'dist.telem'

local backplane = telem.backplane():debug(true)
    :addInput('hello_in', telem.input.helloWorld(123))
    :addOutput('hello_out', telem.output.helloWorld())
    :cycleEvery(5)()