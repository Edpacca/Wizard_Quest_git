require 'Util'
Map = Class{}

-- Map tiles initialised in Map64 
local SCROLL_SPEED = 300

function Map:init()

    self.camX = 0
    self.camY = 0
    self.tileWidth = 32
    self.tileHeight = 32
    self.mapWidth = 62
    self.mapHeight = 62
    self.tiles = {}
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    self.spritesheet = love.graphics.newImage('master_graphics/Map/Map1_tilesheet3.png')
    self.sprites = generateQuads(self.spritesheet, 32, 32)
    self.scroll_spritesheet = love.graphics.newImage('master_graphics/Map/Scroll64.png')
    self.scrolls = generateQuads(self.scroll_spritesheet, 64, 64)
    self.glyph1 = love.graphics.newImage('master_graphics/Map/glyph1.png')
    self.glyph1_active = love.graphics.newImage('master_graphics/Map/glyph1_active.png')
    self.glyph2 = love.graphics.newImage('master_graphics/Map/glyph2.png')
    self.glyph2_active = love.graphics.newImage('master_graphics/Map/glyph2_active.png')
    self.glyph3 = love.graphics.newImage('master_graphics/Map/glyph3.png')
    self.glyph3_active = love.graphics.newImage('master_graphics/Map/glyph3_active.png')
    self.vingette = love.graphics.newImage('master_graphics/Map/vingette.png')

    self.map64 = Map64(self)
    self.items = Items(self)
    self.wizard = Wizard(self)

    self:tiling()

end

