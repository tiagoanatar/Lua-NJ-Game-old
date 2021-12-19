-- enemy ref holder
local enemy_ref = state.enemy.list

local timmer_main = 0 -- timmer used in animation
local dice_rol
local anim_player_life_ref

-- damage roll
local dice_player = 0
local dice_enem = 0
local damage_final = 0
local damage_once = 'off' -- one damage set per round

-- animation
local anin_damage_opac = 0 -- opacity
local anin_damage_font = 1 -- reduce text

-- attack screen
local screen_atk = {x = camera.x + 700, y = camera.y + 20, w = 400, h = 700, opa = 0}

-- short var
local enemy

-- ///////////////////////////////////////////////////////////////
--// FUNCTIONS
--///////////////////////////////////////////////////////////////

-- 1 - activate 
local function combate_colisoes() 
  
  -- activate screen - item
  if state.turn == 'item' then
    if state.combat.item_active == 'on' and state.combat.screen == 'off' then
      state.combat.screen = 'on'
      damage_once = 'on'
    end
  end
    
  -- activate screen - enemy
  if state.turn == 'enemy' then
    if state.combat.enemy_active == 'on' and state.combat.screen == 'off' then
      state.combat.enemy_index = state.enemy.index_comp
      enemy = enemy_ref[state.combat.enemy_index]
      state.combat.screen = 'on'
      damage_once = 'on'
    end
  end

  -- activate screen - player
  if state.turn == 'attack' then 
    if state.combat.atack_active == 'on' and state.combat.screen == 'off' then
      enemy = enemy_ref[state.combat.enemy_index]
      state.combat.screen = 'on'
      damage_once = 'on'
    end
  end 

end

-- 2 - animate panel popup
local function combat_panel_opacity() 

  -- ON
  if state.combat.screen == 'on' and screen_atk.opa < 1 then
    screen_atk.opa = screen_atk.opa + 0.1
  end

  -- OFF
  if state.combat.screen == 'end' and screen_atk.opa > 0 then
    screen_atk.opa = screen_atk.opa - 0.1
  end

end


-- 3 - damage
local function combat_damage()
  
  -- combat box position
  screen_atk.x = camera.x + 965

  -- damage calculation
  if state.combat.screen == 'on' and damage_once == 'on' then
  
    -- PLAYER - dice rols
    if enemy.comp == 'alert_player' or enemy.comp == 'alert_body' then
      
      for x = 1, state.player.atk_power do  
        if x == 1 then dice_player = 0 end -- set damage to zero
        dice_rol = love.math.random(1, 6)
        if dice_rol == 5 or dice_rol == 6 then dice_player = dice_player + 1 end
      end
      
      local alerta = love.math.random(1, 2) -- random activation of alert when enemy on state 'alert_body'
      if enemy.comp == 'alert_body' and alerta == 1 then dice_player = enemy.life end
      if enemy.comp == 'alert_body' and alerta == 2 then enemy.comp = 'alert_player' end
      
    end
      
    if enemy.comp ~= 'alert_player' and enemy.comp ~= 'alert_body' then 
      dice_player = enemy.life -- instant kill
    end

    -- ENEMY - dice rols
    if enemy.comp == 'alert_player' then
      for x = 1, enemy.atk_power do
        if x == 1 then dice_enem = 0 end -- set damage to zero
        dice_rol = love.math.random(1, 6)
        if dice_rol == 5 or dice_rol == 6 then dice_enem = dice_enem + 1 end
      end
    end

    -- ENEMY - life bar reduction
    anim_enem_life_ref = enemy.life_ref/100 -- reference value ofr each percent 
    enemy.life = enemy.life - dice_player -- calculating damage
    enemy.life_dano_ref = dice_player/anim_enem_life_ref -- how many perentage fall
    enemy.life_bar_after = math.floor(enemy.life_bar - (0.8 * enemy.life_dano_ref))

    -- PLAYER - life bar reduction
    anim_player_life_ref = state.player.life_ref/100
    if dice_enem > 0 then
      state.player.life = state.player.life + item[7].power - dice_enem
      damage_final = dice_enem - item[7].power
    end

    state.player.life_dano_ref = damage_final/anim_player_life_ref
    state.player.life_bar_after = math.floor(state.player.life_bar - (0.8 * state.player.life_dano_ref))

    -- ITEM UPDATE - armor
    if dice_enem > 0 and item[7].dura ~= 0 then
      item[7].dura = item[7].dura - 1
    end

    if item[7].dura == 0 then
      item[7].power = 0
      item[7].use = 'off'
    end

    -- END
    damage_once = 'off' -- controla que o dano não seja aplicado mais do que uma vez

  end
end

