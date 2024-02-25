local menu_top_x = 20
local menu_top_y = 20

local button_texture = DATA.images.menu["button.png"]
local button_texture_selected = DATA.images.menu["button_selected.png"]

local button_texture_width = button_texture:getPixelWidth()
local button_texture_height = button_texture:getPixelHeight()

local button_selected_offset_x = (button_texture_selected:getPixelWidth() - button_texture:getPixelWidth()) / 2
local button_selected_offset_y = (button_texture_selected:getPixelHeight() - button_texture:getPixelHeight()) / 2

local button_font = DATA.fonts.PixelifySans

local button_text_offset_y = button_texture:getPixelHeight() / 4

local layout_spread = button_texture_height * 2

local menu = {
    menu_title = {
        type = "ui_label",
        
        text = "underground rts",

        texture = "",

        font = button_font,
        align_text = "center",
        text_width = button_texture_width,

        x = menu_top_x,
        y = menu_top_y,

        text_offset_x = 0,
        text_offset_y = 0,
        
        tags = {
            main_menu = true
        }
    },

    menu_start = {
        type = "ui_button",

        text = "skirmish",

        texture = button_texture,
        texture_select = button_texture_selected,

        font = button_font,
        align_text = "center",
        text_width = button_texture_width,

        x = menu_top_x,
        y = menu_top_y + layout_spread,

        selected_offset_x = button_selected_offset_x,
        selected_offset_y = button_selected_offset_y,

        click_width = button_texture_width,
        click_height = button_texture_height,

        text_offset_x = 0,
        text_offset_y = button_text_offset_y,

        events = {
            on_click = {
                event = "general.launch_debug_game"
            }
        },
        
        tags = {
            main_menu = true
        }
    },

    menu_credits = {
        type = "ui_button",

        text = "info",
        
        texture = button_texture,
        texture_select = button_texture_selected,

        font = button_font,
        align_text = "center",
        text_width = button_texture_width,

        x = menu_top_x,
        y = menu_top_y + layout_spread * 2,

        selected_offset_x = button_selected_offset_x,
        selected_offset_y = button_selected_offset_y,

        click_width = button_texture_width,
        click_height = button_texture_height,

        text_offset_x = 0,
        text_offset_y = button_text_offset_y,
        
        events = {
            on_click = {
                event = "menu.toggle_info"
            }
        },
        
        tags = {
            main_menu = true
        }
    },

    menu_exit = {
        type = "ui_button",

        text = "exit",

        texture = button_texture,
        texture_select = button_texture_selected,

        font = button_font,
        align_text = "center",
        text_width = button_texture_width,

        x = menu_top_x,
        y = menu_top_y + layout_spread * 3,

        selected_offset_x = button_selected_offset_x,
        selected_offset_y = button_selected_offset_y,

        click_width = button_texture_width,
        click_height = button_texture_height,

        text_offset_x = 0,
        text_offset_y = button_text_offset_y,

        events = {
            on_click = {
                event = "general.exit_game"
            }
        },
        
        tags = {
            main_menu = true
        }
    },

    info_label = {
        type = "ui_label",

        text = "! unreleased version !",

        texture = "",

        font = button_font,
        align_text = "center",
        text_width = button_texture_width * 2,

        x = menu_top_x + button_texture_width * 2,
        y = menu_top_y + layout_spread,

        text_offset_x = 0,
        text_offset_y = 0,

        visible = false,
        
        tags = {
            main_menu = true
        }
    }
}

return menu