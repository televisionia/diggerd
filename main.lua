-- Root directory
local root_dir = ""

-- Push
local push
local gameWidth, gameHeight = 320, 180
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7

-- Simple Tiled Implementation 
local sti

-- List of images
local images

-- List of maps
local maps

-- Current map on display
local current_map

-- Defines the game workspace for objects
local game

-- Functions for things to do with objects
local object


function love.load()
    
    sti = require 'libraries/sti'
    push = require 'libraries/push'

    love.graphics.setDefaultFilter("nearest")

    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, pixelperfect = true})

    images = {}
    for _,file in pairs(love.filesystem.getDirectoryItems(root_dir.."sprites/")) do
        images[file] = {}
        for _,image in pairs(love.filesystem.getDirectoryItems(root_dir.."sprites/"..file.."/")) do
            images[file][image] = love.graphics.newImage(root_dir.."sprites/"..file.."/"..image.."/")
        end
    end

    maps = {}
    for _,map in pairs(love.filesystem.getDirectoryItems(root_dir.."maps/mapfiles/")) do
        print(map)
        maps[map] = sti(root_dir.."maps/mapfiles/"..map)
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
            r = 0,
            texture = images.error["error.png"],
            sx = 1,
            sy = 1
        }
    }

    function object:new(objectname, location, properties)
        location[objectname] = {}
        for property,value in pairs(object.default_properties) do
            location[objectname][property] = value
        end

        if properties then
            for property,value in pairs(properties) do
                location[objectname][property] = value
            end
        end
    end

    function object:remove(object)
        object = nil
    end

    current_map = maps["leveltest.lua"]
end

function love.update(dt)

end

function love.draw()
    push:start()
    
    current_map:draw()

    for category_name,current_category in pairs(game.world) do
        for _,current_object in pairs(current_category) do
            love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
        end
    end
    for _,current_object in pairs(game.hud) do
        love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
    end

    push:finish()
end