function Map:tiling()

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if (x > 8 and x < 53 and y > 2 and y < 14) or          -- top chamber

            ((y == 23 or y == 37) and x > 28 and x < 33) or     -- main circle
            ((y == 24 or y == 36) and x > 26 and x < 35) or
            ((y == 25 or y == 35) and x > 25 and x < 36) or
            ((y == 26 or y == 34) and x > 24 and x < 37) or
            (y > 26 and y < 34 and x > 23 and x < 38) or
            (y > 28 and y < 32 and (x == 23 or x == 38)) then              
                self:setTile(x, y, DIRT)
            else
                self:setTile(x, y, WALL)
            end
        end
    end

    -- self:draw_even_semicircle(30, 30, 8, 4, 1, DIRT)
    -- self:draw_even_semicircle(30, 30, 8, 4, -1, DIRT)

    self:draw_odd_circle(12, 30, 11, 3, DIRT)
    self:draw_odd_circle(49, 30, 11, 3, DIRT)
    self:draw_odd_circle(29, 46, 9, 3, DIRT)
    self:draw_odd_circle(32, 46, 9, 3, DIRT)

    self:draw_corridor(30, 2, 38, 6, DIRT)
    self:draw_corridor(18, 5, 29, 3, DIRT)
    self:draw_corridor(39, 5, 29, 3, DIRT)
    self:draw_corridor(30, 2, 14, 9, DIRT)

    -- LEFT FIRE CHAMBER
    self:setTile(12, 30, FIRE_TILE_OFF)
    self:setTile(7, 30, FIRE_TILE_OFF)

    self:setTile(7, 27, ALCOVE_ORB_OFF_E)
    self:setTile(7, 33, ALCOVE_ORB_OFF_E)
    self:setTile(8, 27, DIRT)
    self:setTile(8, 33, DIRT)
    self:setTile(7, 28, WALL_TL)
    self:setTile(7, 32, WALL_BL)

    self:setTile(6, 30, ALCOVE_ORB_OFF_E)
    self:setTile(12, 24, WALL_WINDOW)
    self:setTile(12, 25, ALCOVE_ORB_OFF_S)
    self:setTile(11, 25, WALL_TR)
    self:setTile(13, 25, WALL_TL)
    self:setTile(10, 25, WALL_TL)
    self:setTile(14, 25, WALL_TR)
    self:setTile(16, 27, WALL_WINDOW)
    self:setTile(9, 26, WALL_TORCH)
    self:setTile(15, 26, WALL_TORCH)
    self:setTile(15, 27, WALL_TR)

    self:setTile(12, 36, WALL_WINDOW)
    self:setTile(12, 35, ALCOVE_ORB_OFF_N)
    self:setTile(11, 35, WALL_BR)
    self:setTile(13, 35, WALL_BL)
    self:setTile(10, 35, WALL_BL)
    self:setTile(14, 35, WALL_BR)
    self:setTile(16, 33, WALL_WINDOW)
    self:setTile(9, 34, WALL_TORCH)
    self:setTile(15, 34, WALL_TORCH)
    self:setTile(15, 33, WALL_BR)

    -- RIGHT ICE CHAMBER
    self:setTile(49, 30, ICE_TILE_OFF)
    self:setTile(54, 30, ICE_TILE_OFF)
    self:setTile(55, 30, WALL_TORCH)

    self:setTile(47, 27, FLOOR_ORB_OFF)
    self:setTile(49, 33, FLOOR_ORB_OFF)
    self:setTile(51, 27, FLOOR_ORB_OFF)
    self:setTile(52, 31, FLOOR_ORB_OFF)
    self:setTile(46, 31, FLOOR_ORB_OFF)

    self:setTile(49, 25, WALL_WINDOW)
    self:setTile(48, 25, WALL_TR)
    self:setTile(50, 25, WALL_TL)
    self:setTile(47, 25, WALL_TL)
    self:setTile(51, 25, WALL_TR)
    self:setTile(46, 26, WALL_TORCH)
    self:setTile(52, 27, WALL_TORCH)

    self:setTile(54, 28, WALL_TR)
    self:setTile(54, 32, WALL_BR)

    self:setTile(45, 27, WALL_WINDOW)
    self:setTile(45, 33, WALL_WINDOW)
    self:setTile(46, 27, WALL_TL)
    self:setTile(46, 33, WALL_BL)

    self:setTile(49, 35, WALL_WINDOW)
    self:setTile(48, 35, WALL_BR)
    self:setTile(50, 35, WALL_BL)
    self:setTile(47, 35, WALL_BL)
    self:setTile(51, 35, WALL_BR)
    self:setTile(46, 34, WALL_TORCH)
    self:setTile(52, 33, WALL_TORCH)

    -- CENTRAL CHAMBER
    self:setTile(29, 21, WALL_WINDOW)
    self:setTile(32, 21, WALL_WINDOW)
    self:setTile(29, 23, WALL_TL)
    self:setTile(32, 23, WALL_TR)

    self:setTile(27, 24, WALL_TL)
    self:setTile(26, 25, WALL_TL)
    self:setTile(25, 26, WALL_TL)

    self:setTile(34, 24, WALL_TR)
    self:setTile(35, 25, WALL_TR)
    self:setTile(36, 26, WALL_TR)

    self:setTile(25, 34, WALL_BL)
    self:setTile(26, 35, WALL_BL)
    self:setTile(27, 36, WALL_BL)
    self:setTile(29, 37, WALL_BL)

    self:setTile(36, 34, WALL_BR)
    self:setTile(35, 35, WALL_BR)
    self:setTile(34, 36, WALL_BR)
    self:setTile(32, 37, WALL_BR)

    self:setTile(35, 24, WALL_WINDOW)
    self:setTile(36, 25, WALL_WINDOW)
    self:setTile(26, 24, WALL_WINDOW)
    self:setTile(25, 25, WALL_WINDOW)
    self:setTile(25, 35, WALL_WINDOW)
    self:setTile(26, 36, WALL_WINDOW)
    self:setTile(36, 35, WALL_WINDOW)
    self:setTile(35, 36, WALL_WINDOW)
    self:setTile(28, 37, WALL_TORCH)
    self:setTile(33, 37, WALL_TORCH)


    self:setTile(23, 29, WOOD_V)
    self:setTile(23, 30, WOOD_H)
    self:setTile(23, 31, WOOD_V)

    self:setTile(38, 29, WOOD_V)
    self:setTile(38, 30, WOOD_H)
    self:setTile(38, 31, WOOD_V)

    -- BOTTOM CHAMBER
    self:setTile(28, 42, WALL_TL)
    self:setTile(26, 44, WALL_TL)
    self:setTile(26, 48, WALL_BL)
    self:setTile(28, 50, WALL_BL)

    self:setTile(33, 42, WALL_TR)
    self:setTile(35, 44, WALL_TR)
    self:setTile(35, 48, WALL_BR)
    self:setTile(33, 50, WALL_BR)

    self:setTile(27, 42, WALL_TORCH)
    self:setTile(34, 42, WALL_TORCH)
    self:setTile(25, 44, WALL_TORCH)
    self:setTile(36, 44, WALL_TORCH)
    self:setTile(25, 48, WALL_TORCH)
    self:setTile(36, 48, WALL_TORCH)
    self:setTile(27, 50, WALL_TORCH)
    self:setTile(34, 50, WALL_TORCH)

    self:setTile(26, 43, WALL_WINDOW)
    self:setTile(35, 43, WALL_WINDOW)
    self:setTile(26, 49, WALL_WINDOW)
    self:setTile(35, 49, WALL_WINDOW)

    self:setTile(36, 45, BOOKSHELF)
    self:setTile(36, 46, BOOKSHELF)
    self:setTile(36, 47, BOOKSHELF)
    self:setTile(25, 45, BOOKSHELF)
    self:setTile(25, 46, BOOKSHELF)
    self:setTile(25, 47, BOOKSHELF)
    self:setTile(27, 43, BOOKSHELF)
    self:setTile(34, 43, BOOKSHELF)
    self:setTile(27, 49, BOOKSHELF)
    self:setTile(34, 49, BOOKSHELF)

    -- -- Block portcullis
    self:setTile(30, 22, DIRT_COLLIDABLE)
    self:setTile(31, 22, DIRT_COLLIDABLE)
    self:setTile(30, 21, DIRT_COLLIDABLE)
    self:setTile(31, 21, DIRT_COLLIDABLE)

    self:setTile(30, 15, DIRT_COLLIDABLE)
    self:setTile(31, 15, DIRT_COLLIDABLE)

