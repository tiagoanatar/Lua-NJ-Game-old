-- ///////////////////////////////////////////////////////////////
--// VARIAVEIS
--///////////////////////////////////////////////////////////////

local item_combat_active = false

-- enemy ref holder
local enemy_ref = state.enemy.list

local cont_x
local cont_y 

local temp_index = 0 -- used in items 3 e 4
local emission_rate = 1 -- used in item 6(smoke)

local anim_player_life_ref

-- calculando a margem correta
local text_margin = 0
local font = love.graphics.getFont()
local text_w = 0 -- coletar tamanho do texto

-- ///////////////////////////////////////////////////////////////
--// LOCAL SUPPORT FUNCTIONS
--///////////////////////////////////////////////////////////////

-- cria variaveis de cada tabela - tabela de colisao
local function tab_add()
  return {x = 0, y = 0, w = 45, h = 45, item = "name"}
end

-- movimento do quadrado de item
local function item_box_move()
  
  if key_l and key_r == false and key_u == false and key_d == false and state.player.item_click == "off" and colisao_main(state.player.i_box,-45,0) == 1 then
    state.player.i_box.x = state.player.i_box.x - 45
    state.player.item_click = "on"
  end   
  if key_r and key_l == false and key_u == false and key_d == false and state.player.item_click == "off" and colisao_main(state.player.i_box,45,0) == 1 then
    state.player.i_box.x = state.player.i_box.x + 45
    state.player.item_click = "on"
  end  
  if key_u and key_l == false and key_r == false and key_d == false and state.player.item_click == "off" and colisao_main(state.player.i_box,0,-45) == 1 then
    state.player.i_box.y = state.player.i_box.y - 45
    state.player.item_click = "on"
  end
  if key_d and key_l == false and key_r == false and key_u == false and state.player.item_click == "off" and colisao_main(state.player.i_box,0,45) == 1 then
    state.player.i_box.y = state.player.i_box.y + 45
    state.player.item_click = "on"
  end  
    
  -- liberando movimento
  if key_l == false and key_r == false and key_u == false and key_d == false then 
    state.player.item_click = "off"
  end
  --

  -- mouse box move
  func:mouse_action_box_update(state.player.i_box)
    
end

-- gasto do uso do player
local function item_gasto(index)

  state.player.i_max_use = state.player.i_max_use - 1
  item[index].qtd = item[index].qtd - 1

end

-- i_box_reset
local function i_box_reset()
  
  -- igualando a item box com posicao do player
  state.player.i_box.x = state.player.x
  state.player.i_box.y = state.player.y
    
end

-- ///////////////////////////////////////////////////////////////
--// ITEMS LOAD
--///////////////////////////////////////////////////////////////

-- estados do item[x].use: off, on, using(items de lancar), active(items de usar como armadura or that stay for some time(animation)) 
-- estados do item[x].drop: off, floor, enemy 

