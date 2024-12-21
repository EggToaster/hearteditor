local he = {
    _quit = false, _quitpopup = false,
    info = {
        version = "0.0.1-1", -- WORK: Be sure to change this after beta/normal release. -n means beta release n
        channel = nil,
        name = "HeartEditor"
    },
    libs = {},
    enum = {
        channel = {development = "Development", beta = "Beta", release = "Release"},
        arg = {verbose = {"-v", "-verbose", "--verbose"}, debug = {"-d", "--debug", "-debug"},
        hotswap = {"-h", "--hotswap", "-hotswap"}, forcedevelopment = {"-force-dev-channel", "--force-dev-channel"}}
    }
}

he.info.channel = he.enum.channel.development -- WORK: Change this every beta/normal release

return he