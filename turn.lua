local font = love.graphics.getFont()

-- ///////////////////////////////////////////////////////////////
--// TURN LOAD
--///////////////////////////////////////////////////////////////

function turn_load()

  turn = {

-- LIST

    -- bt atk
    {
      name = st_main.turn.attack,
      img = asset.ui.turn.bt_attack,
      q_ctl = 1,
      x = 0,
      y = 0
    },

    -- bt move
    {
      name = st_main.turn.move,
      img = asset.ui.turn.bt_move,
      q_ctl = 1,
      x = 0,
      y = 0
    },

    -- bt item
    {
      name = st_main.turn.item,
      img = asset.ui.turn.bt_item,
      q_ctl = 1,
      x = 0,
      y = 0
    },

    -- bt skills
    {
      name = st_main.turn.skil,
      img = asset.ui.turn.bt_skil,
      q_ctl = 1,
      x = 0,
      y = 0
    },

-- KEYS

    quad = {
      love.graphics.newQuad(0, 0, 120, 120, 240, 120), -- normal
      love.graphics.newQuad(120, 0, 120, 120, 240, 120) -- hover
    },

    size = {
      w = 48,
      h = 48
    },
    
    bt_normal = love.graphics.newQuad(0, 0, 72, 24, asset.ui.turn.bt:getDimensions()),
    bt_hover = love.graphics.newQuad(72, 0, 72, 24, asset.ui.turn.bt:getDimensions()),
    bt_q_ctl = 0,
    bt_font = 0,

  }
  
end

-- ///////////////////////////////////////////////////////////////
--// ACTION MENU
--///////////////////////////////////////////////////////////////

function turn_draw()
  
  for i,v in ipairs(turn) do
    
    -- IMAGE DRAW

    -- x position control
    local cont_x = (i - 1) * 50

    -- update x and y
    turn[i].x = camera.x + cont_x + 15
    turn[i].y = camera.y + 590
    
    -- color normalizer
    love.graphics.setColor(1, 1, 1, 1)
  
    -- deactivate in case of zero
    if state.turn ~= "enemy" and state.combat.screen == 'off' then
      if state.player.m_max == 0 and turn[i].name == "Move" then love.graphics.setColor(1, 1, 1, 0.3) end
      if state.player.a_max_use == 0 and turn[i].name == "Attack" then love.graphics.setColor(1, 1, 1, 0.3) end
      if state.player.i_max_use == 0 and turn[i].name == "Item" then love.graphics.setColor(1, 1, 1, 0.3) end
    end

    -- darken options in case of enemy turn
    if state.turn == "enemy" or state.combat.screen ~= 'off' then
      love.graphics.setColor(1, 1, 1, 0.3) -- normalizador de cor 
    end
    
    -- print image 
    love.graphics.draw(turn[i].img, turn.quad[turn[i].q_ctl], turn[i].x, turn[i].y, 0, 0.4, 0.4)

    -- TEXT DRAW 

    love.graphics.setColor(1, 1, 1, 0.4)

    local text_w = font:getWidth(turn[i].name)
    local text_margin = (turn.size.w - text_w) / 2 
    
    love.graphics.print(turn[i].name, turn[i].x + text_margin, turn[i].y - 22, 0, 1, 1)
    
    -- MOUSE AND KEY ACTIONS

    -- mouse over -- check if hit button
    if wm.x >= turn[i].x and wm.x < turn[i].x + turn.size.w and wm.y >= turn[i].y and wm.y < turn[i].y + turn.size.h
    and state.turn ~= "enemy" and state.combat.screen == 'off' then
    
      -- change animation
      turn[i].q_ctl = 2
    
      -- deactivate MOVE
      if state.player.m_max == 0 and turn[i].name == "Move" then turn[i].q_ctl = 1 end
    
      -- deactivate ATTACK
      if state.player.a_max_use == 0 and turn[i].name == "Attack" then turn[i].q_ctl = 1 end
    
      -- deactivate ITEM
      if state.player.i_max_use == 0 and turn[i].name == "Item" then turn[i].q_ctl = 1 end
    
      -- attack
      if i == 1 and love.mouse.isDown(1) and state.player.a_max_use > 0 then
        state.turn = "attack"
        atk_box_pos = "on" 
        state.range.path_open = "interupt"
      end
      -- move
      if i == 2 and love.mouse.isDown(1) and state.player.m_max > 0 then
        state.turn = "move"
        state.range.path_open = "interupt"
      end
      -- item
      if i == 3 and love.mouse.isDown(1) and state.player.i_max_use > 0 then
        state.turn = "item"
        state.range.path_open = "interupt"
        items_reset() -- permite que a tela de items seja ativida de novo mesmo que vc ja esteja no turno item
      end
      -- skill
      if i == 4 and love.mouse.isDown(1) and state.player.s_max_use > 0 then
        state.turn = "skill"
        state.range.path_open = "interupt"
      end
    else
      turn[i].q_ctl = 1
    end

    -- keyboard short cuts
    if state.turn ~= "enemy" and state.combat.screen == 'off' then
    
      if love.keyboard.isDown("a") and state.player.a_max_use > 0 then
        state.turn = "attack"
        atk_box_pos = "on" 
        state.range.path_open = "interupt"
      end
      if love.keyboard.isDown("m") and state.player.m_max > 0 then
        state.turn = "move"
        state.range.path_open = "interupt"
      end
      if love.keyboard.isDown("i") and state.player.i_max_use > 0 then
        state.turn = "item"
        state.range.path_open = "interupt"
        items_reset() -- allow item screen to be reactivated
      end
      if love.keyboard.isDown("s") then
        state.turn = "skill"
        state.range.path_open = "interupt"
      end
    
    end

  end

end 

-- ///////////////////////////////////////////////////////////////
--// TURN UPDATE 
--///////////////////////////////////////////////////////////////

function turn_update()

  -- bt end turn - hover
  if state.turn ~= "enemy" and love.mouse.getX() > 1115 and love.mouse.getX() < 1187 and love.mouse.getY() > 8 and love.mouse.getY() < 32 and state.move.key == "off" and state.range.path_end == "stop" then
  
    turn.bt_q_ctl = turn.bt_hover
    turn.bt_font = 0.5
    state.range.path_open = "free"
    
    if love.mouse.isDown(1) or love.keyboard.isDown("i") then
      state.turn = "enemy"
    end
    
  else
    turn.bt_q_ctl = turn.bt_normal
    turn.bt_font = 0
  end

  -- turn off
  if love.mouse.isDown(2) or love.keyboard.isDown("escape") then
    state.turn = "turning_off"
  end

  if state.turn == "skill" then
    turn.bt_q_ctl = turn.bt_hover
    turn.bt_font = 0
  end

  -- deactivate in case uses are zero
  if state.player.m_max == 0 and state.turn == "move" then
    state.turn = "turning_off" 
    state.range.path_end = "stop"
  end
  --[[if state.player.a_max_use == 0 and state.turn == "attack" then
    state.turn = "turning_off" 
  end
  if state.player.i_max_use == 0 and state.turn == "item" then
    state.turn = "turning_off" 
  end]]

  -- reset values
  if state.turn == "enemy" then
    state.player.m_max = state.player.m_max_new
    state.player.a_max_use = state.player.a_max_use_new
    state.player.i_max_use = state.player.i_max_use_new
  end

  -- deactivate turn
  if state.turn == "turning_off" then
    state.turn = "off"
  end

end