end

function Map:collides(tile)

    local collidables = {
        WALL, WALL_TORCH, WALL_WINDOW, 
        ALCOVE_ORB_OFF_N, ALCOVE_ORB_OFF_S, ALCOVE_ORB_OFF_E, ALCOVE_ORB_OFF_W,
        ALCOVE_ORB_ON_N, ALCOVE_ORB_ON_S, ALCOVE_ORB_ON_E, ALCOVE_ORB_ON_W, PILLAR, 
        WALL_BL, WALL_BR, WOOD_H, WOOD_V, WOOD_H_BURNT, WOOD_V_BURNT, WOOD_H_FROZEN, WOOD_V_FROZEN, DIRT_COLLIDABLE, BOOKSHELF
    }

    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false

end

function Map:collide_noise(tile)

    local collidables = {
        WOOD_H, WOOD_V, WOOD_H_BURNT, WOOD_V_BURNT, WOOD_H_FROZEN, WOOD_V_FROZEN, BOOKSHELF
    }

    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false

end

function Map:fireball_interact(tile)

    local collidables = {
        ALCOVE_ORB_OFF_N, ALCOVE_ORB_OFF_S, ALCOVE_ORB_OFF_E, ALCOVE_ORB_OFF_W, WOOD_V, WOOD_H, WOOD_H_BURNT, WOOD_V_BURNT, WOOD_H_FROZEN, WOOD_V_FROZEN
    }

    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end


function Map:frostray_interact(tile)

    local collidables = {
        FLOOR_ORB_OFF
    }

    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map:update(dt)
    
    self.wizard:update(dt)

    self.camX = self.wizard.x - VIRTUAL_WIDTH / 2
    self.camY = self.wizard.y - VIRTUAL_HEIGHT / 2

    MOUSE_X = love.mouse.getX() + map.camX
    MOUSE_Y = love.mouse.getY() + map.camY

end

