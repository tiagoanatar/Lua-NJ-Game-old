
-- scaX = escala x (usado para inverção de sprite)
-- atNumb = Numero da animação usada para player

-- mous relase click
local mouse_release = true

-- ///////////////////////////////////////////////////////////////
--// FUNCTIONS
--///////////////////////////////////////////////////////////////

-- 1 // movimento ///////////////////////////////////////////
-- /////////////////////////////////////////////////////////

local function play_mov()

  -- change direction on keys
  if key_l then
    state.player.scaX = -1
  elseif key_r then
    state.player.scaX = 1
  end

  -- mouse click control
  if love.mouse.isDown(1) == false and state.range.path_end == "stop" then
    mouse_release = true
  end
  
  -- mouse move
  if mouse_release == true and state.move.key == "off" and state.range.path_end == "stop" and state.turn == "move" then
    
    -- update all the time to get the index
    mouse_action_box_update(state.player.m_box)

    if state.player.range_open_index > 0 then
      state.range.fim.x = state.range.open[state.player.range_open_index].x
      state.range.fim.y = state.range.open[state.player.range_open_index].y
      state.player.range_open_index = 0
      state.range.path_end = "off" -- GLOBAL
      range_path_final(state.player) -- GLOBAL
      mouse_release = false
    end
      
  end

  -- PLAYER RESET - if reach destiny stop
  if state.range.path_end == "on" and state.turn == "move" and state.range.fim.x == state.player.x 
  and state.range.fim.y == state.player.y then 
    state.range.path_end = "stop"
  end

  -- keys move
  if key_l and state.move.ref_index == 0 and state.player.m_max > 0 and colisao_main(state.player,-45,0) ~= 1 and key_r == false 
  and key_u == false and key_d == false and state.range.path_end == "stop" and state.move.key == "off" then
    state.move.rand_h = 2 ; state.move.rand_v = 0
    state.move.key = "on"
  end 

  if key_r and state.move.ref_index == 0 and state.player.m_max > 0 and colisao_main(state.player,45,0) ~= 1 and key_l == false 
  and key_u == false and key_d == false and state.range.path_end == "stop" and state.move.key == "off" then
    state.move.rand_h = 1 ; state.move.rand_v = 0
    state.move.key = "on"
  end  

  if key_u and state.move.ref_index == 0 and state.player.m_max > 0 and colisao_main(state.player,0,-45) ~= 1 and key_l == false 
  and key_r == false and key_d == false and state.range.path_end == "stop" and state.move.key == "off" then
    state.move.rand_h = 0 ; state.move.rand_v = 1
    state.move.key = "on"
  end

  if key_d and state.move.ref_index == 0 and state.player.m_max > 0 and colisao_main(state.player,0,45) ~= 1 and key_l == false 
  and key_r == false and key_u == false and state.range.path_end == "stop" and state.move.key == "off" then
    state.move.rand_h = 0 ; state.move.rand_v = 2
    state.move.key = "on"
  end  

  -- move function
  if state.move.key == "on" or state.range.path_end == "on" then
    move_main(state.player)
  end

end
--

-- 2 // ataque ///////////////////////////////////////////
-- /////////////////////////////////////////////////////////

local function play_ataque_draw()
  
  -- atack box
  love.graphics.setColor(1, 0.5, 0.1, 1)
  love.graphics.rectangle("fill", state.player.a_box.x, state.player.a_box.y, state.player.a_box.w, state.player.a_box.h)
      
end 

local function play_ataque_move()
      
  if key_l and key_r == false and key_u == false and key_d == false and atk_click == "off" 
  and colisao_main(state.player.a_box,-45,0) == 1 then
    a_box.x = a_box.x - 45
    atk_click = "on"
  end 
  
  if key_r and key_l == false and key_u == false and key_d == false and atk_click == "off" 
  and colisao_main(state.player.a_box,45,0) == 1 then
    a_box.x = a_box.x + 45
    atk_click = "on"
  end  
  
  if key_u and key_l == false and key_r == false and key_d == false and atk_click == "off" 
  and colisao_main(state.player.a_box,0,-45) == 1 then
    a_box.y = a_box.y - 45
    atk_click = "on"
  end
  
  if key_d and key_l == false and key_r == false and key_u == false and atk_click == "off" 
  and colisao_main(state.player.a_box,0,45) == 1  then
    a_box.y = a_box.y + 45
    atk_click = "on"
  end  
      
  -- liberando movimento
  if key_l == false and key_r == false and key_u == false and key_d == false then 
    atk_click = "off"
  end

  -- mouse box move
  mouse_action_box_update(state.player.a_box)

  for i,v in ipairs(state.enemy.list) do
    if state.enemy.list[i].comp ~= "dead" and state.player.a_max_use > 0 and state.combat.screen == "off" then
      if key_space or love.mouse.isDown(1) then
        if state.player.a_box.x == state.enemy.list[i].x and state.player.a_box.y == state.enemy.list[i].y then
          state.combat.atack_active = 'on'
          state.combat.enemy_index = i
          state.player.a_max_use = state.player.a_max_use - 1
        end
      end
    end
  end
  
