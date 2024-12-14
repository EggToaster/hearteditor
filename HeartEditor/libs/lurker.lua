---@diagnostic disable: undefined-field, param-type-mismatch, redundant-parameter, duplicate-set-field
--
-- lurker
--
-- Copyright (c) 2018 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

-- This version of lurker is modified to work with LOVR.

local lume = require("libs.lurker")

local lurker = { _version = "1.0.1" }


local dir = lovr.filesystem.getDirectoryItems
local time = lovr.timer.getTime

local function isdir(path)
    local info = lovr.filesystem.getInfo(path)
    return info.type == "directory"
end

local function lastmodified(path)
    local info = lovr.filesystem.getInfo(path, "file")
    return info.modtime
end

function lurker.init()
  lurker.print("Initing lurker")
  lurker.path = "."
  lurker.preswap = function() end
  lurker.postswap = function() end
  lurker.interval = .5
  lurker.quiet = false
  lurker.lastscan = 0
  lurker.files = {}
  lume.each(lurker.getchanged(), lurker.resetfile)
  return lurker
end


function lurker.print(...)
  log:l("lurker", lume.format(...))
end


function lurker.listdir(path, recursive, skipdotfiles)
  path = (path == ".") and "" or path
  local function fullpath(x) return path .. "/" .. x end
  local t = {}
  for _, f in pairs(lume.map(dir(path), fullpath)) do
    if not skipdotfiles or not f:match("/%.[^/]*$") then
      if recursive and isdir(f) then
        t = lume.concat(t, lurker.listdir(f, true, true))
      else
        table.insert(t, lume.trim(f, "/"))
      end
    end
  end
  return t
end

function lurker.update()
  local diff = time() - lurker.lastscan
  if diff > lurker.interval then
    lurker.lastscan = lurker.lastscan + diff
    local changed = lurker.scan()
  end
end


function lurker.getchanged()
  local function fn(f)
    return f:match("%.lua$") and lurker.files[f] ~= lastmodified(f)
  end
  return lume.filter(lurker.listdir(lurker.path, true, true), fn)
end


function lurker.modname(f)
  return (f:gsub("%.lua$", ""):gsub("[/\\]", "."))
end


function lurker.resetfile(f)
  lurker.files[f] = lastmodified(f)
end


function lurker.hotswapfile(f)
  lurker.print("Hotswapping '{1}'...", {f})
  if lurker.preswap(f) then
    lurker.print("Hotswap of '{1}' aborted by preswap", {f})
    lurker.resetfile(f)
    return
  end
  local modname = lurker.modname(f)
  local t, ok, err = lume.time(lume.hotswap, modname)
  if ok then
    lurker.print("Swapped '{1}' in {2} secs", {f, t})
  else
    log:e("lurker", "Failed to swap '{1}' : {2}", {f, err})
  end
  lurker.resetfile(f)
  lurker.postswap(f)
end


function lurker.scan()
  local changed = lurker.getchanged()
  lume.each(changed, lurker.hotswapfile)
  return changed
end


return lurker.init()