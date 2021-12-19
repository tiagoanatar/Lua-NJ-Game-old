-- ///////////////////////////////////////////////////////////////
--// VAR
--///////////////////////////////////////////////////////////////

local wall_rand = 0
local floor_rand = 0

local function player_draw()
    -- sprite do jogador
    love.graphics.setColor(1, 1, 1, 1)
    anim_type[state.player.atNumb]:draw(asset.player.main, state.player.x + 22, state.player.y + 15, 0, state.player.scaX, 1, 44, 30) -- 44 e 30 são o ponto de origem  
end

-- ///////////////////////////////////////////////////////////////
--// LOAD
--///////////////////////////////////////////////////////////////

function cen_design_load()
  
-- wall/floor random
wall_rand = love.math.random(1, 3)
floor_rand = love.math.random(1, 3)
  
    c_design = {
      
        -----
        -- DOJO
        -----
        dojo = {
            clear = {
              
                floor = {
                love.graphics.newImage("imgs/cen/dojo/tatame_1.png"),
                love.graphics.newImage("imgs/cen/dojo/tatame_2.png"),
                love.graphics.newImage("imgs/cen/dojo/tatame_3.png")
                },
              
                elements = {
                  
                    -- 1 - bed
                    {
                    love.graphics.newImage("imgs/cen/dojo/elements/bed_a.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/bed_b.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/bed_c.png")
                    }
                }
            },
              
            wall = {
              
                top = {
                love.graphics.newImage("imgs/cen/dojo/s_parede_1.png"),
                love.graphics.newImage("imgs/cen/dojo/s_parede_2.png"),
                love.graphics.newImage("imgs/cen/dojo/s_parede_3.png")
                },
              
                low = {
                love.graphics.newImage("imgs/cen/dojo/v_parede_1.png"),
                love.graphics.newImage("imgs/cen/dojo/v_parede_2.png"),
                love.graphics.newImage("imgs/cen/dojo/v_parede_3.png")
                },
              
                elements = {
                    -- 1 - lamp
                    {
                    love.graphics.newImage("imgs/cen/dojo/elements/lamp_a.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/lamp_b.png"), -- REMOVE/MOVE
                    love.graphics.newImage("imgs/cen/dojo/elements/lamp_c.png")
                    },
                  
                    -- 2 - armor 
                    {
                    love.graphics.newImage("imgs/cen/dojo/elements/armor_a.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/armor_b.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/armor_c.png")
                    },
            
                    -- 3 - sword
                    {
                    love.graphics.newImage("imgs/cen/dojo/elements/sword_a.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/sword_b.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/sword_c.png")
                    },
            
                    -- 4 - paint
                    {
                    love.graphics.newImage("imgs/cen/dojo/elements/pint_a.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/pint_b.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/pint_c.png")
                    },
              
                    -- 5 - box
                    {
                    love.graphics.newImage("imgs/cen/dojo/elements/box_a.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/box_b.png")
                    },
                  
                    -- 6 - box
                    {
                    love.graphics.newImage("imgs/cen/dojo/elements/box_a.png"),
                    love.graphics.newImage("imgs/cen/dojo/elements/box_b.png")
                    }
              
                }
            }
        }  
    }
    --
    
    
    
-- dojo
    
c_design.dojo.clear.floor[1]:setWrap("repeat", "repeat")
c_design.dojo.clear.floor[2]:setWrap("repeat", "repeat")
c_design.dojo.clear.floor[3]:setWrap("repeat", "repeat")
    
c_design.dojo.wall.top[1]:setWrap("repeat", "repeat")
c_design.dojo.wall.top[2]:setWrap("repeat", "repeat")
c_design.dojo.wall.top[3]:setWrap("repeat", "repeat")
    
c_design.dojo.wall.low[1]:setWrap("repeat", "repeat")
c_design.dojo.wall.low[2]:setWrap("repeat", "repeat")
c_design.dojo.wall.low[3]:setWrap("repeat", "repeat")
    
