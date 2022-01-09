-- enemy ref holder
local enemy_ref = state.enemy.list

-- tabela geral com todos os retangulos da grid 
-- tipos de blocos: clear, wall, water, enemy, enem_dead, player, item
grid_global = {}

-- manhatam - distance between 2 points
function ma_he(n,f)
  local dx = math.abs(n.x - f.x) ; local dy = math.abs(n.y - f.y)
  return 1 * (dx + dy)
end

-- distance between 2 points
function distance(n,f) 
  return ((f.x-n.x)^2+(f.y-n.y)^2)^0.5 
end

-- angle between 2 points
function angle(x1,y1, x2,y2) 
  return math.atan2(y2-y1, x2-x1) 
end

-- move object towards another
function follow_object(start, base, final, speed)
  local angle_value = angle(start.x,start.y, final.x,final.y)  
  base.x = base.x + speed*math.cos(angle_value) 
  base.y = base.y + speed*math.sin(angle_value)
end

--MOUSE ACTION BOX -- get mouse location index
function mouse_action_box_update(box)
  
  local found = false

  for i,v in ipairs(state.range.open) do
    if wm.x >= state.range.open[i].x
    and wm.y >= state.range.open[i].y
    and wm.x < state.range.open[i].x + m_size_tile
    and wm.y < state.range.open[i].y + m_size_tile 
    and state.range.open[i].check == "close" then
      box.x = state.range.open[i].x
      box.y = state.range.open[i].y
      found = true
      
      --
      if state.turn == "move" then
        state.range.fim.x = box.x
        state.range.fim.y = box.y
        state.player.range_open_index = 0
        state.range.path_end = "off" -- GLOBAL
        range_path_final(state.player)
      end
      --
      
      if love.mouse.isDown(1) and state.turn == "move" then
        state.player.range_open_index = i
        state.player.trigger_auto_move = true
      end
    end
  end
  
  if found == false then
    box.x = -900
    box.y = -900
  end
    
end

function is_open_block()

  for i,v in ipairs(state.range.open) do
    if wm.x >= state.range.open[i].x
    and wm.y >= state.range.open[i].y
    and wm.x < state.range.open[i].x + m_size_tile
    and wm.y < state.range.open[i].y + m_size_tile 
    and state.range.open[i].check == "close" then
      return true
    end
  end
    
end

-- GRID GLOBAL UPDATE
function grid_global_update()
  
  for i,v in ipairs(grid_global) do

    if grid_global[i].ttype == "enemy" then 
      grid_global[i].ttype = "clear"
    end
    
    for j,w in ipairs(enemy_ref) do
      if enemy_ref[j].x == grid_global[i].x and enemy_ref[j].y == grid_global[i].y and enemy_ref[j].comp ~= "dead" then 
        grid_global[i].ttype = "enemy" 
      end 
    end
    
    if state.turn == "enemy" and enemy_ref[state.enemy.index_comp].x == grid_global[i].x and enemy_ref[state.enemy.index_comp].y == grid_global[i].y and enemy_ref[state.enemy.index_comp].comp ~= "dead" then 
      grid_global[i].ttype = "clear" 
    end 
        
  end
  
end

-- COLISION -- funcao principal de colisao simples - quando x e y sao iguais sempre 
function colisao_main(n,pos_val_x,pos_val_y)
  
  -- bloqueia mov - item and atack
  if state.turn == "item" or state.turn == "attack" then
    for i,v in ipairs(state.range.open) do
      if n.x + pos_val_x == state.range.open[i].x and n.y + pos_val_y == state.range.open[i].y 
      and state.range.open[i].check == "close" then
        return 1
      end
    end
  end

  -- bloqueia mov - move
  if state.turn == "move" then
    local position_check = false -- if position does not exist, dont move
    for i,v in ipairs(grid_global) do 
      if n.x + pos_val_x == grid_global[i].x and n.y + pos_val_y == grid_global[i].y then
        position_check = true
      end
      if grid_global[i].ttype == "wall" or grid_global[i].ttype == "enemy" then
        if n.x + pos_val_x == grid_global[i].x and n.y + pos_val_y == grid_global[i].y then
          return 1
        end
      end
    end
    if position_check == false then
      return 1
    end
  end
  
end