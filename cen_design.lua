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

-- QUAD

-- floor
grid_global.floor_quad = love.graphics.newQuad(0, 0, state.cenario.global.w, state.cenario.global.h, c_design.dojo.clear.floor[1]:getWidth(), c_design.dojo.clear.floor[1]:getHeight())

-- parede baixo - new quad - posição x/y(Y cuida da posição/corte do quad/imagem) - tamanho do quad -- tamanho da imagem puxada
grid_global.pared_quad_baix = love.graphics.newQuad(0, 0, 45, 50, 65, 50)
  
for i,v in ipairs(grid_global) do
    for j,w in ipairs(grid_global[i]) do
      
-- main random 
local rand = love.math.random(1, 14)

-----
-- DOJO
-----
if state.cenario.global.ttype == "dojo" then
  
-- CLEAR
        if grid_global[i][j].ttype == 'clear' then
            if i+1 < state.cenario.global.size and j+1 < state.cenario.global.size and i > 1 and j > 1 then
                    grid_global[i][j].elements = rand
                    
                    -- bed
                    if grid_global[i][j].elements == 1 then
                        grid_global[i][j].elements = 0
                    end
                    
            end
        end
      
-- WALL
        if grid_global[i][j].ttype == 'wall' then
            if i+1 < state.cenario.global.size and j+1 < state.cenario.global.size and grid_global[i+1][j].ttype == 'clear' then
                    grid_global[i][j].elements = rand
                    
                    -- paint
                    if grid_global[i][j].elements == 4 and grid_global[i][j+1].ttype == 'clear' or grid_global[i+1][j+1].ttype == 'wall' then
                        grid_global[i][j].elements = 0
                    end
                    
            end
        end
        
end
---

