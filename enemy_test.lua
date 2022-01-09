-- ///////////////////////////////////////////////////////////////
--// BASE ENEMY
--///////////////////////////////////////////////////////////////

-- enemy ref holder
local enemy_ref = state.enemy.list

-- função que será usada para criar novas tabelas
local function new_enem()
  return
  {
  -- base
  id = 0, x = 270, y = 315, w = 45, h = 45, scaX = 1, atK = 0, atNumb = 1, hit_pos_X = 15,

  -- comportament - (stop, path_diago, sleep, dead, alert_desconf, alert_player, alert_body, alert_item, alert_total, confuse  )
  comp = "stop", change_comp = "on", dead_check = "off",

  -- path
  path = {},

  -- animatio
  alert = asset.enemy.alert,

  main_anim = 1, alert_anim = 1,

  -- view
  v_box = {w = 10, h = 10},

  v_p = {x = 0, y = 0}, -- player view
  v_e = {x = 0, y = 0}, -- dead enemy view
  v_i = {x = 0, y = 0}, -- item view

  v_ref = {x = 0, y = 0}, v_p_ref = {x = 0, y = 0}, -- mantem posicoes de referencia quando inimigo e player estao em movimento 0

  loop_reset = true, -- reset view boxes

  -- move
  m_max = 0, m_max_base = 10,

  -- life bar 
  life_dano_ref = 0, life_bar = 80, life_bar_after = 80, life_bar_hover = 0,
  
  -- type
  ttype = '',
  
  -- combat active
  combat = 'off'
  }
end 

-- ///////////////////////////////////////////////////////////////
--// CUSTOM ENEMY DATA FEED
--///////////////////////////////////////////////////////////////

local function custom_enemy_type(base,ttype,asset)
  -- base
  base.life = ttype.life
  base.life_ref = ttype.life_ref
  base.atk_power = ttype.atk_power

  -- graficos 
  base.sprite = asset.sprite
  base.profile = asset.profile 
end

-- ///////////////////////////////////////////////////////////////
--// ANIMATION DATA FEED
--///////////////////////////////////////////////////////////////

local function animation(x)

-- anim inimigo
    enemy_ref[x].anim_grid = anim8.newGrid(88, 60, enemy_ref[x].sprite:getWidth(), enemy_ref[x].sprite:getHeight())

    enemy_ref[x].anim_type = {
        anim8.newAnimation(enemy_ref[x].anim_grid('1-2',1), 0.8), -- still
        anim8.newAnimation(enemy_ref[x].anim_grid('1-2',2), 0.4), -- ataque
        anim8.newAnimation(enemy_ref[x].anim_grid('1-2',3), 0.4), -- 1 -- andar -- sprites 2 a 5, linha 1, velocidade 0.1
        anim8.newAnimation(enemy_ref[x].anim_grid('1-3',4), 0.2, "pauseAtEnd") -- 3 -- dormir
        }
        
-- anim baloes de alert
    enemy_ref[x].alert_grid = anim8.newGrid(20, 19, enemy_ref[x].alert:getWidth(), enemy_ref[x].alert:getHeight())

    enemy_ref[x].alert_type = {
        anim8.newAnimation(enemy_ref[x].alert_grid('1-1',1), 1, "pauseAtEnd"), -- 1 -- nada - sprits 1a1, line 1, velocidade 0.1
        anim8.newAnimation(enemy_ref[x].alert_grid('2-2',1), 1, "pauseAtEnd"), -- 2 -- duvida
        anim8.newAnimation(enemy_ref[x].alert_grid('3-3',1), 1, "pauseAtEnd"), -- 3 -- zzz
        anim8.newAnimation(enemy_ref[x].alert_grid('4-4',1), 1, "pauseAtEnd"), -- 4 -- viu
        anim8.newAnimation(enemy_ref[x].alert_grid('5-5',1), 1, "pauseAtEnd"), -- 5 -- viu dead
        anim8.newAnimation(enemy_ref[x].alert_grid('6-6',1), 1, "pauseAtEnd") -- 6 -- m
      }
      
end

-- ///////////////////////////////////////////////////////////////
--// LIFE BAR CALC
--///////////////////////////////////////////////////////////////

local function lifebar_calc(x)
  
  local life_perce
  
  life_perce = enemy_ref[x].life_ref/100
  enemy_ref[x].life_bar_hover = 0.45 * (enemy_ref[x].life/life_perce)

end

-- ///////////////////////////////////////////////////////////////
--// RANDOM POSITION -- escolhera posicoes aletatorias para os inimigos no tabuleiro
--///////////////////////////////////////////////////////////////

