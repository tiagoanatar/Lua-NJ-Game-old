-- scaX = invert sprite
-- atNumb = Animation number used bt the player

-- ///////////////////////////////////////////////////////////////
--// FUNCTIONS
--///////////////////////////////////////////////////////////////

-- 1 // movement ///////////////////////////////////////////
-- /////////////////////////////////////////////////////////

local function play_mov()

  -- change direction on keys
  if key_l then
    state.player.scaX = -1
  elseif key_r then
    state.player.scaX = 1
  end
  
  -- mouse move -- update all the time to get the index
  if state.player.trigger_auto_move == false then
    func:mouse_action_box_update(state.player.m_box)
  end

  -- keys move
  if state.player.trigger_auto_move == false and state.player.m_max > 0 then 
    
    local function feedPosition(x, y)
      for i, v in ipairs(state.range.path_final) do state.range.path_final[i] = nil end
      table.insert(state.range.path_final, {x = 0, y = 0})
      
      -- intial position
      state.range.path_final[1].x = state.player.x + x
      state.range.path_final[1].y = state.player.y + y
      
      -- final position
      state.range.fim.x = state.player.x + x
      state.range.fim.y = state.player.y + y
      
      state.player.trigger_auto_move = true
    end
    
    if key_l and colisao_main(state.player,-45,0) then
      feedPosition(-45, 0)
    end 

    if key_r and colisao_main(state.player,45,0) then
      feedPosition(45, 0)
    end  

    if key_u and colisao_main(state.player,0,-45) then
      feedPosition(0, -45)
    end

    if key_d and colisao_main(state.player,0,45) then
      feedPosition(0, 45)
    end  
  
  end

  -- GLOBAL move function
  if state.player.trigger_auto_move == true then
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

  -- mouse box move
  func:mouse_action_box_update(state.player.a_box)

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
  if state.turn.current ~= state.turn.ttype.item then
    items_reset()
  end

  -- item update
  if state.turn.current == state.turn.ttype.item then
    items_use()
  end

  -- item combat activate
  items_enemy_effect()  

  -- attack box update
  if state.turn.current ~= state.turn.ttype.attack then
    state.player.a_box.x = state.player.x
    state.player.a_box.y = state.player.y
  end

  if state.turn.current ~= state.turn.ttype.off and state.turn.current ~= state.turn.ttype.enemy and state.player.trigger_auto_move == false then
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
  if state.turn.current == state.turn.ttype.move then
    play_mov() -- movimento
    state.player.atNumb = 3
    if state.move.ref_index > 0 then
      anim_type[3]:update(dt)
    end
  end

  -- #02 - anim ataque
  if state.turn.current == state.turn.ttype.attack then
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
  if state.turn.current == state.turn.ttype.off or state.turn.current == state.turn.ttype.enemy then
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
  if state.turn.current == state.turn.ttype.attack then
    play_ataque_draw()
  end

  -- move box
  if state.turn.current == state.turn.ttype.move then
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
  if state.turn.current == state.turn.ttype.skill or state.turn.current == state.turn.ttype.item and state.item.use == false then
    love.graphics.draw(asset.ui.sub_screen_01, sub_tela_x, sub_tela_y, 0, 1, 1)

    -- items
    if state.turn.current == state.turn.ttype.item then
      items_draw_menu()
    end

    -- skill
    if state.turn.current == state.turn.ttype.skill then
    
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
  love.graphics.print("turno:" .. state.turn.current, camera.x + 120, camera.y + 80, 0, 1, 1)

  love.graphics.print("max move:" .. state.player.m_max, camera.x + 20, camera.y + 120, 0, 1, 1)
  love.graphics.print("state.move.ref_index:" .. state.move.ref_index, camera.x + 20, camera.y + 160, 0, 1, 1)

  --love.graphics.print("smoke use:" .. item[6].use, camera.x + 20, camera.y + 200, 0, 1, 1)
  --love.graphics.print("smoke dura:" .. item[6].dura, camera.x + 20, camera.y + 220, 0, 1, 1)

  --love.graphics.print("item use:" .. state.player.i_max_use, camera.x + 20, camera.y + 260, 0, 1, 1)

  -- love.graphics.print("mo X/Y:" .. love.mouse.getX() .. "/" .. love.mouse.getY(), camera.x + 300, camera.y + 80, 0, 1, 1)
  -- love.graphics.print("mo_world X/Y:" .. wm.x .. "/" .. wm.y, camera.x + 100, camera.y + 140, 0, 1, 1)
  -- love.graphics.print("cameraX/Y:" .. camera.x .. "/" .. camera.y, camera.x + 100, camera.y + 180, 0, 1, 1)

end