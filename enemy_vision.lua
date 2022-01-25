-- enemy ref holder
local enemy_ref = state.enemy.list

local central_pos = 17.5

-- ///////////////////////////////////////////////////////////////
--// ALERT PLAYER
--///////////////////////////////////////////////////////////////

function alert_player()
  for z,y in ipairs(enemy_ref) do
    if enemy_ref[z].comp ~= "dead" then
      enemy_ref[z].comp = "alert_player"
      enemy_ref[z].change_comp = "off"
      state.player.comp_alert = 4
      state.enemy.alert_p_time = 0
      state.enemy.alert_p = "on"
      --
      state.enemy.alert_d_time = 0
      state.enemy.alert_d = "off"
    end
  end
end

-- ///////////////////////////////////////////////////////////////
--// VISION RESET
--///////////////////////////////////////////////////////////////

local function enemy_visao_reset(x, base)

  base.x = enemy_ref[x].x + central_pos
  base.y = enemy_ref[x].y + central_pos
  
  enemy_ref[x].v_p_ref.x = state.player.x
  enemy_ref[x].v_p_ref.y = state.player.y 
  enemy_ref[x].loop_reset = false
  
end

-- ///////////////////////////////////////////////////////////////
--// WALL COLISION
--///////////////////////////////////////////////////////////////

local function pared_coli(i_a,i_b,v_type)
  
  if grid_global[i_b].ttype == "wall" then
    if v_type.x + enemy_ref[i_a].v_box.w >= grid_global[i_b].x 
    and v_type.x < grid_global[i_b].x + m_size_tile
    and v_type.y + enemy_ref[i_a].v_box.h >= grid_global[i_b].y 
    and v_type.y < grid_global[i_b].y + m_size_tile then
      enemy_visao_reset(i_a,v_type)
    end
  end
  
end

-- ///////////////////////////////////////////////////////////////
--// MOVE BLOCKS
--///////////////////////////////////////////////////////////////

local function move_blocks(ene,vtype,vtref,target,j)
  
  if ene.scaX == 1 and target.x >= ene.x and distance(ene,target) < 301 and distance(ene,target) > 0 then
    follow_object(ene, vtype, vtref, 30)
  elseif ene.scaX == -1 and target.x <= ene.x and distance(ene,target) < 301 and distance(ene,target) > 0 then
    follow_object(ene, vtype, vtref, 30)
  else
    enemy_visao_reset(j,vtype)
  end
  
  -- reset in case the distance is too high
  if distance(vtype,target) > 301 then
    enemy_visao_reset(j,vtype)
  end  
  
end

-- ///////////////////////////////////////////////////
--// PICK SMALLER PATH - USED ON ITEMS AND BODY 
--///////////////////////////////////////////////////

