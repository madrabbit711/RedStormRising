--- Red Storm Rising DCS mission LUA code

if env == nil then
    dofile("bootstrap.lua")
else
    dofile(lfs.writedir() .. [[Scripts\RSR\bootstrap.lua]])
end

env.info("RSR starting")

dofileWrapper("mist_4_3_74.lua")
dofileWrapper("CTLD.lua")
dofileWrapper("configureCTLD.lua")

log = mist.Logger:new("RSR", "info")
JSON = loadfile(getFilePath("JSON.lua"))()

dofileWrapper("persistence.lua")
dofileWrapper("markEvents.lua")
dofileWrapper("ctldCallbacks.lua")
dofileWrapper("init.lua")

env.info("RSR ready")
