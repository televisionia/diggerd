local menu = {
    show_menu = function ()
        PLAYER.x = 340
        PLAYER.y = 260
        GAME.map = DATA.maps["leveltest.lua"]
        GAME.object:copy_objects(DATA.layout.menu, GAME.hud)
    end,

    show_info = function ()
        print("SHOW INFO")
    end
}

return menu