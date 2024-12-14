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
        if table.indexof(tbl, v) then
            tbl = tbl[v]
        else
            notfound = true
            break
        end
    end
    if notfound then
        return false
    else
        tbl[stlit[#stlit]] = value
        return true
    end
end

local conf = {
    _defaultconfig = {},
    _config = {},
    read = function(self, str)
        local result = get(self._config, str)
        if result then
            return result
        else
            log:e("Configuration", "The config "..str.." was not found")
            return nil
        end
    end,
    write = function(self, str, var)
        return w(self._config, str, var)
    end,
    add = function(self, str, var, noupdate)
        local noupdate = noupdate or false
        local r = w(self._defaultconfig, str, var)
        if not noupdate then
            self:update()
        end
        return r
    end,
    update = function(self)
        -- Lazy today, aren't we?
        table.merge(self._defaultconfig, self._config)
    end
}
return function() return conf end, "config"