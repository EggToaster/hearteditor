function lovr.load()

	--Import libraries
	he = require "HeartEditor"
	he.util = require "code.util"
	log = require "code.logger"

	--Debug stuff
	if he.info.channel == he.enum.channel.development then
		he.util.hang = function() log:e("HeartDebug","HANG!!!") while true do end end
	else
		he.util.hang = function() log:l("HeartDebug", "Debug function tried to hang the program. This should not occur, file a report") end
	end

	he.debug, he.verbose = false,false
	if not he.verbose then
		if table.hasleftinright({"-v","--verbose"}, {"-v"}) then
			he.debug = true
			he.verbose = true
		elseif table.hasleftinright({"--debug","--dbg","-d"}, arg) then
			he.debug = true
		end
	end

	log:init(true,true,true,he.debug,he.verbose)
	
	log:l("BootKicker", he.info.name..
		" v"..he.info.version..string.lower(string.sub(he.info.channel,1,1))..", "..
		he.info.channel.." build")

	log:d("BootKicker", "Creating Window")

	lovr.system.openWindow({width=720,height=340,fullscreen=false,resizable=false,title="HeartEditor - Loading",icon="placeholder.png"})

	log:d("BootKicker", "Preparing for first render")

	log:v("BootKicker", "Loading logo")

	local HeartWarming = lovr.graphics.newTexture("placeholder.png")
	
	local stage = 1
	local maxstage = 2
	local stagetext = "Welcome screen"

	local function tempdraw()
		local pass = lovr.graphics.getWindowPass()
		pass:reset()
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

		lovr.graphics.submit(pass)
		lovr.graphics.present()
		lovr.timer.sleep(0.1)
	end

	log:v("BootKicker", "First render...")
	tempdraw()

	log:v("BootKicker", "Pass, starting load")
	lovr.timer.sleep(0.1)

	stage = stage + 1
	stagetext = "Load UI2D"
	tempdraw()

	UI2D = require "ui2d..ui2d"
	UI2D.Init()

	stage = maxstage + 1
	stagetext = "Done loading, enjoy"
	tempdraw()

	lovr.timer.sleep(1)

	while true do end

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

function lovr.draw(mainpass)
	mainpass:setProjection( 1, mat4():orthographic( mainpass:getDimensions() ) )

	UI2D.Begin("My Window", 200, 200)
	UI2D.Button("My First Button")
	UI2D.End(mainpass)

	local ui_passes = UI2D.RenderFrame(mainpass)
	table.insert(ui_passes, mainpass)
	return lovr.graphics.submit(ui_passes)
end