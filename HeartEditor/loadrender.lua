local function tempdraw(HeartWarming,stage,maxstage,stagetext)
    local pass = lovr.graphics.getWindowPass()
    log:v("BootKicker","Render start")
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
    if stage ~= 1 then log:d("BootKicker", stagetext) end
    lovr.graphics.submit(pass)
    lovr.graphics.present()
    lovr.timer.sleep(0.1)
    log:v("BootKicker","Render done")
end
return tempdraw