end

-- ///////////////////////////////////////////////////////////////
--// SET
--///////////////////////////////////////////////////////////////

function cen_design_set(grid)
  
local total = 0

-- QUAD

-- floor
grid_global.floor_quad = love.graphics.newQuad(0, 0, state.cenario.global.w, state.cenario.global.h, c_design.dojo.clear.floor[1]:getWidth(), c_design.dojo.clear.floor[1]:getHeight())

-- parede baixo - new quad - posição x/y(Y cuida da posição/corte do quad/imagem) - tamanho do quad -- tamanho da imagem puxada
grid_global.pared_quad_baix = love.graphics.newQuad(0, 0, 45, 50, 65, 50)
  
for i,v in ipairs(grid) do
    for j,w in ipairs(grid[i]) do
      
-- main random 
local rand = love.math.random(1, 14)

-- increment fator
total = total + 1

-----
-- DOJO
-----
if state.cenario.global.ttype == "dojo" then
  
-- CLEAR
        if grid[i][j].ttype == 0 then
            if i+1 < state.cenario.global.size and j+1 < state.cenario.global.size and i > 1 and j > 1 then
                    grid_global[total].elements = rand
                    
                    -- bed
                    if grid_global[total].elements == 1 then
                        grid_global[total].elements = 0
                    end
                    
            end
        end
      
-- WALL
        if grid[i][j].ttype == 1 then
            if i+1 < state.cenario.global.size and j+1 < state.cenario.global.size and grid[i+1][j].ttype == 0 then
                    grid_global[total].elements = rand
                    
                    -- paint
                    if grid_global[total].elements == 4 and grid[i][j+1].ttype == 0 or grid[i+1][j+1].ttype == 1 then
                        grid_global[total].elements = 0
                    end
                    
            end
        end
        
end
---

-- design random selection 
grid_global[total].design_var = love.math.random(1, 3) 
-- extra random in case of need
grid_global[total].extra_rand = love.math.random(1, 2)

    end
end
  
end

-- ///////////////////////////////////////////////////////////////
--// DRAW
--///////////////////////////////////////////////////////////////

function cen_design_draw()

-----
-- DOJO
-----
if state.cenario.global.ttype == "dojo" then
  
    -- floor
    if floor_rand == 1 then
        love.graphics.draw(c_design.dojo.clear.floor[1], grid_global.floor_quad, 0, 0)
    elseif floor_rand == 2 then
        love.graphics.draw(c_design.dojo.clear.floor[2], grid_global.floor_quad, 0, 0)
    elseif floor_rand == 3 then
        love.graphics.draw(c_design.dojo.clear.floor[3], grid_global.floor_quad, 0, 0)
    end

    -- low wall
    for n,v in ipairs(grid_global) do
        if grid_global[n].ttype == "wall" then
            if floor_rand == 1 then
                love.graphics.draw(c_design.dojo.wall.low[1], grid_global.pared_quad_baix, grid_global[n].x, grid_global[n].y + grid_global[n].h - 23)
            elseif floor_rand == 2 then
                love.graphics.draw(c_design.dojo.wall.low[2], grid_global.pared_quad_baix, grid_global[n].x, grid_global[n].y + grid_global[n].h - 23)
            elseif floor_rand == 3 then
                love.graphics.draw(c_design.dojo.wall.low[3], grid_global.pared_quad_baix, grid_global[n].x, grid_global[n].y + grid_global[n].h - 23)
            end
        end
    end

end

