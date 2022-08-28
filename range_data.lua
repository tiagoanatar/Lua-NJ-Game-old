local current = {x = 0, y = 0} -- current position
local index_tab = {} -- save indexes will be used
local move_points, current_index = 0, 0 -- move points, current index
local end_main_loop = "on" -- finalization var

-- global ref
local r = state.range

local function tab_add()
  return {
    check = "off", -- off(never checked), close(alredy checked)
    x = 0, y = 0, w = 45, h = 45, m_po = 0, final_check = "off"
  }
end

local function tab_feed(y,x)
  table.insert(r.open, tab_add())
  r.open[#r.open].x = grid_global[y][x].x
  r.open[#r.open].y = grid_global[y][x].y  
end

-- ///////////////////////////////////////////////////////////////
--// TABLE CLEAN
--///////////////////////////////////////////////////////////////

local function clean_tables()
  for i, v in ipairs(r.open) do r.open[i] = nil end
  for i, v in ipairs(index_tab) do index_tab[i] = nil end
  for i, v in ipairs(r.path_final) do r.path_final[i] = nil end
end

-- ///////////////////////////////////////////////////////////////
--// PATH OPEN TABLE FEED
--///////////////////////////////////////////////////////////////

local function range_open_grid(ttype)
  
  -- clean all tables
  clean_tables()

  -- colision page
  grid_global_update() --GLOBAL
  
  for y,v in ipairs(grid_global) do
    for x,w in ipairs(grid_global[y]) do
      
      -- MOVE
      if state.turn.current == state.turn.ttype.move then
        if grid_global[y][x].ttype == "clear" or grid_global[y][x].ttype == "item" then
          tab_feed(y,x)
        end
      end
      
      -- ITEM
      if state.turn.current == state.turn.ttype.item and func:ma_he(grid_global[y][x],ttype) <= (45 * ttype.i_max) then  
        if grid_global[y][x].ttype == "clear" or grid_global[y][x].ttype == "enemy" or grid_global[y][x].ttype == "item" then
          tab_feed(y,x)
        end
      end
      
      -- ATTACK
      if state.turn.current == state.turn.ttype.attack and func:ma_he(grid_global[y][x],ttype) <= (45 * ttype.a_max) then  
        if grid_global[y][x].ttype == "clear" or grid_global[y][x].ttype == "enemy" or grid_global[y][x].ttype == "item" then
          tab_feed(y,x)
        end
      end
      
      -- ENEMY
      if state.turn.current == state.turn.ttype.enemy then  
        if grid_global[y][x].ttype == "clear" or grid_global[y][x].ttype == "item" then
          tab_feed(y,x)
        end
      end
      
      -- save current index
      if #r.open > 0 then
        if r.open[#r.open].x == current.x and r.open[#r.open].y == current.y then
          current_index = #r.open
          r.open[#r.open].check = "close"
        end
      end
    
    end -- END FOR
  end -- END FOR

end

-- ///////////////////////////////////////////////////////////////
--// START SETUP
--///////////////////////////////////////////////////////////////

local function start_setup(ttype)

  -- start point
  current.x = ttype.x
  current.y = ttype.y

  -- table feed
  range_open_grid(ttype)
  
  -- equals range to current move points of hero
  if state.turn.current == state.turn.ttype.move then
    move_points = ttype.m_max
  elseif state.turn.current == state.turn.ttype.item then
    move_points = ttype.i_max
  elseif state.turn.current == state.turn.ttype.attack then
    move_points = ttype.a_max
  elseif state.turn.current == state.turn.ttype.enemy then
    move_points = ttype.m_max
  end
    
  end_main_loop = "off"

end

-- ///////////////////////////////////////////////////////////////
--// MAIN STRUCTURE
--///////////////////////////////////////////////////////////////

function range_path_main(ttype)

  -- start setup
  start_setup(ttype)

  -- main loop
  while end_main_loop == "off" and move_points > 0 do

    for j,w in ipairs(r.open) do
      if func:ma_he(r.open[j],current) == 45 and r.open[current_index].m_po < move_points 
      and r.open[j].check == "off" then
        r.open[j].m_po = r.open[current_index].m_po + 1
        r.open[j].check = "close"
        table.insert(index_tab,1,j)
      end
    end
    if #index_tab > 0 then
      current.x = r.open[index_tab[#index_tab]].x
      current.y = r.open[index_tab[#index_tab]].y
      current_index = index_tab[#index_tab]
      table.remove(index_tab, #index_tab)
    end

    if #index_tab == 0 then end_main_loop = "on" end

  end

end

-- ///////////////////////////////////////////////////////////////
--// PATH FIND FUNCTION
--///////////////////////////////////////////////////////////////

function range_path_final(ttype)
  
  local final_block_once = true
  local found_location = false

  local t_i = 0 -- current check table index
  local min_val_tab = {i={},v={}}
  local found_l_tab = {i={},v={},x={},y={}}
  
  -- table copy to avoid mutations
  local copy = r.open

  r.temp.x = r.fim.x
  r.temp.y = r.fim.y

-- ENEMY ONLY - in case target is outside the range_open
  if state.turn.current == state.turn.ttype.enemy then
      
    for j,w in ipairs(copy) do
      if r.temp.x == copy[j].x and r.temp.y == copy[j].y and copy[j].check == "close" then
        found_location = true
      end
    end
        
    if found_location == false then
      -- feed
      for i,v in ipairs(copy) do
        if copy[i].check == "close" then
          found_l_tab.i[#found_l_tab.i + 1] = i
          found_l_tab.v[#found_l_tab.v + 1] = func:ma_he(copy[i],state.player)
          found_l_tab.x[#found_l_tab.x + 1] = copy[i].x
          found_l_tab.y[#found_l_tab.y + 1] = copy[i].y
        end
      end
      -- check
      for i,v in ipairs(found_l_tab.v) do
        if found_l_tab.v[i] == math.min(unpack(found_l_tab.v)) then 
          r.temp.x = found_l_tab.x[i]
          r.temp.y = found_l_tab.y[i]
          found_location = true
        end
      end
      -- delete
      for i, iv in ipairs(found_l_tab.i) do 
        found_l_tab.i[i] = nil
        found_l_tab.v[i] = nil
        found_l_tab.x[i] = nil
        found_l_tab.y[i] = nil
      end   
    end
    
  end

-- MAIN LOOP
  while r.temp.x ~= ttype.x or r.temp.y ~= ttype.y do

    for j,w in ipairs(copy) do
      if r.temp.x == copy[j].x and r.temp.y == copy[j].y and final_block_once == true and copy[j].check == "close" then 
        copy[j].final_check = "on" 
        table.insert(r.path_final, tab_add())
        r.path_final[#r.path_final].x = copy[j].x
        r.path_final[#r.path_final].y = copy[j].y
        final_block_once = false
      end
        
      if func:ma_he(copy[j],r.temp) == 45 and copy[j].final_check == "off" and copy[j].check == "close" then
        min_val_tab.i[#min_val_tab.i + 1] = j
        min_val_tab.v[#min_val_tab.v + 1] = copy[j].m_po
        copy[j].final_check = "on"
      end
    end
    
    for i,v in ipairs(min_val_tab.v) do
      if min_val_tab.v[i] == math.min(unpack(min_val_tab.v)) then 
        t_i = min_val_tab.i[i]
      end
    end
    
    if t_i == 0 then
      r.temp.x = ttype.x
      r.temp.y = ttype.y
    end
    
    if t_i > 0 then
      r.temp.x = copy[t_i].x
      r.temp.y = copy[t_i].y
    
      if r.temp.x ~= ttype.x or r.temp.y ~= ttype.y then
        table.insert(r.path_final, tab_add())
        r.path_final[#r.path_final].x = copy[t_i].x
        r.path_final[#r.path_final].y = copy[t_i].y
      end
    
      t_i = 0
    end

    for j, w in ipairs(min_val_tab.i) do 
      min_val_tab.i[j] = nil
      min_val_tab.v[j] = nil 
    end
  
  end -- END WHILE
  
end

-- ///////////////////////////////////////////////////////////////
--// DRAW
--///////////////////////////////////////////////////////////////

function range_draw()
  
  for i,v in ipairs(r.open) do
    if r.open[i].check == "close" and state.turn.current ~= state.turn.ttype.off then
      love.graphics.setColor(0,0,0,0.6)
      love.graphics.rectangle("fill", r.open[i].x, r.open[i].y, r.open[i].w, r.open[i].h)

      --love.graphics.setColor(1,1,1,1)
      --love.graphics.setFont(font1)
      --love.graphics.print(r.open[i].m_po, r.open[i].x + 5, r.open[i].y + 5, 0, 1, 1)
      --love.graphics.print(ma_he(r.open[i],state.player), r.open[i].x + 5, r.open[i].y + 20, 0, 1, 1)
    end 
  end  

  -- path final tab
  for i,v in ipairs(r.path_final) do
    love.graphics.setColor(0.5,0.4,1,0.8)
    love.graphics.rectangle("fill", r.path_final[i].x, r.path_final[i].y, 45, 45)
  end

end