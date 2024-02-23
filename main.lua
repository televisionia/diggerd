-- Data table for things like maps and images
DATA = {}

-- Manages objects and map
GAME = {}

-- Client data
PLAYER = {}

-- Root directory
ROOT_DIR = ""

-- Push
local push
local gameWidth, gameHeight = 640, 360
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.7, windowHeight*.7

-- Camera library
local camera

-- Camera object for the game world
local world_cam

-- Camera object for the game hud
local hud_cam

-- Sprite animations
local anim8

-- Simple Tiled Implementation 
local sti

-- Mouse data
local mouse

local function split_string (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    
    local t={}

    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end

    return t
end

function love.load()
    sti = require 'libraries.sti'
    push = require 'libraries.push'
    anim8 = require 'libraries.anim8'

    love.graphics.setDefaultFilter("nearest")

    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, pixelperfect = false})

    camera = require 'libraries.camera'
    world_cam = camera()
    hud_cam = camera()

    mouse = {}

    PLAYER = {
        x = 0,
        y = 0,
        zoom = 1
    }
    

    DATA = {}

    DATA.images = {}
    for _,file in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."sprites/")) do
        DATA.images[file] = {}
        if file ~= "animation" then
            for _,image in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."sprites/"..file.."/")) do
                DATA.images[file][image] = love.graphics.newImage(ROOT_DIR.."sprites/"..file.."/"..image.."/")
            end
        end
    end

    DATA.images.animation = {}
    for _,file in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."sprites/animation/")) do
        DATA.images.animation[file] = {}
        for _,image in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."sprites/animation/"..file.."/")) do
            DATA.images.animation[file][image] = love.graphics.newImage(ROOT_DIR.."sprites/animation/"..file.."/"..image.."/")
            DATA.images.animation[file].grid = anim8.newGrid(16, 16, DATA.images.animation[file][image]:getPixelWidth(), DATA.images.animation[file][image]:getPixelHeight())
        end
    end

    DATA.fonts = {}
    for _,fontfile in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."/fonts/")) do
        DATA.fonts[fontfile:match("(.+)%..+$")] = love.graphics.newFont(ROOT_DIR.."/fonts/"..fontfile)
    end

    DATA.maps = {}
    for _,map in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."maps/mapfiles/")) do
        DATA.maps[map] = sti(ROOT_DIR.."maps/mapfiles/"..map)
    end

    DATA.event = {}
    for _,eventfile in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."data/event/")) do
        DATA.event[eventfile:match("(.+)%..+$")] = require(ROOT_DIR.."data.event."..eventfile:match("(.+)%..+$"))
    end

    DATA.object = {}
    for _,objectfile in pairs(love.filesystem.getDirectoryItems(ROOT_DIR.."data/object/")) do
        DATA.object[objectfile:match("(.+)%..+$")] = require(ROOT_DIR.."data.object."..objectfile:match("(.+)%..+$"))
    end



    GAME = {
        -- Stores world objects, separated into 3 tables
        world = {
            -- Things that collide, move and render physics (units, etc.)
            dynamic = {},
            -- Things that don't move, but are collidable (buildings, etc.)
            static = {},
            -- Things that don't have collision or physics, and are purely just for visuals
            visual = {}
        },

        -- Stores HUD
        hud = {},

        -- Stores map, initalised with layers to avoid errors
        map = {
            layers = {}
        },

        -- Used for grouping objects within the game
        group = {}
    }

    GAME.object = {
        default_properties = {
            type = "sprite",
            x = 0,
            y = 0,
            r = 0,
            texture = DATA.images.error["error.png"],
            selected_texture = "",
            sx = 1,
            sy = 1,
            font_size = 10,
            align_text = "left",
            click_width = "32",
            click_height = "32",
            visible = true,
            events = {},
            hover = false,
            tags = {}
        }
    }

    function GAME.object:new(objectname, location, properties)
        location[objectname] = {}
        for property,value in pairs(GAME.object.default_properties) do
            location[objectname][property] = value
        end

        if properties ~= nil then
            for property,value in pairs(properties) do
                location[objectname][property] = value
            end
        end
    end

    function GAME.object:copy(object, name, location)
        GAME.object:new(name, location, object)
    end

    function GAME.object:copy_objects(objects, location)
        for object_name,object_properties in pairs(objects) do
            GAME.object:new(object_name, location, object_properties)
        end
    end

    function GAME.object:create_unit(resource, x, y)
        local location = GAME.world.dynamic
        local unit_id = #GAME.world.dynamic + 1

        GAME.object:copy(resource, resource.name.."_id="..unit_id, location)

        local unit = location[resource.name.."_id="..unit_id]
        unit.anim_list = {}

        unit.anim_list["idle"] = {}
        for direction = 1, unit.animation.directions do
            unit.anim_list["idle"][direction] = anim8.newAnimation(unit.animation.grid('1-'..unit.animation.idle_frames, direction), 0.2)
        end

        unit.anim_list["walk"] = {}
        for direction = 1, unit.animation.directions do
            unit.anim_list["walk"][direction] = anim8.newAnimation(unit.animation.grid((unit.animation.idle_frames + 1)..'-'..unit.animation.walk_frames, direction), 0.2)
        end
    end

    function GAME.object:check_for_object_at(x, y, location)
        if x ~= nil and y ~= nil then
            for _,object in pairs(location) do
                if object.x <= x and object.x + object.click_width >= x and object.y <= y and object.y + object.click_height >= y then
                    return object
                end
            end
        end
        return nil
    end

    function GAME.object:object_is_hovered(object)
        local x, y = mouse.x, mouse.y
        if x ~= nil and y ~= nil then
            if object.x <= x and object.x + object.click_width >= x and object.y <= y and object.y + object.click_height >= y then
                return true
            end
        end
        return false
    end

    function GAME.object:activate_object(object, signal)
        if object.events[signal] ~= nil then
            local event_path = split_string(object.events[signal], ".")
            event_path[2] = event_path[2]:gsub('%(', '')
            event_path[2] = event_path[2]:gsub('%)', '')

            DATA.event[event_path[1]][event_path[2]]()
        end
    end

    DATA.event.general:init_game()