for n,v in ipairs(grid_global) do
  
    if state.cenario.global.ttype == "dojo" then
      
        if grid_global[n].ttype == "clear" then
          
            -- bed
            if grid_global[n].elements == 1 and grid_global[n].extra_rand  == 1 then
                if grid_global[n].design_var == 1 then
                    love.graphics.draw(c_design.dojo.clear.elements[1][1], grid_global[n].x+2, grid_global[n].y)
                elseif grid_global[n].design_var == 2 then
                    love.graphics.draw(c_design.dojo.clear.elements[1][2], grid_global[n].x+2, grid_global[n].y)
                elseif grid_global[n].design_var == 3 then
                    love.graphics.draw(c_design.dojo.clear.elements[1][3], grid_global[n].x+2, grid_global[n].y)
                end
            end
            
        end
      
        if grid_global[n].ttype == "wall" then
          
            -- lamp
            if grid_global[n].elements == 1 then
                if grid_global[n].design_var < 3 then
                    love.graphics.draw(c_design.dojo.wall.elements[2][1], grid_global[n].x+5, grid_global[n].y+44)
                elseif grid_global[n].design_var < 5 then
                    love.graphics.draw(c_design.dojo.wall.elements[2][3], grid_global[n].x+5, grid_global[n].y+34)
                end
            end
            
            -- armor
            if grid_global[n].elements == 2 then
                if grid_global[n].design_var == 1 then
                    love.graphics.draw(c_design.dojo.wall.elements[1][1], grid_global[n].x, grid_global[n].y+34)
                elseif grid_global[n].design_var == 2 then
                    love.graphics.draw(c_design.dojo.wall.elements[1][2], grid_global[n].x, grid_global[n].y+34)
                elseif grid_global[n].design_var == 3 then
                    love.graphics.draw(c_design.dojo.wall.elements[1][3], grid_global[n].x, grid_global[n].y+34)
                end
            end
            
            -- sword
            if grid_global[n].elements == 3 then
                if grid_global[n].design_var == 1 then
                    love.graphics.draw(c_design.dojo.wall.elements[3][1], grid_global[n].x, grid_global[n].y+54)
                elseif grid_global[n].design_var == 2 then
                    love.graphics.draw(c_design.dojo.wall.elements[3][2], grid_global[n].x, grid_global[n].y+54)
                elseif grid_global[n].design_var == 3 then
                    love.graphics.draw(c_design.dojo.wall.elements[3][3], grid_global[n].x, grid_global[n].y+54)
                end
            end
            
            -- paint
            if grid_global[n].elements == 4 then
                if grid_global[n].design_var == 1 then
                    love.graphics.draw(c_design.dojo.wall.elements[4][1], grid_global[n].x, grid_global[n].y+28)
                elseif grid_global[n].design_var == 2 then
                    love.graphics.draw(c_design.dojo.wall.elements[4][2], grid_global[n].x, grid_global[n].y+28)
                elseif grid_global[n].design_var == 3 then
                    love.graphics.draw(c_design.dojo.wall.elements[4][3], grid_global[n].x, grid_global[n].y+28)
                end
            end
            
            -- box
            if grid_global[n].elements == 5 then
                if grid_global[n].design_var == 1 then
                    love.graphics.draw(c_design.dojo.wall.elements[5][1], grid_global[n].x, grid_global[n].y+34)
                elseif grid_global[n].design_var == 2 then
                    love.graphics.draw(c_design.dojo.wall.elements[5][2], grid_global[n].x, grid_global[n].y+34)
                end
            end
            
        end
        
    end
    
end    

-- enemies
enemy_a_draw()

-- player
player_draw()

-----
-- TOP WALL
-----
for n,v in ipairs(grid_global) do
  
-- DOJO
    if state.cenario.global.ttype == "dojo" then
        if grid_global[n].ttype == "wall" then
            if wall_rand == 1 then
                love.graphics.draw(c_design.dojo.wall.top[1], grid_global[n].x, grid_global[n].y-22.5)
            elseif wall_rand == 2 then
                love.graphics.draw(c_design.dojo.wall.top[2], grid_global[n].x, grid_global[n].y-22.5)
            elseif wall_rand == 3 then
                love.graphics.draw(c_design.dojo.wall.top[3], grid_global[n].x, grid_global[n].y-22.5)
            end
        end
    end
    
end

-- dark move
if state.turn ~= "enemy" then 
    range_draw()
end
--
  
end