end

-- ///////////////////////////////////////////////////////////////
--// PLAYER LOAD
--///////////////////////////////////////////////////////////////

function play_load()

  -- Anima8
  anim_grid = anim8.newGrid(88, 60, asset.player.main:getWidth(), asset.player.main:getHeight())
      
  -- Anim types
  anim_type = {
    anim8.newAnimation(anim_grid('1-2',1), 1), -- 1 -- parado -- sprites 1 a 2, linha 1, velocidade 0.1
    anim8.newAnimation(anim_grid('1-4',2), 0.15), -- 2 -- ataque
    anim8.newAnimation(anim_grid('1-2',3), 0.20) -- 3 -- andando
  }

  p_alert_grid = anim8.newGrid(20, 19, asset.player.alert_icon:getWidth(), asset.player.alert_icon:getHeight())

  p_alert_table = {
    anim8.newAnimation(p_alert_grid('1-1',1), 1, "pauseAtEnd"), -- 1 -- nada -- sprites 2 a 5, linha 1, velocidade 0.1
    anim8.newAnimation(p_alert_grid('2-2',1), 1, "pauseAtEnd"), -- 2 -- duvida
    anim8.newAnimation(p_alert_grid('3-3',1), 1, "pauseAtEnd"), -- 3 -- zzz
    anim8.newAnimation(p_alert_grid('4-4',1), 1, "pauseAtEnd"), -- 4 -- viu
    anim8.newAnimation(p_alert_grid('5-5',1), 1, "pauseAtEnd"), -- 5 -- viu dead
    anim8.newAnimation(p_alert_grid('6-6',1), 1, "pauseAtEnd") -- 6 -- m
  }

end 

-- ///////////////////////////////////////////////////////////////
--// PLAYER UPDATE
--///////////////////////////////////////////////////////////////

function play_update(dt)

  -- item reset
  if state.turn ~= "item" then
    items_reset()
  end

  -- item update
  if state.turn == "item" then
    items_use()
  end

  -- item combat activate
  items_enemy_effect()  

  -- attack box update
  if state.turn ~= "attack" then
    state.player.a_box.x = state.player.x
    state.player.a_box.y = state.player.y
  end

  if state.turn ~= "off" and state.turn ~= "enemy" and state.range.path_end ~= "off" and state.range.path_end ~= "on" then
    --range calculation  
    if state.move.ref_index == 0 and state.range.path_open == "free" then
      state.range.path_open = "on"
    end
    range_path_main(state.player)
  end
  
  -- keys functions
  key_l = love.keyboard.isDown("left")
  key_r = love.keyboard.isDown("right")
  key_u = love.keyboard.isDown("up")
  key_d = love.keyboard.isDown("down")
  key_space = love.keyboard.isDown("space")
  
  -- #01 - movimento + anim andando
  -----
  if state.turn == "move" then
    play_mov() -- movimento
    state.player.atNumb = 3
    if state.move.ref_index > 0 then
      anim_type[3]:update(dt)
    end
  end

  -- #02 - anim ataque
  if state.turn == "attack" then
    play_ataque_move() -- atacar movimento
    if state.combat.screen == "on" then
      --state.player.atNumb = 2
      --anim_type[2]:update(dt)
    end
    -- change direction on mouse
    if wm.x < state.player.x then
      state.player.scaX = -1
    else
      state.player.scaX = 1
    end
  end

  -- #03 -anim parado
  if state.turn == "off" or state.turn == "enemy" then
    state.player.atNumb = 1
    anim_type[1]:update(dt)
  end

end

-- ///////////////////////////////////////////////////////////////
--// PLAYER DRAW
--///////////////////////////////////////////////////////////////

function play_draw()
  
-- hit box
--love.graphics.setColor(1, 1, 1, 0.2)
--love.graphics.rectangle("fill", state.range.fim.x, state.range.fim.y, state.player.w, state.player.h)

--[[ testando tudo que nao for clear
for i,v in ipairs(grid_global) do
--    if grid_global[i].ttype == "clear" then
    
    love.graphics.setColor(0.4,0.2,0.4,0.3)
    love.graphics.rectangle("fill", grid_global[i].x, grid_global[i].y, grid_global[i].w, grid_global[i].h)
    love.graphics.setColor(1, 1, 1, 1) -- normalizador de cor
    love.graphics.setFont(asset.ui.f1)
    love.graphics.print(grid_global[i].x, grid_global[i].x + 5, grid_global[i].y + 10, 0, 1, 1)
    love.graphics.print(grid_global[i].y, grid_global[i].x + 5, grid_global[i].y + 30, 0, 1, 1)
    
--    end
end]]--

  -- atacar
  if state.turn == "attack" then
    play_ataque_draw()
  end

  -- move box
  if state.turn == "move" then
    love.graphics.setColor(1, 0.5, 0.1, 1)
    love.graphics.rectangle("fill", state.player.m_box.x, state.player.m_box.y, state.player.m_box.w, state.player.m_box.h)
  end

  -- alert icon
  love.graphics.setColor(1,1,1,1)
  p_alert_table[state.player.comp_alert]:draw(asset.player.alert_icon, camera.x +30, camera.y +60, 0, 1, 1, 20, 19)
  