function items_load()
  
  -- quad
  item_quad = {
    love.graphics.newQuad(0, 0, 76, 76, 228, 76),
    love.graphics.newQuad(76, 0, 76, 76, 228, 76),
    love.graphics.newQuad(152, 0, 76, 76, 228, 76)
  }

  item_size = {
    w = 76,
    h = 76
  }

  item = {

    -- 1 item_bomb
    {
      name = st_main.item.bomb,
      img = love.graphics.newImage("imgs/item/item_bomb.png"),
      img_final = love.graphics.newImage("imgs/item/explod_test.png"),
      q_ctl = 1, -- quad control
      x = 0,
      y = 0,
      qtd = 2, -- quantidade
      use = "off",
      --
      drop = "off",
      drop_p = {x = 0, y = 0},
      drop_enemy_i = 0,
      --
      dura = 1,
      dura_ref = 1,
      dura_control = "off"
    },
    --

    -- 2 item_shuri
    {
      name = st_main.item.shuriken,
      img = love.graphics.newImage("imgs/item/item_shuri.png"),
      img_final = love.graphics.newImage("imgs/item/explod_test.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 2,
      use = "off",
      --
      drop = "off",
      drop_p = {x = 0, y = 0},
      drop_enemy_i = 0
    },
    --

    -- 3 item_sleep
    {
      name = st_main.item.sleep,
      img = love.graphics.newImage("imgs/item/item_sleep.png"),
      img_final = love.graphics.newImage("imgs/item/explod_test.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 8,
      use = "off",
      --
      drop = "off",
      drop_p = {x = 0, y = 0},
      drop_enemy_i = 0
    },
    --

    -- 4 item_gold
    {
      name = st_main.item.gold,
      img = love.graphics.newImage("imgs/item/item_gold.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 2,
      use = "off",
      --
      drop = "off",
      drop_p = {x = 0, y = 0}
    },
    --

    -- 5 item_makibishi
    {
      name = st_main.item.makib,
      img = love.graphics.newImage("imgs/item/item_makibishi.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 2,
      use = "off",
      --
      drop = "off",
      drop_p = {x = 0, y = 0}
    },
    --

    -- 6 item_smoke
    {
      name = st_main.item.smoke,
      img = love.graphics.newImage("imgs/item/item_smoke.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 4,
      use = "off",
      --
      drop = "off",
      drop_p = {x = 0, y = 0},
      dura = 2,
      dura_ref = 2,
      dura_control = "off"
    },
    --

    -- 7 item_armor
    {
      name = st_main.item.armor,
      img = love.graphics.newImage("imgs/item/item_armor.png"),
      img_use = love.graphics.newImage("imgs/item/item_armor_use.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 4,
      use = "off", 
      --
      power = 0, 
      dura = 3
    },
    --

    -- 8 item_poison
    {
      name = st_main.item.poison,
      img = love.graphics.newImage("imgs/item/item_poison.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 4,
      use = "off"
    },
    --

    -- 9 item_potion
    {
      name = st_main.item.poti,
      img = love.graphics.newImage("imgs/item/item_potion.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 3,
      use = "off"
    },
    --

    -- 10 item_rope
    {
      name = st_main.item.rope,
      img = love.graphics.newImage("imgs/item/item_rope.png"),
      q_ctl = 1,
      x = 0,
      y = 0,
      qtd = 4,
      use = "off"
    }
    --

  }

end

-- ///////////////////////////////////////////////////////////////
--// ITEMS RESET
--///////////////////////////////////////////////////////////////

function items_reset()
  
  -- igualando a item box com posicao do player
  state.player.i_box.x = state.player.x
  state.player.i_box.y = state.player.y
  
  -- deactivate global item use state
  state.item.use = false
  
  -- resetando itens nao "active"
  for i,v in ipairs(item) do
    if item[i].use ~= "active" then  
      item[i].use = "off" 
    end
  end
  
end

-- ///////////////////////////////////////////////////////////////
--// ITEMS MENU DRAW
--///////////////////////////////////////////////////////////////

function items_draw_menu()  
  for i,v in ipairs(item) do
    
    -- posicao 
    -----
    -- controle do x
    cont_x = (i - 1) % 5 * 115

    -- atualizando x e y
    item[i].x = sub_tela_x + cont_x + 50
    item[i].y = sub_tela_y + 30
        
    -- controle do y
    if i > 5 then item[i].y = sub_tela_y + 190 end
      
    -- draw img
    -----
    love.graphics.setColor(1, 1, 1, 1) -- normalizador de cor
    if item[i].qtd == 0 then love.graphics.setColor(1, 1, 1, 0.5) end

    -- imprimindo item
    love.graphics.draw(item[i].img, item_quad[item[i].q_ctl], item[i].x, item[i].y, 0, 1, 1)

    -- draw text 
    -----
    love.graphics.setColor(1, 1, 1, 0.4) -- normalizador de cor

    -- coletar tamanho do texto
    text_w = font:getWidth(item[i].name)

    -- calculando a margem correta
    text_margin = (item_size.w - text_w) / 2 

    -- imprime texto
    love.graphics.setFont(asset.fonts.f1)
    love.graphics.print(item[i].name, item[i].x + text_margin, item[i].y + 85, 0, 1, 1)

    -- imprime number
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.print(item[i].qtd, item[i].x + 34, item[i].y + 104, 0, 1, 1)

    -- retangulo do numero
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", item[i].x + 28, item[i].y + 120, 20, 5)

    -- hover
    -----
    -- checando se mouse bate em item
    if wm.x >= item[i].x 
    and wm.x < item[i].x + item_size.w
    and wm.y >= item[i].y 
    and wm.y < item[i].y + item_size.h
    and item[i].qtd > 0 then

      item[i].q_ctl = 2
      if love.mouse.isDown(1) and item[i].use == "off" then
          item[i].use = "on"
          state.item.use = true
      end
      
    else
        item[i].q_ctl = 1
    end

    -- escurecendo caso o item esteja vazio
    if item[i].qtd == 0 then
        item[i].q_ctl = 3
    end
    
  end -- FOR end
end

-- ///////////////////////////////////////////////////////////////
--// ITEMS DRAW USE
--///////////////////////////////////////////////////////////////

function items_draw_use()

  -- 1, 2, 3, 4 e 5 item
  -----
  if temp_index > 0 then
    -- guide box draw
    if item[temp_index].use == "using" then
      love.graphics.setColor(1, 0.1, 0.1, 0.3)
      love.graphics.rectangle("fill", state.player.i_box.x, state.player.i_box.y, 45, 45)
      -- movimento da item box
      item_box_move()
    end
    -- drop floor
    if item[temp_index].drop == "floor" and temp_index ~= 6 then
      item[temp_index].drop = "off"
      item[temp_index].use = "off"
    end
    -- drop  -- GENERICO DE TESTES, depois mudar
    if item_combat_active == true and item[temp_index].drop == "enemy" then
      love.graphics.setColor(1, 1, 1, 1) -- normalizador de cor
      --love.graphics.draw(item[2].img_final, item[temp_index].drop_p.x, item[temp_index].drop_p.y, 0, 1, 1)  
    end
  end -- temp index

  -- 1 item_bomb
  -----
  if item[1].use == "active" then
    item[temp_index].drop = "off"
    
    -- active animation
    if item[temp_index].dura_control == "off" and item[temp_index].use == "active" then 
      if p_explosion_2.emit < 40 then 
        p_explosion_2.emit = p_explosion_2.emit + 2
      else
        item[temp_index].dura_control = "on"
      end
    end
    
    -- inactive animation
    if item[temp_index].dura_control == "on" then 
      p_explosion_2.emit = p_explosion_2.emit - 0.5
      if p_explosion_2.emit == 0 then 
        item[temp_index].use = "off" 
        item[temp_index].dura_control = "off"            
      else
      end
    end
    
    love.graphics.setBlendMode("add")
          
    p_explosion_2.p:start()
  for step = 1, 40 do p_explosion_2.p:update(0.0013020569458604) end
    p_explosion_2.p:emit(p_explosion_2.emit)
    particle_draw(p_explosion_2.p, item[temp_index].drop_p.x+20, item[temp_index].drop_p.y+20)
          
    p_explosion_1.p:start()
    p_explosion_1.p:emit(119)
    particle_draw(p_explosion_1.p, item[temp_index].drop_p.x+20, item[temp_index].drop_p.y+20)

  end

  -- 6 item_smoke
  -----
  if item[6].use == "active" then
    item[6].drop = "off"
    if item[6].dura > 0 then 
      if emission_rate < 233 then emission_rate = emission_rate + 50 end
      p_neblina.p:setEmissionRate(emission_rate) 
    end
    
    particle_draw(p_neblina.p, item[6].drop_p.x, item[6].drop_p.y)
  end

  -- 7 item_armor
  -----
  if item[7].use == "active" then
    if item[7].dura == 3 then
      love.graphics.setColor(1, 1, 1, 1) -- normalizador de cor
      love.graphics.draw(item[7].img_use, item_quad[1], camera.x +20 , camera.y + 150, 0, 1, 1)
    elseif item[7].dura == 2 then  
      love.graphics.draw(item[7].img_use, item_quad[2], camera.x +20 , camera.y + 150, 0, 1, 1)
    elseif item[7].dura == 1 then
      love.graphics.draw(item[7].img_use, item_quad[3], camera.x +20 , camera.y + 150, 0, 1, 1)
    end
  end

  -- itens alimentados na tabela geral
  -----
  love.graphics.setColor(1, 1, 1, 1) -- normalizador de cor
  for y,v in ipairs(grid_global) do
    for x,w in ipairs(grid_global) do
      for p = 1, 5 do
        if grid_global[y][x].item == item[p].name then
          love.graphics.draw(item[p].img, item_quad[1], grid_global[y][x].x + 10, grid_global[y][x].y + 10, 0, 0.3, 0.3)
        end
      end
    end
  end

end

-- ///////////////////////////////////////////////////////////////
--// ITEMS USE
--///////////////////////////////////////////////////////////////

function items_use()
  
  -- resetando
  --temp_index = 0

  -- 1, 2, 3, 4, 5 and 6 - item_bomb, item_gold and makibishi ...etc
  -----
  for x = 1, 6 do
    if item[x].use == "on" and love.mouse.isDown(1) == false then
      item[x].use = "using"
      temp_index = x
    end
  end

  -- range item + key press use
  if temp_index > 0 and item[temp_index].use == "using" and love.mouse.isDown(1) then
    for y,v in ipairs(grid_global) do
      for x,w in ipairs(grid_global[y]) do

        -- item on the floor
        if temp_index == 4 or temp_index == 5 or temp_index == 6 then
          if state.player.i_box.x == grid_global[y][x].x and state.player.i_box.y == grid_global[y][x].y and grid_global[y][x].ttype == "clear" then
            item[temp_index].drop = "floor"
            grid_global[y][x].ttype = "item"
            grid_global[y][x].item = item[temp_index].name
            item_gasto(temp_index)
            item[temp_index].drop_p.x = grid_global[y][x].x
            item[temp_index].drop_p.y = grid_global[y][x].y
          end
        end
      
        -- item on enemy
        if temp_index == 1 or temp_index == 2 or temp_index == 3 and combate_screen == "off" then
          if state.player.i_box.x == grid_global[y][x].x and state.player.i_box.y == grid_global[y][x].y and grid_global[y][x].ttype == "enemy" then
            
            item[temp_index].drop = "enemy"  
            item[temp_index].drop_p.x = grid_global[y][x].x
            item[temp_index].drop_p.y = grid_global[y][x].y
            item_gasto(temp_index)

            -- guardando informacao do inimigo
            for j,w in ipairs(enemy_ref) do 
              if enemy_ref[j].x == item[temp_index].drop_p.x and enemy_ref[j].y == item[temp_index].drop_p.y then
                item[temp_index].drop_enemy_i = j
              end
            end
            i_box_reset()
            
            -- bomb
            if temp_index == 1 then
              item[1].use = "active"
              item[1].dura = item[1].dura_ref
            end
              
          end
        end
      end 
    end
  end

  -- 6 item_smoke
  -----
  if item[6].drop == "floor" then

    item[6].use = "active"
    item[6].dura = item[6].dura_ref
    
  end

  -- 7 item_armor
  -----
  if item[7].use == "on" then
    
    item[7].power = 1
    item[7].dura = 3
    item[7].use = "active"
    
    item_gasto(7)
    state.turn.current = state.turn.ttype.off
    
  end

  -- 9 item_potion
  -----
  if item[9].use == "on" then
    
    item[9].use = "using"
    
    -- dano
    state.player.life = state.player.life + 3
    if state.player.life > state.player.life_ref then
      state.player.life = state.player.life_ref
    end
    --
      
    -- life player bar update
    anim_player_life_ref = state.player.life_ref/100 -- valor de refencia de cada porcento do life

    state.player.life_dano_ref = 3/anim_player_life_ref -- quantos porcento cada dano tira do player
    state.player.life_bar_after = math.floor(state.player.life_bar + (0.8 * state.player.life_dano_ref))
    
    state.player.life_bar = state.player.life_bar_after
    
    -- regulando tamanho em caso de a pocao subir demais
    if state.player.life_bar > 80 then state.player.life_bar = 80 end 
    
    item_gasto(9)
    
    item[9].use = "off"
    state.turn.current = state.turn.ttype.off
    
  end

  -- desativando tela, caso clique fora ou ESC
  if love.mouse.isDown(1) then
    if wm.x < sub_tela_x
    or wm.y < sub_tela_y
    or wm.x > sub_tela_x + asset.ui.sub_screen_01:getWidth()
    or wm.y > sub_tela_y + asset.ui.sub_screen_01:getHeight() then
      state.turn.current = state.turn.ttype.off
    end
  elseif love.keyboard.isDown("escape") then
    state.turn.current = state.turn.ttype.off
  end
    
end

-- ///////////////////////////////////////////////////////////////
--// ITEMS ENEMY EFFECT
--///////////////////////////////////////////////////////////////

function items_enemy_effect()

  -- items 1, 2 e 3
  if state.turn.current ~= state.turn.ttype.enemy then
        
    -- 1 bomb
    if item[1].drop_enemy_i > 0 then
      item_combat_active = true
      co_en_ref = item[1].drop_enemy_i -- global var da folha combat.lua
      item[1].drop_enemy_i = 0
    end
          
    -- 2 shuri
    if item[2].drop_enemy_i > 0 then
      item_combat_active = true
      co_en_ref = item[2].drop_enemy_i -- global var da folha combat.lua
      item[2].drop_enemy_i = 0
    end
        
    -- 3 - sleep
    if item[3].drop_enemy_i > 0 then
      local index = item[3].drop_enemy_i
      enemy_ref[index].comp = "sleep"
      enemy_ref[index].change_comp = "off"
      item[3].drop_enemy_i = 0
    end

  end

  -- items 5 - makibishi
  if state.turn.current == state.turn.ttype.enemy then
    for j,w in ipairs(enemy_ref) do
      for y,v in ipairs(grid_global) do
        for x,w in ipairs(grid_global[y]) do
          if grid_global[y][x].item == item[5].name then
            if enemy_ref[j].x == grid_global[y][x].x and enemy_ref[j].y == grid_global[y][x].y then
              enemy_ref[j].life = enemy_ref[j].life - 1
              en_stop_call = "on"
              grid_global[y][x].ttype = "clear"
              grid_global[y][x].item = 0
            end
          end
        end
      end
    end
  end

  -- items 6 - smoke
  for j,w in ipairs(enemy_ref) do
    for y,v in ipairs(grid_global) do
      for x,w in ipairs(grid_global[y]) do
        if grid_global[y][x].item == item[6].name then
          if func:ma_he(enemy_ref[j],grid_global[y][x]) < 315 and move_ref_in == 0 and enemy_ref[j].comp ~= "dead" then
            enemy_ref[j].comp = "confuse"
            enemy_ref[j].alert_anim = 6
          end
        end
      end
    end
  end

  -- incrementando duracao do item 6 - smoke
  if state.turn.current == state.turn.ttype.enemy then
    if item[6].use == "active" and item[6].dura_control == "off" and item[6].dura > 0 then
      item[6].dura = item[6].dura - 1
      item[6].dura_control = "on"
    end
  end

  if item[6].dura == 0 then 
    emission_rate = emission_rate - 1
    if emission_rate > 0 then
      p_neblina.p:setEmissionRate(emission_rate)                                                              
    end
    if emission_rate <= 20 then 
      item[6].use = "off" 
      item[6].dura = item[6].dura_ref
      if enemy_ref[state.enemy.index_comp].comp == "confuse" then
        enemy_ref[state.enemy.index_comp].comp = state.enemy.comp_random[love.math.random(1, 2)] -- escolha de comportamento
        enemy_ref[state.enemy.index_comp].change_comp = "off" -- interrompendo mudança de comportamento
      end -- global function - enemy_comp_coli 
      for y,v in ipairs(grid_global) do
        for x,w in ipairs(grid_global[y]) do
          if grid_global[y][x].item == item[6].name then
            grid_global[y][x].item = 0
          end
        end
      end
    end
  end

  if state.turn.current ~= state.turn.ttype.enemy then
    item[6].dura_control = "off"
  end

end
------------------
-- END - items_enemy_effect()
------------------