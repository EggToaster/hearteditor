-- Returns key of a value.
function table.keyof(t, v)
    for k, w in pairs(t) do
        if v == w then
            return k
        end
    end
    return nil
end

-- Returns index of a value.
function table.indexof(t, v)
    for i, _, w in ipairs(t) do
        if v == w then
            return i
        end
    end
    return nil
end

-- Returns index of a key.
function table.indexofkey(t,k)
    for i, l in ipairs(t) do
        if l == k then
            return i
        end
    end
end

-- Lists keys in table specified.
function table.keylist(t)
    local u = {}
    for k in pairs(t) do
        table.insert(u, k)
    end
    return u
end

-- Uppers all string in a table. No support for nested tables.
function table.upper(tt)
    local t = {}
    for k, v in pairs(tt) do
        if type(v) == "string" then
            t[k] = v:upper()
        end
    end
    return t
end

-- Deprecated. Use table.indexofkey instead.(Anything but nil and false will be true in if statements)
-- if table.indexofkey(table,keyname) then dosomething() end
function table.haskey(t,k)
    local keylist = table.keylist(t)
    if table.contains(keylist,k) then
        return true
    end
    return false
end

-- Deprecated. Use table.indexof instead.(Anything but nil and false will be true in if statements)
-- if table.indexof(table,object) then dosomething() end
function table.contains(t, e)
    for _, v in pairs(t) do
      if v == e then
        return true
      end
    end
    return false
end

-- How many <2nd argument> is in <1st argument>?
function table.count(t,e)
    local c = 0
    for _, v in pairs(t) do
        if v == e then
            c = c + 1
        end
    end
    return c
end

-- Merges two tables. If 2 value with same key exists, latter one will take the priority.
function table.merge(t,n)
    if t == {} then
        return n
    elseif n == {} then
        return t
    end
    for k,v in pairs(n) do
        t[k] = v
    end
    return t
end

-- If one element in left exists in right, returns true.
-- Useful for arguments.
-- e.g. {"-v","--verbose","-d","--debug","--dbg"} in left, arg in right
function table.hasleftinright(t,u)
    for _, v in pairs(t) do
        for _, w in pairs(u) do
            if v == w then
                return true
            end
        end
    end
    return false
end

-- Properly clones tree(table) in first argument, and returns it.
-- In another words, ProperTree!
-- Normally, if you use new = oldtable, it will clone table ID as well.
-- Because the ID is same, both table will have same contents. This never changes.
-- This will clone each individual elements, so you will never end up with conflicting table ID.
function table.clone(tbl)
    local t = {}
    for k, v in pairs(tbl) do
        local v = v
        if type(v) == "table" then
            v = table.clone(v)
        end
        t[k] = v
    end
    return t
end

--string

-- Basic split.
function string.split(str, spl)
    local t = {}
    for s in string.gmatch(str, "([^"..spl.."]+)") do
        table.insert(t,s)
    end
    return t
end

--Enough poisoning! Let's put it in a single class

local util = {}

-- Checks if x is null or empty kind of object
function util.nullcheck(x)
    if not x then return false -- This single line covers nil and false
    elseif x == {} then return false
    elseif x == "" then return false
    elseif x == 0 then return false end
    return true
end

-- 1~4th arguments is box(x,y, size-x, size-y), 5th and 6th is position of a dot.
-- If dot is in a box, returns true.
function util.boxcol(x,y,sx,sy,mx,my)
    local mx, my = (mx or nil), (my or nil)
    if (x < mx) and (y < my) and (mx < x+sx) and (my < y+sy) then
        return true
    end
    return false
end

-- Parses version string to integer.
-- Only supports 3, fully-integer coloums
-- For example: 1.5.23
function util.verparse(ver)
    local t = {}
    for s in string.gmatch(ver, "([^.]+)") do
        table.insert(t,s)
    end
    return t[1], t[2], t[3]
end

return util