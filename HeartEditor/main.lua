function lovr.load()

	--Import libraries
	he = require "HeartLibs.HeartEditor"
	he.util = require "HeartLibs.util"
	he.project = require "HeartLibs.projman"
	log = require "code.logger"

	--Debug stuff
	if he.info.channel == he.enum.channel.development then
		he.util.hang = function() log:e("HeartDebug","HANG!!!") while true do end end
	else
		he.util.hang = function() log:l("HeartDebug", "Debug function tried to hang the program. This should not occur, file a report") end
	end

	he.debug, he.verbose = false,false
	if not he.verbose then
		if table.hasleftinright({"-v","--verbose"}, arg) then
			he.debug = true
			he.verbose = true
		elseif table.hasleftinright({"--debug","--dbg","-d"}, arg) then
			he.debug = true
		end
	end

	log:init(true,true,true,he.debug,he.verbose)
	
	log:l("BootKicker", he.info.name..
		" v"..he.info.version..string.lower(string.sub(he.info.channel,1,1))..", "..
		he.info.channel.." build, running on "..lovr.system.getOS())

	log:d("BootKicker", "Creating Window")

	lovr.system.openWindow({width=720,height=340,fullscreen=false,resizable=true,title="HeartEditor",icon="placeholder.png"})

	log:d("BootKicker", "Preparing for first render")

	log:v("BootKicker", "Loading logo")

	local HeartWarming = lovr.graphics.newTexture("placeholder.png")
	
	local stage = 1
	local maxstage = 2
	local stagetext = "Welcome screen"

	local tempdraw = function()require("loadrender")(HeartWarming, stage, maxstage, stagetext)end

	log:v("BootKicker", "First render...")
	tempdraw()

	log:v("BootKicker", "Pass, starting temporary windowhandler")
	channel = lovr.thread.getChannel("li")
	local tc = [[
		local lovr = {thread = require "lovr.thread", system = require "lovr.system", graphics = "lovr.graphics"}
		local channel = lovr.thread.getChannel('li')
		local finish = false
		while not finish do
			if channel:pop(false) == "done" then
				finish = true
			end
			lovr.system.pollEvents()
		end
	]]
	local thread = lovr.thread.newThread(tc)
	thread:start()
	lovr.timer.sleep(0.1)

	stage = stage + 1
	stagetext = "Load UI2D"
	tempdraw()
	UI2D = require "ui2d..ui2d"
	UI2D.Init()

	stage = maxstage + 1
	stagetext = "Done loading, enjoy"
	tempdraw()

	lovr.timer.sleep(.5)
	lovr.graphics.setBackgroundColor(.5,.5,.5)

	log:d("HeartSystem", "Killing thread")
	_, timeout = channel:push("done", 2)
	if not timeout then
		log:fatal("HeartSystem", "WindowHandlerTemp not killed or killed too early")
	end
end

function lovr.keypressed(key, scancode, repeating)
	UI2D.KeyPressed(key, repeating)
end

function lovr.textinput(text, code)
	UI2D.TextInput(text)
end

function lovr.keyreleased(key, scancode)
	UI2D.KeyReleased()
end

function lovr.wheelmoved(x, y)
	UI2D.WheelMoved(x, y)
end

function lovr.update(dt)
	UI2D.InputInfo()
end

function lovr.quit()
	if he._quit then
		log:l("HeartSystem", "Quit initiated")

		log:l("HeartSystem", "Thanks for using "..he.info.name)
		return false -- Do not abort
	else
		log:l("HeartSystem", "Quit cancelled, work must be saved")
		he._quitpopup = true
		return true
	end
end

function lovr.draw(pass)
	pass:setProjection( 1, mat4():orthographic( pass:getDimensions() ) )

	UI2D.Begin("Youcannotseethis", 0, 0, false, true, true)
	local dx, dy = pass:getDimensions()
	UI2D.SetWindowPosition(0,0)
	for _ = 1, 500 do UI2D.Label("Debug") end
	UI2D.End(pass)

	--[[UI2D.Begin("My Window", 200, 200)
	UI2D.Button("My First Button")
	UI2D.End(pass)

	if he._quitpopup then
		UI2D.Begin("Quit?", 0, 0, true)
		UI2D.Label("Do you want to quit?")
		if UI2D.Button("Save and quit") then
			he._quitpopup = false
			he._quit = true
			log:fatal("HeartSystem", "No save function")
			UI2D.EndModalWindow()
			lovr.event.quit(0)
		end
		UI2D.SameLine()
		if UI2D.Button("Quit unsaved") then
			he._quitpopup = false
			he._quit = true
			UI2D.EndModalWindow()
			lovr.event.quit(0)
		end
		UI2D.SameLine()
		if UI2D.Button("Cancel") then
			he._quitpopup = false
			log:l("HeartSystem","Quit cancelled")
		end
		UI2D.End(pass)
		local wx, wy = UI2D.GetWindowSize("Quit?")
		local dx, dy = lovr.system.getWindowDimensions()
		UI2D.SetWindowPosition("Quit?", dx/2-wx/2, dy/2-wy/2)
	end]]

	local ui_passes = UI2D.RenderFrame(pass)
	table.insert(ui_passes, pass)
	return lovr.graphics.submit(ui_passes)
end

function lovr.errhand(message)
	local function formatTraceback(s)
	  return s:gsub('\n[^\n]+$', ''):gsub('\t', ''):gsub('stack traceback:', '\nStack:\n')
	end
  
	local message = tostring(message) .. formatTraceback(debug.traceback('', 4))
    print("\27[41m\27[04m"..message.."\27[00m")
	--[[message = message:gsub("\"","\\\""):gsub("\n","\\n"):gsub("'","#")
	local cmd = "bash -c '".."zenity --error --text=\""..message.."\"'"
	print(cmd)
	os.execute(cmd)]] -- An attempt to use zenity to show error

	if not lovr.graphics or not lovr.graphics.isInitialized() then
	  return function() return 1 end
	end
  
	if lovr.audio then lovr.audio.stop() end
  
	lovr.math.drain()

	return function() return 1 end
end