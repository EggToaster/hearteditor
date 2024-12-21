local function get(tbl, str)
    local stlit = string.split(str,".")
    local tbl = tbl
    local notfound = false
    for _, v in pairs(stlit) do
        if table.indexof(tbl, v) then
            tbl = tbl[v]
        else
            notfound = true
            break
        end
    end
    if notfound then
        return nil
    else
        return tbl
    end
end

local function w(tbl, str, value)
    local stlit = string.split(str,".")
    local tbl = tbl
    local notfound = false
    for i = 1, #stlit -1  do
        local v = stlit[i]
        if not table.indexof(tbl, v) then
            tbl[v] = {} -- If the element does not exist, it will 
        end             -- Ehh, I will keep this comment
        tbl = tbl[v]
    end
    if notfound then
        return false
    else
        tbl[stlit[#stlit]] = value
        return true
    end
end

local conf = { -- TODO: Broken, FIXME
    _defaultconfig = {},
    _config = {},
    read = function(self, str)
        local result = get(self._config, str)
        if result ~= nil then -- False should be passed as is
            return result
        else
            log:e("Configuration", "The config "..str.." was not found")
            return nil
        end
    end,
    write = function(self, str, var)
        return w(self._config, str, var)
    end,
    add = function(self, str, var, update)
        local update = update or false
        local r = w(self._defaultconfig, str, var)
        if update then
            self:update()
        end
        return r
    end,
    update = function(self)
        -- Lazy today, aren't we?
        table.merge(self._defaultconfig, self._config)
    end,
    load = function(self)
        local cfg = lovr.filesystem.read("config.json")
        if cfg then
            self._config = he.json.decode(cfg)
            self:update()
        else
            log:d("ConfigSys", "Config not found, creating")
            self._config = self._defaultconfig
        end 
        print(self._config)
        print(he.json.encode(self._config))
        lovr.filesystem.write("config.json", he.json.encode(self._config))
    end
}
return function() return conf, "config" end