-- design random selection 
grid_global[i][j].design_var = love.math.random(1, 3) 
-- extra random in case of need
grid_global[i][j].extra_rand = love.math.random(1, 2)

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
  for y,v in ipairs(grid_global) do
    for x,i in ipairs(grid_global[y]) do
      if grid_global[y][x].ttype == "wall" then
        if floor_rand == 1 then
          love.graphics.draw(c_design.dojo.wall.low[1], grid_global.pared_quad_baix, grid_global[y][x].x, grid_global[y][x].y + grid_global[y][x].h - 23)
        elseif floor_rand == 2 then
          love.graphics.draw(c_design.dojo.wall.low[2], grid_global.pared_quad_baix, grid_global[y][x].x, grid_global[y][x].y + grid_global[y][x].h - 23)
        elseif floor_rand == 3 then
          love.graphics.draw(c_design.dojo.wall.low[3], grid_global.pared_quad_baix, grid_global[y][x].x, grid_global[y][x].y + grid_global[y][x].h - 23)
        end
      end
    end
  end

  for y,v in ipairs(grid_global) do
    for x,i in ipairs(grid_global[y]) do
  
    if state.cenario.global.ttype == "dojo" then
      
      if grid_global[y][x].ttype == "clear" then
        -- bed
        if grid_global[y][x].elements == 1 and grid_global[y][x].extra_rand  == 1 then
          if grid_global[y][x].design_var == 1 then
            love.graphics.draw(c_design.dojo.clear.elements[1][1], grid_global[y][x].x+2, grid_global[y][x].y)
          elseif grid_global[y][x].design_var == 2 then
            love.graphics.draw(c_design.dojo.clear.elements[1][2], grid_global[y][x].x+2, grid_global[y][x].y)
          elseif grid_global[y][x].design_var == 3 then
            love.graphics.draw(c_design.dojo.clear.elements[1][3], grid_global[y][x].x+2, grid_global[y][x].y)
          end
        end
      end
      
      if grid_global[y][x].ttype == "wall" then
        -- lamp
        if grid_global[y][x].elements == 1 then
          if grid_global[y][x].design_var < 3 then
            love.graphics.draw(c_design.dojo.wall.elements[2][1], grid_global[y][x].x+5, grid_global[y][x].y+44)
          elseif grid_global[y][x].design_var < 5 then
            love.graphics.draw(c_design.dojo.wall.elements[2][3], grid_global[y][x].x+5, grid_global[y][x].y+34)
          end
        end
            
        -- armor
        if grid_global[y][x].elements == 2 then
          if grid_global[y][x].design_var == 1 then
            love.graphics.draw(c_design.dojo.wall.elements[1][1], grid_global[y][x].x, grid_global[y][x].y+34)
          elseif grid_global[y][x].design_var == 2 then
            love.graphics.draw(c_design.dojo.wall.elements[1][2], grid_global[y][x].x, grid_global[y][x].y+34)
          elseif grid_global[y][x].design_var == 3 then
            love.graphics.draw(c_design.dojo.wall.elements[1][3], grid_global[y][x].x, grid_global[y][x].y+34)
          end
        end
            
            -- sword
            if grid_global[y][x].elements == 3 then
                if grid_global[y][x].design_var == 1 then
                  love.graphics.draw(c_design.dojo.wall.elements[3][1], grid_global[y][x].x, grid_global[y][x].y+54)
                elseif grid_global[y][x].design_var == 2 then
                  love.graphics.draw(c_design.dojo.wall.elements[3][2], grid_global[y][x].x, grid_global[y][x].y+54)
                elseif grid_global[y][x].design_var == 3 then
                  love.graphics.draw(c_design.dojo.wall.elements[3][3], grid_global[y][x].x, grid_global[y][x].y+54)
                end
            end
            
            -- paint
            if grid_global[y][x].elements == 4 then
                if grid_global[y][x].design_var == 1 then
                    love.graphics.draw(c_design.dojo.wall.elements[4][1], grid_global[y][x].x, grid_global[y][x].y+28)
                elseif grid_global[y][x].design_var == 2 then
                    love.graphics.draw(c_design.dojo.wall.elements[4][2], grid_global[y][x].x, grid_global[y][x].y+28)
                elseif grid_global[y][x].design_var == 3 then
                    love.graphics.draw(c_design.dojo.wall.elements[4][3], grid_global[y][x].x, grid_global[y][x].y+28)
                end
            end
            
            -- box
            if grid_global[y][x].elements == 5 then
                if grid_global[y][x].design_var == 1 then
                    love.graphics.draw(c_design.dojo.wall.elements[5][1], grid_global[y][x].x, grid_global[y][x].y+34)
                elseif grid_global[y][x].design_var == 2 then
                    love.graphics.draw(c_design.dojo.wall.elements[5][2], grid_global[y][x].x, grid_global[y][x].y+34)
                end
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
  for y,v in ipairs(grid_global) do
    for x,i in ipairs(grid_global[y]) do
      -- DOJO
      if state.cenario.global.ttype == "dojo" then
        if grid_global[y][x].ttype == "wall" then
          if wall_rand == 1 then
            love.graphics.draw(c_design.dojo.wall.top[1], grid_global[y][x].x, grid_global[y][x].y-22.5)
          elseif wall_rand == 2 then
            love.graphics.draw(c_design.dojo.wall.top[2], grid_global[y][x].x, grid_global[y][x].y-22.5)
          elseif wall_rand == 3 then
            love.graphics.draw(c_design.dojo.wall.top[3], grid_global[y][x].x, grid_global[y][x].y-22.5)
          end
        end
      end
      
      -- LINE TEMPO DRAW
      if grid_global[y][x].line == true then
        love.graphics.setColor(0.5,0,0,0.8)
        love.graphics.rectangle("fill", grid_global[y][x].x, grid_global[y][x].y, 45, 45)
      end
      
      -- ITEM TEST 
      --if grid_global[y][x].ttype == "item" then
        --love.graphics.print(grid_global[y][x].item, grid_global[y][x].x + 10, grid_global[y][x].y + 10, 0, 1, 1)
      --end
      
    end
  end
  
end
-- dark move
if state.turn ~= "enemy" then 
    range_draw()
end
--
  
end