local layout = {
    menu_title = {
        type = "ui_label",
        text = "love game jam test",
        align_text = "center",
        background_image = nil,
        font_size = 10,
        x = 10,
        y = 10
    },

    menu_start = {
        type = "ui_button",
        text = "skirmish",
        align_text = "center",
        background_image = data.images.menu["button.png"],
        font_size = 10,
        x = layout.menu_title.x,
        y = layout.menu_title.y + layout.menu_start.background_image:GetPixelHeight() * 2
    },

    menu_credits = {
        type = "ui_button",
        text = "info",
        align_text = "center",
        background_image = data.images.menu["button.png"],
        font_size = 10,
        x = layout.menu_title.x,
        y = layout.menu_start.y + layout.menu_credits.background_image:GetPixelHeight() * 2
    },

    menu_exit = {
        type = "ui_button",
        text = "exit",
        align_text = "center",
        background_image = data.images.menu["button.png"],
        font_size = 10,
        x = layout.menu_title.x,
        y = layout.menu_credits.y + layout.menu_exit.background_image:GetPixelHeight() * 2
    }
}