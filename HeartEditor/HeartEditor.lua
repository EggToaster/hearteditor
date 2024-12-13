local he = {}

he.info = {
    version = "0.0.1",
    channel = "Development",
    name = "HeartEditor"
}

-- Is quitting posible?
he._quit = false
he._quitpopup = false

he.enum = {
    channel = {development="Development",beta="Beta",release="Release"}
}

return he