-- gets the tile type at a given pixel coordinate
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, 
        math.floor(y / self.tileHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end

function Map:draw_odd_circle(cenx, ceny, diameter, thickness, atile)

    local wl = cenx - (thickness - 1)
    local wu = cenx + (thickness - 1)
    local xl = cenx - ((diameter - 1) / 2)
    local xu = cenx + ((diameter - 1) / 2)
    local xm1 = -1
    local xm2 = 1
    
    local hl = ceny - ((diameter - 1) / 2)
    local hu = ceny

    for c = 1, 3 do
            for y = hl, hu do
                    for x = xl, xu do
                        if x > wl and x < wu then
                            self:setTile(x, y, atile)
                        end
                    end
                wl = wl + xm1
                wu = wu + xm2
            end
            
        wl = cenx - ((diameter + 1) / 2)
        wu = cenx + ((diameter + 1) / 2)
        xl = cenx - ((diameter - 1) / 2)
        xu = cenx + ((diameter - 1) / 2)
        xm1 = 1
        xm2 = -1
        hl = ceny + 1
        hu = ceny + ((diameter - 1) / 2)
    end

end

-- cenx = 30
-- ceny = 30
-- radius = 8
-- thickness = 4
-- orientation = 1

function Map:draw_even_semicircle(cenx, ceny, radius, thickness, orientation, atile)


    local wl = cenx - (orientation * thickness / 2)
    local wu = cenx + (orientation * thickness / 2) + 1
    local xm1 = -1 * orientation
    local xm2 = 1 * orientation
     
    local yl = ceny - radius + 1
    local yu = ceny
    local xl = cenx - radius + 1
    local xu = cenx + radius
      
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, yl, atile)
            end
        end
        wl = wl + ((thickness / 2) * xm1)
        wu = wu + ((thickness / 2) * xm2)
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, yl + 1, atile)
            end
        end
        wl = wl + xm1
        wu = wu + xm2
        y = yl + 2
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, y, atile)
            end
        end
        wl = wl + xm1
        wu = wu + xm2
        y = yl + 3
        for x = xl, xu do
            if x > wl and x < wu then
                self:setTile(x, y, atile)
            end
        end
        wl = wl + xm1
        wu = wu + xm2
        for y = yl + 4, yl + 5 do
            for x = xl, xu do
                if x > wl and x < wu then
                    self:setTile(x, y, atile)
                end
            end        
        end
        wl = wl + xm1
        wu = wu + xm2
        for y = yl + 5, yl + 6 do
            for x = xl, xu do
                if x > wl and x < wu then
                    self:setTile(x, y, atile)
                end
            end        
        end     
        
end

function Map:draw_corridor(x1, x_wide, y1, y_tall, atile)
    for y = y1, y1 + y_tall - 1 do
        for x = x1, x1 + x_wide - 1 do
            self:setTile(x, y, atile)
        end
    end
end

function Map:open_portcullis()
    for i = 1, 5 do

        if ACTIVE_FB_ORBS + ACTIVE_ICE_ORBS == 2 * i  then

            tiles64[1].tile64_id = PORTCULLIS[i+1]
            sounds['portcullis']:play()

            if ACTIVE_FB_ORBS + ACTIVE_ICE_ORBS == 6 then

                self:setTile(30, 22, DIRT)
                self:setTile(31, 22, DIRT)
            
            elseif ACTIVE_FB_ORBS + ACTIVE_ICE_ORBS == 10 then

                self:setTile(30, 21, DIRT)
                self:setTile(31, 21, DIRT)
                self:setTile(55, 30, ALCOVE_ORB_OFF_W)
                sounds['magic_chord']:play() 

            end
        end
    end

    if ACTIVE_FB_ORBS + ACTIVE_ICE_ORBS > 10 then

        tiles64[2].tile64_id = PORTCULLIS[6]
        self:setTile(30, 15, DIRT)
        self:setTile(31, 15, DIRT)
        sounds['portcullis']:play()
        sounds['magic_chord']:play()

    end
end

