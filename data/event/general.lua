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
        print("LAUNCH DEBUG GAME")
    end,

    exit_game = function ()
        love.event.quit()
    end
}

return general