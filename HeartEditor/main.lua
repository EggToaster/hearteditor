function lovr.load()

	--Import libraries
	he = require "HeartEditor"
	he.util = require "util"
	log = require "libs.logger"

	if table.hasleftinright(he.enum.arg.forcedevelopment, arg) then
		he.info.channel = he.enum.channel.development
	end

	--Debug stuff
	if he.info.channel == he.enum.channel.development then
		he.util.hang = function() log:e("HeartDebug","HANG!!!") while true do end end
	else
		he.util.hang = function() log:w("HeartDebug", "Debug function tried to hang the program. This should not have made in final release") end
	end

	he.debug, he.verbose = false, false
	if table.hasleftinright(he.enum.arg.verbose, arg) then
		he.debug = true
		he.verbose = true
	elseif table.hasleftinright(he.enum.arg.debug, arg) then
		he.debug = true
	end

	he.hotswap = false
	if table.hasleftinright(he.enum.arg.hotswap, arg) then
		if he.info.channel == he.enum.channel.development then
			he.hotswap = true
			log:l("HeartDebug", "Hotswap is going to be enabled")
		else
			log:e("HeartDebug", "Attempted hotswap enable in non-dev channel, this is illegal")
		end
	end

	log:init(true,true,true,he.debug,he.verbose)

	log:d("Logger", "Debug logging is enabled")
	log:v("Logger", "Verbose logging is enabled")
	

	log:l("BootKicker", he.info.name..
		" v"..he.info.version..string.lower(string.sub(he.info.channel,1,1))..", "..
		he.info.channel.." build, running on "..lovr.system.getOS()..", LOVR version "..he.engine.version) -- System info

	log:d("BootKicker", "Creating Window")

	lovr.system.openWindow({width=720,height=340,fullscreen=false,resizable=true,title="HeartEditor",icon="placeholder.png"})

	log:d("BootKicker", "Preparing for first render")

	log:v("BootKicker", "Loading logo")

	local HeartWarming = lovr.graphics.newTexture("placeholder.png")


	log:v("BootKicker", "Loading load routines...")

	local routines = require("load")
	table.insert(routines, 1, {name = "Welcome!", todo = function()end})

	local stage = 0
	local stagetext = "Welcome!"
	local maxstage = #routines

	log:v("BootKicker", "First render...")
	
	local function tempdraw()
		local pass = lovr.graphics.getWindowPass()
		log:v("BootKicker", "Render start")
		pass:reset()
		log:v("BootKicker", "Pass resetted")
		pass:setColor(.13, .13, .13)
		pass:cube(-50, 0, -6, 100, 180)
		pass:setColor(.5,.5,.5)
		pass:text("Version "..he.info.version..string.lower(string.sub(he.info.channel,1,1)), -2, 1, -5, .5, 0, 0, 1, 0, 0, "left")
		pass:setColor(.5,.5,1)
		pass:box(-7, -2, -5, 28/maxstage*stage, .5, 0)
		pass:setColor(1, 1, 1)
		pass:text("HeartEditor", -2.1, 1.7, -5, 1, 0, 0, 1, 0, 0, "left")
		pass:draw(HeartWarming, -4.5, 0.7, -5, 4.5)
		pass:text((stage <= maxstage and stage.."/"..maxstage.." - " or "")..stagetext, -5.8, -1.7, -4, 1, 0, 0, 1, 0, 0, "left", "top")
		if stage ~= 1 then log:d("BootKicker", stagetext) end
		log:v("BootKicker", "Submitting pass... If it crashed, something between this and \"Psss resetted\" is usual suspect")
		lovr.graphics.submit(pass)
		lovr.graphics.present()
		lovr.timer.sleep(0.1)
		log:v("BootKicker", "Render done")
	end

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

	log:l("BootKicker", "Starting routines")

	for _, v in pairs(routines) do
		stage = stage + 1
		stagetext = v.name
		log:l("BootKicker", "Routine "..stage..", "..stagetext)
		tempdraw()
		v.todo()
		lovr.timer.sleep(0.1)
	end

	stage = stage + 1
	stagetext = "Enjoy!"
	tempdraw()

	lovr.timer.sleep(1)
	lovr.graphics.setBackgroundColor(.5,.5,.5)

	log:d("BootKicker", "Killing thread")
	_, timeout = channel:push("done", 2)
	if not timeout then
		log:fatal("BootKicker", "WindowHandlerTemp not killed or killed too early")
	end
	log:l("BootKicker", "Loading finished, enjoy")

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

	--[[UI2D.Begin("Youcannotseethis", 0, 0, false, true, true)
	local dx, dy = pass:getDimensions()
	UI2D.SetWindowPosition(0,0)
	for _ = 1, 1 do UI2D.Label("Debug") end
	UI2D.Button("Open")
	UI2D.End(pass)]]

	UI2D.Begin("My Window", 200, 200)
	UI2D.Button("NFD open")
	UI2D.End(pass)
	
	UI2D.Begin("My EFI", 400, 200)
	UI2D.Button("Maybe snapshot")
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
			UI2D.EndModalWindow()
			log:l("HeartSystem","Quit cancelled")
		end
		UI2D.End(pass)
		local wx, wy = UI2D.GetWindowSize("Quit?")
		local dx, dy = lovr.system.getWindowDimensions()
		UI2D.SetWindowPosition("Quit?", dx/2-wx/2, dy/2-wy/2)
	end

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

	if not lovr.graphics or not lovr.graphics.isInitialized() then
	  return function() return 1 end
	end
  
	if lovr.audio then lovr.audio.stop() end
  
	lovr.math.drain()

	return function() return 1 end
end