end

function love.update(dt)
    if love.keyboard.isDown('left') then
        PLAYER.x = PLAYER.x - PLAYER.speed * dt
    elseif love.keyboard.isDown('right') then
        PLAYER.x = PLAYER.x + PLAYER.speed * dt
    end

    if love.keyboard.isDown('up') then
        PLAYER.y = PLAYER.y - PLAYER.speed * dt
    elseif love.keyboard.isDown('down') then
        PLAYER.y = PLAYER.y + PLAYER.speed * dt
    end

    for category_name,current_category in pairs(GAME.world) do
        for _,current_object in pairs(current_category) do
            if current_object.current_animation ~= nil then
                current_object.current_animation:update(dt)
            end
        end
    end

    for _,current_object in pairs(GAME.hud) do
        if current_object.current_animation ~= nil then
            current_object.current_animation:update(dt)
        end
    end

    world_cam:lockPosition(PLAYER.x, PLAYER.y)
    --world_cam:lookAt(PLAYER.x, PLAYER.y)
    world_cam:zoomTo(PLAYER.zoom)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local mousepos_x, mousepos_y = push:toGame(x, y)
        local find_object = GAME.object:check_for_object_at(mousepos_x, mousepos_y, GAME.hud)
        if find_object ~= nil then
            GAME.object:activate_object(find_object, "on_click")
        end
    elseif button == 3 then
        PLAYER.zoom = 1
    end
end

function love.wheelmoved(x, y)
    local zoom_amount = y / 10
    if PLAYER.zoom + zoom_amount > 0.5 and PLAYER.zoom + zoom_amount < 2 then
        PLAYER.zoom = PLAYER.zoom + zoom_amount
    end
end

function love.mousemoved(x, y)
    if x ~= nil and y ~= nil then
        mouse.x, mouse.y = push:toGame(x, y)
    end
end

function love.draw()

    push:start()

    world_cam:attach()

    -- WORLD --

    for _,layer in pairs(GAME.map.layers) do
       GAME.map:drawLayer(layer)
    end

    for category_name,current_category in pairs(GAME.world) do
        for _,current_object in pairs(current_category) do
            if current_object.visible == true then
                if current_object.texture ~= "" then
                    love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
                end

                if current_object.unit ~= nil then
                    current_object.anim_list[current_object.unit.visual_state][current_object.unit.direction]:draw(current_object.animation.sheet, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
                elseif current_object.current_animation ~= nil then
                    current_object.current_animation:draw(current_object.animation.sheet, current_object.x, current_object.y, current_object.sx, current_object.sy)
                end
            end
        end
    end
    
    world_cam:detach()

    -----------

    -- HUD --

    hud_cam:attach()

    for _,current_object in pairs(GAME.hud) do
        if current_object.visible == true then
            if current_object.texture_select ~= "" and GAME.object:object_is_hovered(current_object) then
                love.graphics.draw(current_object.texture_select, current_object.x - current_object.selected_offset_x, current_object.y - current_object.selected_offset_y, current_object.r, current_object.sx, current_object.sy)
            elseif current_object.texture ~= "" then
                love.graphics.draw(current_object.texture, current_object.x, current_object.y, current_object.r, current_object.sx, current_object.sy)
            end

            if current_object.text then
                love.graphics.printf(current_object.text, current_object.x + current_object.text_offset_x, current_object.y + current_object.text_offset_y, current_object.text_width, current_object.align_text)
            end

            if current_object.current_animation then
                current_object.current_animation:draw(current_object.animation.sheet, current_object.x, current_object.y, current_object.sx, current_object.sy)
            end
        end
        
    end

    hud_cam:detach()

    ---------

    push:finish()

end