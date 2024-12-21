local he = {
    _quit = false, _quitpopup = false,
    info = {
        version = nil,
        channel = nil,
        name = "HeartEditor"
    },
    libs = {},
    enum = {
        channel = {development = "Development", beta = "Beta", release = "Release"},
        arg = {verbose = {"-v", "-verbose", "--verbose"}, debug = {"-d", "--debug", "-debug"},
        hotswap = {"-h", "--hotswap", "-hotswap"}, forcedevelopment = {"-force-dev-channel", "--force-dev-channel"}}
    },
    engine = {}
}

he.info.version = "0.0.1-1" -- WORK: Be sure to change this after beta/normal release. -n means beta release
he.info.channel = he.enum.channel.development -- WORK: Change this every beta/normal release

-- Engine details
local m, n, o = lovr.getVersion()
he.engine.version = tostring(m).."."..tostring(n).."."..tostring(o)
he.engine.os = lovr.system.getOS()
he.engine.target = "0.17.1" -- WORK: Change this when upgrading LOVR

return he