function Map:render()

    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do          
            local tile = self:getTile(x, y)
            love.graphics.draw(self.spritesheet, self.sprites[tile],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
        end
    end

    love.graphics.draw(self.spritesheet, self.sprites[PILLAR_2], (24 - 1) * self.tileWidth - 16, (27 - 1) * self.tileHeight, 0, 1.5, 2)
    love.graphics.draw(self.spritesheet, self.sprites[PILLAR_2], (24 - 1) * self.tileWidth - 16, (32 - 1) * self.tileHeight, 0, 1.5, 2)
    love.graphics.draw(self.spritesheet, self.sprites[PILLAR_2], (37 - 1) * self.tileWidth, (27 - 1) * self.tileHeight, 0, 1.5, 2)
    love.graphics.draw(self.spritesheet, self.sprites[PILLAR_2], (37 - 1) * self.tileWidth, (32 - 1) * self.tileHeight, 0, 1.5, 2)

    for y = 14, 20 do
        love.graphics.draw(self.spritesheet, self.sprites[PILLAR_2], (29 - 1) * self.tileWidth + 8, (y - 1) * self.tileHeight)
        love.graphics.draw(self.spritesheet, self.sprites[PILLAR_2], (32 - 1) * self.tileWidth - 8, (y - 1) * self.tileHeight)
    end

    -- for y = 1, self.mapHeight do
    --     for x = 1, self.mapWidth do
    --         love.graphics.setColor(1, 0, 1, 1)
    --         love.graphics.print(tostring(x + 1), (x * self.tileWidth) + 6, (y * self.tileWidth) + 2)
    --         love.graphics.setColor(0, 1, 1, 1)
    --         love.graphics.print(tostring(y + 1), (x * self.tileWidth) + 6, (y * self.tileWidth) + 10)
    --     end
    -- end

    love.graphics.setColor(1, 1, 1, 0.5)
    if ACTIVE_FB_ORBS > 4 then
        love.graphics.draw(self.glyph2_active, 478, 1052, 180 * (math.pi / 180), 0.22)
    else
        love.graphics.draw(self.glyph2, 478, 1052, 180 * (math.pi / 180), 0.22)
    end

    if ACTIVE_ICE_ORBS > 4 then
        love.graphics.draw(self.glyph1_active, 1442, 835, 0, 0.22)
    else
        love.graphics.draw(self.glyph1, 1442, 835, 0, 0.22)
    end

    if ACTIVE_ICE_ORBS + ACTIVE_FB_ORBS > 10 then
        love.graphics.draw(self.glyph3_active, 735, 710, 0, 0.45)
    else
        love.graphics.draw(self.glyph3, 735, 710, 0, 0.45)
    end

    self.wizard:render()
    self.items:render()
    self.map64:render()

    love.graphics.draw(self.vingette, self.camX, self.camY, 0, 1/SCALE, 1/SCALE)

    if FIREBALLS_ACTIVE == true then

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.items.potion_spritesheet, self.items.potion_sprites[FIRE_POTION], self.camX + 20, self.camY + 20, 0, 2, 2)
        love.graphics.setFont(fancyfont)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(tostring(remaining_fireballs), self.camX + 36, self.camY + 44)

    elseif ICE_ACTIVE == true then
        
        love.graphics.setColor(1, 1, 1, 1)        
        love.graphics.draw(self.items.potion_spritesheet, self.items.potion_sprites[ICE_POTION], self.camX + 20, self.camY + 20, 0, 2, 2)
        love.graphics.setFont(fancyfont)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(string.format("%.1f", ice_timer), self.camX + 34, self.camY + 44)

    end

    love.graphics.setFont(fancyfont)
    if IS_READING_BOOK[1] == true then

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[1], self.camX + 40, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 64, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 128, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 192, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 256, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[3], self.camX + 40 + 320, self.camY + 320)

        love.graphics.setColor(0.1, 0.05, 0, 1)
        love.graphics.print(tostring(BOOK_TEXT[1]), self.camX + 60, self.camY + 327)

    elseif IS_READING_BOOK[2] == true then

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[1], self.camX + 40, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 64, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 128, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 192, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 256, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[3], self.camX + 40 + 320, self.camY + 320)

        love.graphics.setColor(0.1, 0.05, 0, 1)
        love.graphics.print(tostring(BOOK_TEXT[2]), self.camX + 60, self.camY + 327)

    elseif IS_READING_BOOK[3] == true then

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[1], self.camX + 40, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 64, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 128, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 192, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[2], self.camX + 40 + 256, self.camY + 320)
        love.graphics.draw(self.scroll_spritesheet, self.scrolls[3], self.camX + 40 + 320, self.camY + 320)

        love.graphics.setColor(0.1, 0.05, 0, 1)
        love.graphics.print(tostring(BOOK_TEXT[3]), self.camX + 60, self.camY + 327)
    
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(mouse_img, MOUSE_X - 3, MOUSE_Y - 3)
    
end