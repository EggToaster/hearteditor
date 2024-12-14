local langsys = {
    _lang = {},
    _currentlanguage = nil,
    get = function(self, str)
        local stlit = string.split(str,".")
        local lang = self._lang
        local notfound = false
        for _, v in pairs(stlit) do
            if table.indexof(lang, v) then
                lang = lang[v]
            else
                notfound = true
                break
            end
        end
        if notfound then
            return str
        else
            return lang
        end
    end,
    load = function (self, lang)
        local l = require("res.localization."..lang)
        self._lang = l
    end
}

return function() return langsys, "lang" end