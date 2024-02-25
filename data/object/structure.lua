-- Refer to unit.lua for property details

local unit = {
    placeholder = {
        type = "structure_placeholder",
        name = "placeholder",
        description = "Structure used for testing",

        selectable = true,
        
        texture = "",

        click_width = 32,
        click_height = 32,

        animation = {
            directions = 2,
            frames = {
                spawn = 6,
                idle = 1,
                move = 0
            },
            frame_width = 32,
            frame_height = 32,
            frame_time = 0.1,
            sheet = DATA.images.animation["structure-placeholder"]["spritesheet.png"]
        },

        x = 0,
        y = 0,
        
        unit = {
            health = 40,
            max_health = 40,
            display_health = true,
            speed = 0, -- Structures cannot move anyway
            display_name = "Placeholder",
            direction = 1,
            visual_state = "idle"
        }
    }
}

return unit