-- Direction amount must be 4 or a multiple of 4!
-- Suggested directions are 4, 8 and maybe 16 if you need that smoothness (especially for vehicular units.)

-- For sprite animation locations, the first frames on the left side of the sheet are idle
-- After those, are the walking animations
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

        animation = {
            directions = 8,
            walk_frames = 5,
            idle_frames = 1,
            sheet = DATA.images.animation["unit-stickman"]["spritesheet.png"],
            grid = DATA.images.animation["unit-stickman"].grid
        },

        x = 0,
        y = 0,
        
        unit = {
            health = 40,
            max_health = 40,
            display_health = true,
            speed = 3,
            display_name = "Stickman",
            direction = 1,
            visual_state = "idle"
        }
    }
}

return unit