local function rand_posi()
  
    local rand = love.math.random(1, #grid_global)
    local fim = "off"
    
    repeat
        if grid_global[rand].ttype == "clear" and ma_he(grid_global[rand],state.player) > 270 then
            fim = "on"
        else
            rand = love.math.random(1, #grid_global)
        end
    until fim == "on"
    
    return rand

end

-- ///////////////////////////////////////////////////////////////
--// ENEMY LOAD
--///////////////////////////////////////////////////////////////

function enemy_a_load()
    
  -- enemy generation loop
  for i = 1, state.cenario.global.ene_qtd do
    
    enemy_ref[i] = new_enem()
    enemy_ref[i].id = i

    -- customizando tabela do com o enemy type
    custom_enemy_type(enemy_ref[i], state.enemy.ttype.sword_a, asset.enemy.ttype.sword_a)

    -- anima8
    animation(i)
          
    -- posicao - evita paredes
    local ind = rand_posi()
    enemy_ref[i].x = grid_global[ind].x ; enemy_ref[i].y = grid_global[ind].y

  end

  -- criando tabela de contagem de inimigos
  enen_cont()

end 

-- ///////////////////////////////////////////////////////////////
--// ENEMY UPDATE
--///////////////////////////////////////////////////////////////

function enemy_a_update(dt)

-- update em acoes do inimigo
  for i,v in ipairs(enemy_ref) do 
    enemy_ref[i].anim_type[enemy_ref[i].main_anim]:update(dt)
    enemy_ref[i].alert_type[enemy_ref[i].alert_anim]:update(dt)
  end

  enemy_visao_update(dt) 

-- comportamento do inimigo
  if state.turn == "enemy" then enemy_comp() end
  
end


-- ///////////////////////////////////////////////////////////////
--// ENEMY DRAW
--///////////////////////////////////////////////////////////////

function enemy_a_draw()
    
  for i,v in ipairs(enemy_ref) do

    -- sprite do inimigo
    love.graphics.setColor(1,1,1,1)
    enemy_ref[i].anim_type[enemy_ref[i].main_anim]:draw(enemy_ref[i].sprite, enemy_ref[i].x +20, enemy_ref[i].y +20, 0,  enemy_ref[i].scaX, 1, 44, 30) -- 44 e 30 são o ponto de origem
    

    -- hit box
    --love.graphics.setColor(1,0,0,0.3) 
    --love.graphics.rectangle("fill", enemy_ref[i].x, enemy_ref[i].y, enemy_ref[i].w, enemy_ref[i].h)

    if index_comp == i then
      love.graphics.setColor(1,1,0,0.8)
      love.graphics.rectangle("fill", enemy_ref[i].x, enemy_ref[i].y, enemy_ref[i].w, enemy_ref[i].h)  
    end

    -- visao
    love.graphics.setColor(0,0,0,0.9)
    love.graphics.rectangle("fill", enemy_ref[i].v_p.x, enemy_ref[i].v_p.y, enemy_ref[i].v_box.w, enemy_ref[i].v_box.h)
    love.graphics.rectangle("fill", enemy_ref[i].v_e.x, enemy_ref[i].v_e.y, enemy_ref[i].v_box.w, enemy_ref[i].v_box.h)
    love.graphics.rectangle("fill", enemy_ref[i].v_i.x, enemy_ref[i].v_i.y, enemy_ref[i].v_box.w, enemy_ref[i].v_box.h)

    -- system ----------------------
    love.graphics.setColor(0,0,0,1) -- normalizador de cor
    love.graphics.setFont(asset.fonts.f1)

    -- comportamento
    love.graphics.print("c:" .. enemy_ref[i].comp, enemy_ref[i].x - 60, enemy_ref[i].y - 10)
    love.graphics.print("x:" .. enemy_ref[i].x, enemy_ref[i].x - 60, enemy_ref[i].y + 2)
    love.graphics.print("y:" .. enemy_ref[i].y, enemy_ref[i].x - 60, enemy_ref[i].y + 14)
    
    -- ID
    love.graphics.setFont(asset.fonts.f4)
    love.graphics.setColor(255,255,255,1)
    love.graphics.rectangle("fill", enemy_ref[i].x+36, enemy_ref[i].y+20, 20, 20)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("ID:" .. enemy_ref[i].id, enemy_ref[i].x + 20, enemy_ref[i].y + 20, 0, 1, 1)
      
  end
--

-- enemy count
  if state.turn == "enemy" then enen_cont_draw() end 

end -- END ENEMY DRAW

-- ///////////////////////////////////////////////////////////////
--// ENEMY LIFE BAR DRAW
--///////////////////////////////////////////////////////////////

function enemy_life_bar()

    for i,v in ipairs(enemy_ref) do
        if wm.x >= enemy_ref[i].x 
        and wm.x < enemy_ref[i].x + m_size_tile
        and wm.y >= enemy_ref[i].y 
        and wm.y < enemy_ref[i].y + m_size_tile then
            lifebar_calc(i)
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.rectangle("fill", enemy_ref[i].x, enemy_ref[i].y+40, 45, 5)
            love.graphics.setColor(0.4, 0.9, 0.9, 0.7)
            love.graphics.rectangle("fill", enemy_ref[i].x, enemy_ref[i].y+40, enemy_ref[i].life_bar_hover, 5)
        end
    end
    
end