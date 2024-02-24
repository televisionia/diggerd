local general = {
    init_game = function ()
        PLAYER.speed = 300
        DATA.event.menu:show_menu()
        print("GAME INITIALISED")
    end,

    restart_game = function ()
        love.event.quit("restart")
    end,

    launch_debug_game = function ()
        DATA.event.menu:close_menu()
        print("LAUNCH DEBUG GAME")
        DATA.event.general:match_start({
            is_debug = true,
            map = DATA.maps["leveltest.lua"]
        })
    end,

    exit_game = function ()
        love.event.quit()
    end,

    match_start = function (self, properties)
        local is_debug, start_pos, map = properties.is_debug, properties.start_pos, properties.map
        if start_pos == nil then
            start_pos = {
                x = 0,
                y = 0
            }
        end
        PLAYER.x, PLAYER.y = start_pos.x, start_pos.y
        GAME.map = map

        GAME.object:create_unit(DATA.object.unit.stickman, 0, 0)
    end
}

return general