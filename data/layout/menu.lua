local menu_top_x = 10
local menu_top_y = 10

local button_texture = DATA.images.menu["button.png"]
local button_texture_height = button_texture:getPixelHeight()
local button_texture_width = button_texture:getPixelWidth()
local button_font = DATA.fonts.PixelifySans
local button_text_offset_y = button_texture:getPixelHeight() / 4

local layout_spread = button_texture_height * 2

local menu = {
    menu_title = {
        type = "ui_label",
        text = "love game jam test",
        align_text = "center",
        texture = "",
        font = button_font,
        text_width = button_texture_width,
        x = menu_top_x,
        y = menu_top_y,
        text_offset_x = 0,
        text_offset_y = 0
    },

    menu_start = {
        type = "ui_button",
        text = "skirmish",
        align_text = "center",
        texture = button_texture,
        font = button_font,
        text_width = button_texture_width,
        x = menu_top_x,
        y = menu_top_y + layout_spread,
        text_offset_x = 0,
        text_offset_y = button_text_offset_y,
        event = "general.launch_debug_game()"
    },

    menu_credits = {
        type = "ui_button",
        text = "info",
        align_text = "center",
        texture = button_texture,
        font = button_font,
        text_width = button_texture_width,
        x = menu_top_x,
        y = menu_top_y + layout_spread * 2,
        text_offset_x = 0,
        text_offset_y = button_text_offset_y,
        event = "menu.show_info()"
    },

    menu_exit = {
        type = "ui_button",
        text = "exit",
        align_text = "center",
        texture = button_texture,
        font = button_font,
        text_width = button_texture_width,
        x = menu_top_x,
        y = menu_top_y + layout_spread * 3,
        text_offset_x = 0,
        text_offset_y = button_text_offset_y,
        event = "general.exit_game()"
    }
}

return menu