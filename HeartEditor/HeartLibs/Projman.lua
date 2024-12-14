local projman = {
    _version = "0.0.1",
    load = function(self, projectfilepath, projectpath)
        if not self:validate(projectfilepath,projectpath) then
            return false, "he.project.corrupted"
        end

        local project = {}


        return project

    end,
    save = function(self, projectfilepath, projectpath) end,
    validate = function(self, projectfilepath, projectpath)
        local projectfile = io.open(projectfilepath< "r")
        local project = projectfile:read("a")
        projectfile:close()
        
        if not he.json.check(project) then
            return false
        end
    end
    
}

local name = "project"

return function() return projman, name end