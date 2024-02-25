-- Direction amount must be 4 or a multiple of 4! (Structures are excepted from this rule)
-- Suggested directions are 4, 8 and maybe 16 if you need that smoothness (especially for vehicular units.)

-- units and structures MUST have at least a idle animation

-- For sprite animation locations, the first frames on the left side of the sheet are the spawn animation
-- After those, is the idle animation
-- After that, is the walking/movement animation
-- Then after those ones, the rest are action-specific
-- Each direction of each animation is separated vertically

-- It is important that the order of directions start from the top and go clockwise.
-- For example, a 4 direction spritesheet will have 1 looking up, 2 looking right, 3 looking down, 4 looking left

-- Something more visual?
-- 1: ^
-- 2: >
-- 3: v
-- 4: <

-- Need a diagram?

-- ^idle ^walk1 ^walk2 ^action
-- >idle >walk1 >walk2 >action
-- vidle vwalk1 vwalk2 vaction
-- <idle <walk1 <walk2 <action

-- That is an example of a spritesheet with 4 directions (imagine it's actual characters instead of text)

local unit = {
    stickman = {
        type = "unit_infantry",
        name = "stickman",
        description = "Unit used for testing",

        selectable = true,
        
        texture = "",

        click_width = 16,
        click_height = 16,

        animation = {
            directions = 8,
            frames = {
                spawn = 0,
                idle = 1,
                move = 4
            },
            frame_width = 16,
            frame_height = 16,
            frame_time = 0.2,
            sheet = DATA.images.animation["unit-stickman"]["spritesheet.png"]
        },

        x = 0,
        y = 0,
        
        unit = {
            health = 40,
            max_health = 40,
            display_health = true,
            speed = 2,
            display_name = "Stickman",
            direction = 1,
            visual_state = "idle"
        }
    }
}

return unit