local function choose_path(tipo,ene_index)

  local tab = {i={},v={}} -- first: table index, second: table value
  local result = 0

  local function table_feed(td,index) -- feed table with new indexes
    td.i[#td.i+1] = index ; td.v[#td.v+1] = ma_he(enemy_ref[ene_index],tipo[index])
  end
  
  for p,k in ipairs(tipo) do
    if tipo[p].ttype == "item" or tipo[p].comp == "dead" then
      table_feed(tab,p)
    end
  end
  
  local function choose_index(td) -- check nearest value and choose it
    for x,y in ipairs(td.v) do
      if td.v[x] == math.min(unpack(td.v)) then 
        result = td.i[x]
      end
    end
  end
  
  choose_index(tab)
    
  return result
    
end

--//////////////////////////

local function get_grid_position(j)
  
  local ey, ex, py, px
  
  for y,v in ipairs(grid_global) do
    for x,w in ipairs(grid_global[y]) do
    
      if enemy_ref[j].x == grid_global[y][x].x and enemy_ref[j].y == grid_global[y][x].y then
        ey = y
        ex = x
      end 
      if state.player.x == grid_global[y][x].x and state.player.y == grid_global[y][x].y then 
        py = y
        px = x
      end 
      
    end
  end
  
  return {ey = ey, ex = ex, py = py, px = px}
end

-- ///////////////////////////////////////////////////
--// VISAO UPDATE
--///////////////////////////////////////////////////

function enemy_vision_update(dt)
  
  for i,v in ipairs(enemy_ref) do
   
    enemy_ref[i].loop_reset = true
  
    -- activate alert anim
    if enemy_ref[i].comp == "alert_player" then enemy_ref[i].alert_anim = 4
    elseif enemy_ref[i].comp == "alert_body" then enemy_ref[i].alert_anim = 5
    elseif enemy_ref[i].comp == "alert_desconf" then enemy_ref[i].alert_anim = 2 
    elseif enemy_ref[i].comp == "alert_item" then enemy_ref[i].alert_anim = 2 
    elseif enemy_ref[i].comp == "confuse" then enemy_ref[i].alert_anim = 6
    -- deactivate marker
    else 
      enemy_ref[i].alert_anim = 1 
    end

    -----
    -- MAIN IF
    if enemy_ref[i].comp ~= "dead" and enemy_ref[i].comp ~= "sleep" and enemy_ref[i].comp ~= "confuse" then

        -- move blocks - player
        move_blocks(enemy_ref[i],enemy_ref[i].v_p,enemy_ref[i].v_p_ref,state.player,i)

        -- declaracao extra de alert player 
        if enemy_ref[i].scaX == 1 and state.player.x >= enemy_ref[i].x and ma_he(enemy_ref[i],state.player) == 45 then
          alert_player()
        elseif enemy_ref[i].scaX == -1 and state.player.x <= enemy_ref[i].x and ma_he(enemy_ref[i],state.player) == 45 then
          alert_player()
        end
        
        local pos = get_grid_position(i)
        
        local find_line

        -- breseham line 
        if pos.py ~= nil and pos.ey ~= nil then
          find_line = bresenham.los(pos.ey,pos.ex,pos.py,pos.px, function(y,x)
            if grid_global[y][x].ttype == 'wall' then return false end
              grid_global[y][x].line = true
            return true
          end)
        end
        
        -- CHECK A - check player colisions
        if find_line then

          if enemy_ref[i].scaX == 1 and state.player.x >= enemy_ref[i].x or 
          enemy_ref[i].scaX == -1 and state.player.x <= enemy_ref[i].x then
            
            local dist = distance(enemy_ref[i],state.player) 
            
            -- activate alert destrust
            if dist < 250 and enemy_ref[i].comp ~= "alert_player" and 
            enemy_ref[i].comp ~= "alert_body" then 
              enemy_ref[i].comp = "alert_desconf"
              state.player.comp_alert = 2
              state.enemy.alert_d_time = 0
              state.enemy.alert_d = "on"
            end
            
            -- activate alert player
            if dist < 200 then 
              alert_player()
            end
          
          end
            
        end
          
        -- CHECK C - checando se bate em corpo
        for p,k in ipairs(enemy_ref) do
          if enemy_ref[p].comp == "dead" and enemy_ref[p].dead_check == "off" then
            
            -- move blocs - enemy dead  
            move_blocks(enemy_ref[i],enemy_ref[i].v_e,enemy_ref[choose_path(enemy_ref,p)],enemy_ref[choose_path(enemy_ref,p)],i)
              
            if enemy_ref[i].v_e.x + enemy_ref[i].v_box.w >= enemy_ref[p].x 
            and enemy_ref[i].v_e.x < enemy_ref[p].x + m_size_tile
            and enemy_ref[i].v_e.y + enemy_ref[i].v_box.h >= enemy_ref[p].y 
            and enemy_ref[i].v_e.y < enemy_ref[p].y + m_size_tile then
                  
              enemy_ref[p].dead_check = "on"
              
              if enemy_ref[p].comp ~= "alert_player" then
                state.enemy.vision.dead.x = enemy_ref[p].x
                state.enemy.vision.dead.y = enemy_ref[p].y
              end
              
              for m,n in ipairs(enemy_ref) do
                if enemy_ref[m].comp ~= "dead" and enemy_ref[m].comp ~= "alert_player" then
                  enemy_ref[m].comp = "alert_body"
                  enemy_ref[m].change_comp = "off"
                  
                  state.player.comp_alert = 5 -- player global var
                  state.enemy.alert_p_time = 0
                  state.enemy.alert_p = "on"
                  --
                  state.enemy.alert_d_time = 0
                  state.enemy.alert_d = "off"
                end
              end

            end
      
          end
        end
          
        -- CHECK D - checando se bate em item 
        for p,k in ipairs(grid_global) do
                
          if grid_global[p].item == "Gold" and enemy_ref[i].comp ~= "alert_player" and enemy_ref[i].comp ~= "alert_body" then
            
            -- mover blocos
            if enemy_ref[i].comp ~= "alert_item" then
              move_blocks(enemy_ref[i],enemy_ref[i].v_i,grid_global[choose_path(grid_global,i)],grid_global[choose_path(grid_global,i)],i)
            end
            
            if enemy_ref[i].v_i.x + enemy_ref[i].v_box.w >= grid_global[p].x 
            and enemy_ref[i].v_i.x < grid_global[p].x + m_size_tile
            and enemy_ref[i].v_i.y + enemy_ref[i].v_box.h >= grid_global[p].y 
            and enemy_ref[i].v_i.y < grid_global[p].y + m_size_tile then
              state.enemy.vision.item.x = grid_global[p].x
              state.enemy.vision.item.y = grid_global[p].y
              enemy_ref[i].comp = "alert_item"
            end
      
            if enemy_ref[i].x == grid_global[p].x and enemy_ref[i].y == grid_global[p].y then
              enemy_ref[i].comp = "stop"
              grid_global[p].ttype = "clear"
              grid_global[p].item = nil
            end
        
          end
          
        end

    end 
  end 
end