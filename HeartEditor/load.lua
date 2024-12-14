local loadstages = {}

table.insert(loadstages, {name = "Load UI2D", todo = function()
    UI2D = require "libs.ui2d"
    UI2D.Init()
end})

table.insert(loadstages, {name = "Load modules", todo = function()
    local items = lovr.filesystem.getDirectoryItems("HeartLibs")
    for _, v in pairs(items) do
        if v:sub(v:len()-3) == ".lua" then
            log:v("ModuleLoader","Load "..v:sub(1,v:len()-4))
            local module, name = require("HeartLibs."..v:sub(1,v:len()-4))()
            if not name then
                log:e("ModuleLoader", "Module "..v:sub(1,v:len()-4).." did not return name, skipping")
            else
                if module then
                    he[name] = module
                else
                    log:w("ModuleLoader", "Module "..v:sub(1,v:len()-4).." did not return anything")
                end
            end
        end
    end
end})

return loadstages