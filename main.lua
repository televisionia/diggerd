-- Root directory
local root_dir = ""

-- Push
local push
local gameWidth, gameHeight = 640, 360
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7

-- Client data
local player

-- Camera library
local camera

-- Camera object for the game world
local world_cam

-- Camera object for the game hud
local hud_cam

-- Simple Tiled Implementation 
local sti

-- Data table for things like maps and images
local data

-- Current map on display
local current_map

-- Manages objects
local game

function love.load()
    camera = require 'libraries.camera'
    world_cam = camera()
    hud_cam = camera()

    sti = require 'libraries/sti'
    push = require 'libraries/push'

    love.graphics.setDefaultFilter("nearest")

    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, pixelperfect = true})

    player = {
        speed = 300,
        x = 0,
        y = 0
    }

    local data = {}

    data.images = {}
    for _,file in pairs(love.filesystem.getDirectoryItems(root_dir.."sprites/")) do
        data.images[file] = {}
        for _,image in pairs(love.filesystem.getDirectoryItems(root_dir.."sprites/"..file.."/")) do
            data.images[file][image] = love.graphics.newImage(root_dir.."sprites/"..file.."/"..image.."/")
        end
    end

    data.maps = {}
    for _,map in pairs(love.filesystem.getDirectoryItems(root_dir.."maps/mapfiles/")) do
        data.maps[map] = sti(root_dir.."maps/mapfiles/"..map)
    end

    game = {
        world = {
            dynamic = {},
            static = {},
            visual = {}
        },
        hud = {}
    }

    game.object = {
        default_properties = {
            type = "sprite",
            x = 0,
            y = 0,
            r = 0,
            texture = data.images.error["error.png"],
            sx = 1,
            sy = 1
        }
    }

    function game.object:new(objectname, location, properties)
        location[objectname] = {}
        for property,value in pairs(game.object.default_properties) do
            location[objectname][property] = value
        end

        if properties then
            for property,value in pairs(properties) do
                location[objectname][property] = value
            end
        end
    end

    function game.object:remove(object)
        object = nil
    end

    current_map = data.maps["leveltest.lua"]
end

function love.update(dt)
    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dt
    end

    if love.keyboard.isDown('up') then
        player.y = player.y - player.speed * dt
    elseif love.keyboard.isDown('down') then
        player.y = player.y + player.speed * dt
    end

    world_cam:lookAt(player.x, player.y)
end

function love.draw()

    push:start()

    world_cam:attach()

    -- WORLD --

    for _,layer in pairs(current_map.layers) do
        current_map:drawLayer(layer)
    end

    for category_name,current_category in pairs(game.world) do
        for _,current_object in pairs(current_category) do
            love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
        end
    end
    
    world_cam:detach()

    -----------

    -- HUD --

    hud_cam:attach()

    for _,current_object in pairs(game.hud) do
        love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
    end

    hud_cam:detach()

    ---------

    push:finish()

end
