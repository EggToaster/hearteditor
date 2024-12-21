local loadstages = {}

table.insert(loadstages, {name = "Load libraries", todo = function()
    local items = lovr.filesystem.getDirectoryItems("libs-auto")
    for _, v in pairs(items) do
        if v:sub(v:len()-3) == ".lua" then
            log:v("LibLoader", "Load "..v:sub(1,v:len()-4))
            local module = require("libs-auto."..v:sub(1,v:len()-4))
            if module then
                he.libs[v:sub(1,v:len()-4)] = module
            else
                log:w("LibLoader", "Module "..v:sub(1,v:len()-4).." did not return anything(bad load)")
            end
        end
    end

    log:d("LibLoader", "Automatic load finish, now manual tasks")

    log:d("LibLoader", "UI2D load")
    UI2D = require("libs.UI2D")
    
    log:d("LibLoader", "UI2D init")
    UI2D.Init()

    --log:d("LibLoader", "lovr-mouse load")
    --lovr.newmouse = require("libs.lovr-mouse")

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
                    log:w("ModuleLoader", "Module "..v:sub(1,v:len()-4).." did not return anything(bad load)")
                end
            end
        end
    end
end})

table.insert(loadstages, {name = "Load configuration", todo = function()
    he.config:add("ui.theme.dark", true)

    log:d("ConfigSys", "load config")
    he.config:load()

    log:d("ConfigSys", "Using config to adjust values")

    --if he.config:read("ui.theme.dark")

end})

return loadstages