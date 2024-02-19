local menu = {
    show_menu = function ()
        PLAYER.x = 340
        PLAYER.y = 260
        GAME.map = DATA.maps["leveltest.lua"]
        GAME.object:copy_objects(DATA.object.menu, GAME.hud)
    end,

    toggle_info = function ()
        if GAME.hud.info_label.visible == true then
            GAME.hud.info_label.visible = false
        else
            GAME.hud.info_label.visible = true
        end
    end
}

return menu