func = {}

-- manhatam - distance between 2 points
function func:ma_he(n,f)
  local dx = math.abs(n.x - f.x) ; local dy = math.abs(n.y - f.y)
  return 1 * (dx + dy)
end

-- distance between 2 points
function func:distance(n,f) 
  return ((f.x-n.x)^2+(f.y-n.y)^2)^0.5 
end

-- angle between 2 points
function func:angle(x1,y1, x2,y2) 
  return math.atan2(y2-y1, x2-x1) 
end

-- move object towards another
function func:follow_object(start, base, final, speed)
  local angle_value = angle(start.x,start.y, final.x,final.y)  
  base.x = base.x + speed*math.cos(angle_value) 
  base.y = base.y + speed*math.sin(angle_value)
end

-- MOUSE ACTION BOX -- get mouse location index
function func:mouse_action_box_update(box)
  
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
      if state.turn.current == state.turn.ttype.move then
        state.range.fim.x = box.x
        state.range.fim.y = box.y
        range_path_final(state.player)
      end
      --
      
      if love.mouse.isDown(1) and state.turn.current == state.turn.ttype.move then
        state.player.trigger_auto_move = true
      end
    end
  end
  
  if found == false then
    box.x = -900
    box.y = -900
  end
    
end

-- check if space is avalible for moving
function func:is_open_block()

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