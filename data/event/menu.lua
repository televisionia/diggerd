local menu = {
    show_menu = function ()
        PLAYER.x = 340
        PLAYER.y = 260
        GAME.map = DATA.maps["leveltest.lua"]
        GAME.object:copy_objects(DATA.object.menu, GAME.hud)
    end,

    close_menu = function ()
        for object_name,_ in pairs(GAME.hud) do
            if GAME.hud[object_name].tags.main_menu then
                GAME.hud[object_name] = nil
            end
        end
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