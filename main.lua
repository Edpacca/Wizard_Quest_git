-- Class.lua Copyright (c) 2010-2013 Matthias Richter
Class = require 'class'
-- push.lua Copyright (c) 2018 Ulysse Ramage
push = require 'push'

require 'Animation'
require 'Fireball'
require 'Frostray'
require 'Items'
require 'Map64'
require 'Map'
require 'Wizard'
require 'Books'

-- Screen window global variables / virtutal sizes enables easy scaling
SCALE = 2.5
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080
VIRTUAL_WIDTH = WINDOW_WIDTH / SCALE
VIRTUAL_HEIGHT = WINDOW_HEIGHT / SCALE

-- WIZARD SPAWN TILE
SPAWNX = 29.5
SPAWNY = 29

love.graphics.setDefaultFilter('nearest', 'nearest')
defaultfont = love.graphics.getFont()
fancyfont = love.graphics.newFont('master_fonts/CaviarDreams.ttf', 12)
nicefont = love.graphics.newFont('master_fonts/Oswald-Regular.ttf', 12) 

map = Map()

-- initialisation of objects and data
function love.load()
    love.window.setTitle('Wizard Quest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    love.mouse.setVisible(false)
    love.mouse.setRelativeMode(false)

end

function love.resize(w, h)
    push:resize(w, h)
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- -- global key released function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

-- called whenever a key is pressed
function love.keypressed(key)    
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
end

-- -- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true  
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    map:update(dt)

    -- reset all keys pressed and released this frame
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

-- called each frame, used to render to the screen
function love.draw()

    push:apply('start')
    love.graphics.translate(math.floor(-map.camX + 0.5), math.floor(-map.camY + 0.5))
    love.graphics.clear(168/255, 154/255, 154/255, 1)
    map:render()
    push:apply('end')
    
end