end

-- ///////////////////////////////////////////////////////////////
--// PLAYER UI
--///////////////////////////////////////////////////////////////

function play_ui()

-- sub tela - tecnicas ou item
  love.graphics.setColor(1, 1, 1, 1)
  if state.turn == "skill" or state.turn == "item" and item_use == "off" then
    love.graphics.draw(asset.ui.sub_screen_01, sub_tela_x, sub_tela_y, 0, 1, 1)

    -- items
    if state.turn == "item" then
      items_draw_menu()
    end

    -- skill
    if state.turn == "skill" then
    
    end

  end

  -- status bar
  love.graphics.setColor(1, 1, 1, 1) -- red -- green -- blue --- transparencia
  love.graphics.draw(asset.ui.topbar, camera.x, camera.y)

  -- botoes de baixo
  love.graphics.setFont(asset.fonts.f1)
  turn_draw()

  -- turno
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(asset.ui.turn.bt, turn.bt_q_ctl, camera.x + 1115, camera.y + 8, 0, 1, 1)
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.print(st_en.turn.tend, camera.x + 1126, camera.y + 11, 0, 1, 1)

  -- player stats

  -- life bar
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.print("life", camera.x + 10, camera.y + 11, 0, 1, 1)
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", camera.x + 38, camera.y + 12, state.player.life_bar, 15)
  love.graphics.setColor(1, 1, 1, 0.3)
  love.graphics.draw(asset.ui.toplife_bar, camera.x + 38, camera.y + 12) -- imagem
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(state.player.life, camera.x + 125, camera.y + 11, 0, 1, 1)

  -- separador line
  love.graphics.setColor(1, 1, 1, 0.1)
  love.graphics.rectangle("fill", camera.x + 143, camera.y, 1, 40)

  -- atack
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(turn[1].img, turn.quad[1], camera.x + 155, camera.y + 9, 0, 0.18, 0.18)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(state.player.atk_power, camera.x + 185, camera.y + 11, 0, 1, 1)

  -- separador line
  love.graphics.setColor(1, 1, 1, 0.1)
  love.graphics.rectangle("fill", camera.x + 204, camera.y, 1, 40)

  -- move
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(turn[2].img, turn.quad[1], camera.x + 217, camera.y + 9, 0, 0.18, 0.18)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(state.player.m_max, camera.x + 246, camera.y + 11, 0, 1, 1)

  -- separador line
  love.graphics.setColor(1, 1, 1, 0.1)
  love.graphics.rectangle("fill", camera.x + 272, camera.y, 1, 40)

  -- texto
  love.graphics.setColor(1, 1, 1, 1) -- normalizador de cor
  love.graphics.setFont(asset.fonts.f1)
  love.graphics.print("alep:" .. state.enemy.alert_p_time, camera.x + 20, camera.y + 80, 0, 1, 1)
  love.graphics.print("turno:" .. state.turn, camera.x + 120, camera.y + 80, 0, 1, 1)

  love.graphics.print("atack_combat_active:" .. state.combat.atack_active, camera.x + 20, camera.y + 120, 0, 1, 1)
  love.graphics.print("player.a_max_use:" .. state.player.a_max_use, camera.x + 20, camera.y + 140, 0, 1, 1)
  -- love.graphics.print("armor qtd:" .. item[7].qtd, camera.x + 20, camera.y + 160, 0, 1, 1)

  --love.graphics.print("smoke use:" .. item[6].use, camera.x + 20, camera.y + 200, 0, 1, 1)
  --love.graphics.print("smoke dura:" .. item[6].dura, camera.x + 20, camera.y + 220, 0, 1, 1)

  --love.graphics.print("item use:" .. state.player.i_max_use, camera.x + 20, camera.y + 260, 0, 1, 1)

  -- love.graphics.print("mo X/Y:" .. love.mouse.getX() .. "/" .. love.mouse.getY(), camera.x + 300, camera.y + 80, 0, 1, 1)
  -- love.graphics.print("mo_world X/Y:" .. wm.x .. "/" .. wm.y, camera.x + 100, camera.y + 140, 0, 1, 1)
  -- love.graphics.print("cameraX/Y:" .. camera.x .. "/" .. camera.y, camera.x + 100, camera.y + 180, 0, 1, 1)

end