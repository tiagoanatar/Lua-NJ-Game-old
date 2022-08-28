-- enemy ref holder
local enemy_ref = state.enemy.list

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

-- ///////////////////////////////////////////////////
--// PICK SMALLER PATH - USED ON ITEMS AND BODY 
--///////////////////////////////////////////////////

local function choose_path(tipo,ene_index)

  local tab = {i={},v={}} -- first: index, second: value
  local result = 0

  local function table_feed(td,index) -- feed table with new indexes
    td.i[#td.i+1] = index
    td.v[#td.v+1] = func:ma_he(enemy_ref[ene_index],tipo[index])
  end
  
  for p,k in ipairs(item) do
    if item[p].ttype == "item" or item[p].comp == "dead" then
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

-- ///////////////////////////////////////////////////
--// GET GRID POSITION
--///////////////////////////////////////////////////

local function get_grid_position(e,d)
  
  local ey, ex, py, px, dy, dx, iy, ix -- enemy, player, dead, item
  
  for y,v in ipairs(grid_global) do
    for x,w in ipairs(grid_global[y]) do
    
      if enemy_ref[e].x == grid_global[y][x].x and enemy_ref[e].y == grid_global[y][x].y and enemy_ref[e].comp ~= "dead" then
        ey = y
        ex = x
      end 
      if state.player.x == grid_global[y][x].x and state.player.y == grid_global[y][x].y then 
        py = y
        px = x
      end 
      if d then
        if enemy_ref[d].x == grid_global[y][x].x and enemy_ref[d].y == grid_global[y][x].y and enemy_ref[d].comp == "dead" then
          dy = y
          dx = x
        end 
      end
      if grid_global[y][x].item == st_main.item.gold then
          iy = y
          ix = x
      end
    end
  end
  
  return {ey = ey, ex = ex, py = py, px = px, dy = dy, dx = dx, iy = iy, ix = ix} -- enemy, player, dead, item
end

-- ///////////////////////////////////////////////////
--// VIEW UPDATE
--///////////////////////////////////////////////////

function enemy_vision_update(dt, i)

    -----
    -- MAIN IF
    if enemy_ref[i].comp ~= "dead" and enemy_ref[i].comp ~= "sleep" and enemy_ref[i].comp ~= "confuse" then
      
      -- CHECK A - check player colisions

      -- breseham line
      local pos = get_grid_position(i)
      local find_line_player
      
      if pos.py ~= nil and pos.ey ~= nil then
        find_line_player = bresenham.los(pos.ey,pos.ex,pos.py,pos.px, function(y,x)
          if grid_global[y][x].ttype == 'wall' then return false end
            grid_global[y][x].line = true
          return true
        end)
      end
        
      if find_line_player then

        if enemy_ref[i].scaX == 1 and state.player.x >= enemy_ref[i].x or 
        enemy_ref[i].scaX == -1 and state.player.x <= enemy_ref[i].x then
          
          local dist = func:distance(enemy_ref[i],state.player) 
          
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
          
      -- CHECK B - dead body check
      for p,k in ipairs(enemy_ref) do
        if enemy_ref[p].comp == "dead" and enemy_ref[p].dead_check == "off" then
          
          -- breseham line 
          local pos = get_grid_position(i,p)
          local find_line_dead
          
          if pos.dy ~= nil and pos.ey ~= nil then
            find_line_dead = bresenham.los(pos.ey,pos.ex,pos.dy,pos.dx, function(y,x)
              if grid_global[y][x].ttype == 'wall' then return false end
                grid_global[y][x].line = true
              return true
            end)
          end
          
          local dist = func:distance(enemy_ref[i],enemy_ref[p]) 
            
          if find_line_dead and dist < 250 and enemy_ref[i].comp ~= "alert_player" then 
            
            if enemy_ref[i].scaX == 1 and enemy_ref[p].x >= enemy_ref[i].x or 
            enemy_ref[i].scaX == -1 and enemy_ref[p].x <= enemy_ref[i].x then
                
              enemy_ref[p].dead_check = "on"
              
              state.enemy.vision.dead.x = enemy_ref[p].x
              state.enemy.vision.dead.y = enemy_ref[p].y
              
              for m,n in ipairs(enemy_ref) do
                if enemy_ref[m].comp ~= "dead" then
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
      end
          
      -- CHECK C - checando se bate em item
      if enemy_ref[i].comp ~= "alert_player" and enemy_ref[i].comp ~= "alert_body" then

        -- breseham line 
        local pos = get_grid_position(i)
        local find_line_item
        
        if pos.iy ~= nil and pos.ey ~= nil then
          find_line_item = bresenham.los(pos.ey, pos.ex, pos.iy, pos.ix, function(y,x)
            if grid_global[y][x].ttype == 'wall' then return false end
              grid_global[y][x].line = true
            return true
          end)
        end
        
        if find_line_item then
          local dist = func:distance(enemy_ref[i],grid_global[pos.iy][pos.ix]) 
          if dist < 250  then
            enemy_ref[i].comp = "alert_item"
            state.enemy.vision.item.x = grid_global[pos.iy][pos.ix].x
            state.enemy.vision.item.y = grid_global[pos.iy][pos.ix].y
            if enemy_ref[i].x == grid_global[pos.iy][pos.ix].x and enemy_ref[i].y == grid_global[pos.iy][pos.ix].y and enemy_ref[i].comp == "alert_item" then
              enemy_ref[i].comp = "stop"
              grid_global[pos.iy][pos.ix].ttype = "clear"
              grid_global[pos.iy][pos.ix].item = nil
            end
          end
        end
      
      end
      
    end 
end