-- 4 - draw panel
local function combate_dados()
  
  -- dice roll
  combat_damage()

  -- status bar 
  love.graphics.draw(asset.ui.combat_bk)

  -- PLAYER

  -- imagem
  love.graphics.setColor(0.4, 0.5, 0.3, 1)
  love.graphics.rectangle('fill', 20, 20, 80, 150)

  -- life bar
  love.graphics.setColor(0.4, 0.9, 0.9, 1)
  love.graphics.rectangle('fill', 20, 175, state.player.life_bar, 15)

  -- texto
  love.graphics.setFont(asset.fonts.f1)

  -- nome
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Ninja', 20, 200, 0, 1, 1)

  -- vida
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print(state.player.life, 24, 174, 0, 1, 1)

  -- dano
  love.graphics.setFont(asset.fonts.f2)
  love.graphics.setColor(1, 1, 1, anin_damage_opac) -- estilo e da animacao do dano
  love.graphics.print('hit:' .. dice_player, 20, 220, 0, anin_damage_font, anin_damage_font)

  -- ENEMY 
  
  if state.combat.screen == 'on' then
    
    -- imagem
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', 112, 20, 80, 150)
    love.graphics.draw(enemy.profile, 112, 20)

    -- life bar
    love.graphics.setColor(0.4, 0.9, 0.9, 1)
    love.graphics.rectangle('fill', 112, 175, enemy.life_bar, 15)

    -- texto 
    love.graphics.setFont(asset.fonts.f1)

    -- nome
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Samurai', 112, 200, 0, 1, 1)

    -- vida
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(enemy.life, 116, 174, 0, 1, 1)

    -- dano
    love.graphics.setFont(asset.fonts.f2)
    love.graphics.setColor(1, 1, 1, anin_damage_opac) -- estilo e da animacao do dano
    love.graphics.print('hit:' .. dice_enem, 112, 220, 0, anin_damage_font, anin_damage_font)

  end

end 

-- 5 // animacoes ///////////////////////////////////////
-- /////////////////////////////////////////////////////////

local function combate_animacoes()
  
  -- timmer
  if state.combat.screen == 'on' then
    timmer_main = timmer_main + 0.05
  end

  -- opacidade
  if timmer_main > 0.5 and state.combat.screen == 'on' and anin_damage_opac < 2 then
    anin_damage_opac = anin_damage_opac + 0.01
  end

  -- tamanho do texto
  if timmer_main > 0.5 and state.combat.screen == 'on' and anin_damage_font > 0.5 then
    anin_damage_font = anin_damage_font - 0.02
  end

  -- life reduce 

  -- player
  if timmer_main > 1 and state.player.life_bar > state.player.life_bar_after and state.player.life_bar >= 0 then
    state.player.life_bar = state.player.life_bar - 1
  end 

  -- enemy 
  if timmer_main > 1 and enemy.life_bar > enemy.life_bar_after and enemy.life_bar >= 0 then
    enemy.life_bar = enemy.life_bar - 1
  end  

  ---------------------------------

  if timmer_main > 5 then
    state.combat.screen = 'end'
    timmer_main = 0
    -- damage animation
    anin_damage_opac = 0
    anin_damage_font = 1
  end

  if screen_atk.opa < 0 then

    -- ativando comp dead
    if enemy.life <= 0 then
      enemy.comp = 'dead'
      enemy.main_anim = 2
      enemy.alert_anim = 1 
    end

    -- resetando ataque do inimigo
    if state.turn == 'enemy' then
      state.combat.enemy_active = 'off'
      state.combat.screen = 'off'
    end

    -- resetando ataque do item
    if state.turn == 'item' then
      state.combat.item_active = 'off'
      state.combat.screen = 'off'
    end

    -- resetando ataque do player
    if state.turn == 'attack' then
      state.combat.atack_active = 'off'
      state.combat.screen = 'off'
    end

  end

end 

-- ///////////////////////////////////////////////////////////////
--// COMBAT LOAD
--///////////////////////////////////////////////////////////////

function combate_load()
      
  combat_canvas = love.graphics.newCanvas(400, 700)
  
end


-- ///////////////////////////////////////////////////////////////
--// COMBAT UPDATE
--///////////////////////////////////////////////////////////////

function combate_update()

  -- colisoes
  combate_colisoes() 

  -- chamar menu
  combat_panel_opacity()

  -- animacoes
  combate_animacoes()

  -- set canvas
  love.graphics.setCanvas(combat_canvas)
    combate_dados()
  love.graphics.setCanvas()

end 

-- ///////////////////////////////////////////////////////////////
--// COMBAT DRAW
--///////////////////////////////////////////////////////////////

function combate_draw()

  -- load canvas
  love.graphics.setColor(1, 1, 1, screen_atk.opa) -- isso ira normalizar as cores dentro do canvas
  love.graphics.draw(combat_canvas, screen_atk.x, camera.y + 20)
  
end 
