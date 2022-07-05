-- enemy ref holder
local enemy_ref = state.enemy.list

-- movement
local function move_max_zero(i) 
  enemy_ref[i].m_max = 0 
end

-- ///////////////////////////////////////////////////////////////
--// MOVE PATH 
--///////////////////////////////////////////////////////////////

function move_path(ttype)
  
  local x = ttype.x
  local y = ttype.y

  local save_index = 0 -- index para remover items ja checados da path_final

  state.move.rand_v = ''
  state.move.rand_h = ''

  -- movimento de acordo com a ordem do path
  for i,v in ipairs(state.range.path_final) do

    -- top
    if state.range.path_final[i].x == x and state.range.path_final[i].y == y - 45 then
      state.move.rand_h = '' ; state.move.rand_v = 'top' ; save_index = i
    end

    -- left
    if state.range.path_final[i].x == x - 45 and state.range.path_final[i].y == y then
      state.move.rand_h = 'left' ; state.move.rand_v = '' ; save_index = i
      ttype.scaX = -1 -- direcao do sprite 
      -- enemy turn to player - zero move
      if func:ma_he(state.player,enemy_ref[state.enemy.index_comp]) == 45 and state.player.x < enemy_ref[state.enemy.index_comp].x and state.turn == "enemy" then
        move_max_zero(state.enemy.index_comp)
      end
    end

    -- right
    if state.range.path_final[i].x == x + 45 and state.range.path_final[i].y == y then
      state.move.rand_h = 'right' ; state.move.rand_v = '' ; save_index = i
      ttype.scaX = 1 -- direcao do sprite
      -- enemy turn to player - zero move
      if func:ma_he(state.player,enemy_ref[state.enemy.index_comp]) == 45 and state.player.x > enemy_ref[state.enemy.index_comp].x and state.turn == "enemy" then
        move_max_zero(state.enemy.index_comp)
      end
    end

    -- low
    if state.range.path_final[i].x == x and state.range.path_final[i].y == y + 45 then
      state.move.rand_h = '' ; state.move.rand_v = 'down' ; save_index = i
    end

  end

  table.remove(state.range.path_final, save_index)
  
end

-- ///////////////////////////////////////////////////////////////
--// MOVE MAIN
--///////////////////////////////////////////////////////////////

function move_main(ttype)
  
  -- auto move - path
  if state.move.ref_index == 0 and state.range.path_end == "on" then
    move_path(ttype) 
  end

  -- key move - manual
  if ttype.m_max > 0 and state.move.ref_index < 45 and state.player.trigger_auto_move then
      
    if state.move.rand_h == 'right' then ttype.x = ttype.x + 4.5 end
    if state.move.rand_h == 'left' then ttype.x = ttype.x - 4.5 end
    if state.move.rand_v == 'top' then ttype.y = ttype.y - 4.5 end
    if state.move.rand_v == 'down' then ttype.y = ttype.y + 4.5 end 
    
    state.move.ref_index = state.move.ref_index + 4.5
      
  end

  -- PLAYER
  -- walk max
  if state.move.ref_index == 45 then
    state.move.ref_index = 0
    state.move.rand_h = '' ; state.move.rand_v = ''
    state.range.path_open = "on"
    if state.turn == "move" then
      ttype.m_max = ttype.m_max - 1
    end
    if state.turn == "enemy" then
      ttype.m_max = ttype.m_max - 3 
    end
  end
  
  -- if zero, no path found, reset the auto move
  if state.range.fim.x == ttype.x and state.range.fim.y == ttype.y then
    state.player.trigger_auto_move = false
  end

  -- ENEMY
  if state.turn == "enemy" then
    if state.range.fim.x == ttype.x and state.range.fim.y == ttype.y then
      ttype.m_max = 0
    end
    if state.enemy.alert_p == "on" and func:ma_he(ttype,state.player) == 45 then 
      state.range.path_open = "on"
    end
    if ttype.m_max < 0 then
      ttype.m_max = 0
    end
  end

end