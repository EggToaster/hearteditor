local projman = {
    _version = "0.0.1",
    load = function(self, project, path) end,
    save = function(self, project, path) end,
    validate = function(self, project, path)
        local projectfile = io.open(project< "r")
        local project = projectfile:read("a")
    end
    
}

local name = "project"

return function() return projman, name end