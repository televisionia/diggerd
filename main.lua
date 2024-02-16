-- Root directory
local root_dir = ""

-- Lists a bunch of images
local images

-- Defines the game workspace for objects
local game

-- Functions for things to do with objects
local object

function love.load()
    
    images = {}
    for _,file in pairs(love.filesystem.getDirectoryItems(root_dir.."sprites/")) do
        images[file] = {}
        for _,image in pairs(love.filesystem.getDirectoryItems(root_dir.."sprites/"..file.."/")) do
            images[file][image] = love.graphics.newImage(root_dir.."sprites/"..file.."/"..image.."/")
        end
    end

    game = {
        world = {
            dynamic = {},
            static = {},
            visual = {}
        },
        hud = {}
    }

    object = {
        default_properties = {
            type = "sprite",
            x = 0,
            y = 0,
            sx = 10,
            sy = 10,
            r = 0,
            texture = images.error["error.png"]
        },

        new = function(objectname, location, properties)
            location[objectname] = {}
            for property,value in pairs(object.default_properties) do
                location[objectname][property] = value
            end

            if properties then
                for property,value in pairs(properties) do
                    location[objectname][property] = value
                end
            end
        end,

        remove = function(object)
            object = nil
        end
    }

    object.new("test", game.hud)

end

function love.update(dt)
    
end

function love.draw()
    for category_name,current_category in pairs(game.world) do
        for _,current_object in pairs(current_category) do
            love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
        end
    end
    for _,current_object in pairs(game.hud) do
        love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
    end
end
