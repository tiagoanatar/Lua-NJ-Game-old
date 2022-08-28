-- enemy ref holder
local enemy_ref

-- change behavior 
local trocar_comp = 0  -- odds of change bahavior
local local_var = "on"  -- ativa e desativa variaveis locais -- executado 1 vez por inimigo

-- factory funtion
local function tab_add()
  return {x = 0, y = 0}
end

-- ///////////////////////////////////////////////////////////////
--// RESET BEHAVAIOR
--///////////////////////////////////////////////////////////////

local function comp_reset() 
  for i,v in ipairs(state.enemy.list) do
    if state.enemy.list[i].comp ~= "dead" then
      state.enemy.list[i].comp = state.enemy.comp_random[love.math.random(1, 3)]
      state.enemy.list[i].change_comp = "off" -- stop behavior change
    end
  end
  state.player.comp_alert = 1
end

-- ///////////////////////////////////////////////////////////////
--// CHECK IF INDEX_COMP EXCEED LIMIT
--///////////////////////////////////////////////////////////////

-- reset enemy counter
local function enen_cont_reset() 
  for i,v in ipairs(state.enemy.counter) do 
    state.enemy.counter[i].anim_numb = 1 
  end 
end

local function index_comp_reset()

  if state.enemy.index_comp > #state.enemy.list then
    state.turn.current = state.turn.ttype.move
    state.enemy.index_comp = 1
    enen_cont_reset() -- limpa contador

    -- contador de quanto tempo fica alerta
    if state.enemy.alert_p == "on" then state.enemy.alert_p_time = state.enemy.alert_p_time + 1 end
  
    -- contador de quanto tempo fica denconfiado
    if state.enemy.alert_d == "on" then state.enemy.alert_d_time = state.enemy.alert_d_time + 1 end
     
    -- end alert player
    if state.enemy.alert_p_time > 4 then
      comp_reset()
      state.enemy.alert_p_time = 0
      state.enemy.alert_p = "off"
      state.enemy.alert_p_first = "on"
    end
    -- end desconf player
    if state.enemy.alert_d_time > 1 then
      comp_reset()
      state.enemy.alert_d_time = 0
      state.enemy.alert_d = "off"
    end
    
  end

end

-- ///////////////////////////////////////////////////////////////
--// ENEMY MOVE
--///////////////////////////////////////////////////////////////

-- change direction 
local function muda_dire(random)

  if random == true then
    local rand_stop = love.math.random(1, 2)
    if rand_stop == 1 then enemy_ref.scaX = 1 end
    if rand_stop == 2 then enemy_ref.scaX = -1 end
  end
  if random == false then
    if state.player.x > enemy_ref.x then enemy_ref.scaX = 1 end
    if state.player.x < enemy_ref.x then enemy_ref.scaX = -1 end
  end

end

-- movement
local function move_max_zero() enemy_ref.m_max = 0 end

local function enem_move()

  -- if close to hero stop
  if func:ma_he(state.player,enemy_ref) == 45 and enemy_ref.comp == "alert_player" then 
    move_max_zero()
  end

  -- if close to body stop
  if func:ma_he(state.enemy.vision.dead,enemy_ref) == 45 and enemy_ref.comp ~= "alert_desconf" and enemy_ref.comp ~= "alert_player" then 
    move_max_zero()
    -- muda direcao 
    muda_dire(true)
  end
  
  -- move
  move_main(enemy_ref)

end

-- ///////////////////////////////////////////////////////////////
--// PATHFIND DIRECTION
--///////////////////////////////////////////////////////////////

-- comp - normal
local function dire_diago_path()
  
  local tab = {}

  range_path_main(enemy_ref)

  for i,v in ipairs(state.range.open) do -- START
  
    if state.range.open[i].check == "close" then
    
      local function insert()
        table.insert(tab, tab_add())
        tab[#tab].x = state.range.open[i].x
        tab[#tab].y = state.range.open[i].y
      end
  
      if state.move.rand_path_diago == 1 then -- topo esquerda
        if state.range.open[i].x < enemy_ref.x and state.range.open[i].y < enemy_ref.y then
          insert()
        end
      end
      if state.move.rand_path_diago == 2 then -- topo direita
        if state.range.open[i].x > enemy_ref.x and state.range.open[i].y < enemy_ref.y then
          insert()
        end
      end
      if state.move.rand_path_diago == 3 then -- baixo esquerda
        if state.range.open[i].x < enemy_ref.x and state.range.open[i].y > enemy_ref.y then
          insert()
        end
      end
      if state.move.rand_path_diago == 4 then -- baixo direita
        if state.range.open[i].x > enemy_ref.x and state.range.open[i].y > enemy_ref.y then
          insert()
        end
      end

    end
  end 

  -- se nao encontrar nada -- encerrar tudo
  if #tab == 0 then
    state.move.rand_path_diago = false
  -- alimentando posicao escolhida
    state.range.fim.x = enemy_ref.x
    state.range.fim.y = enemy_ref.y
      
    return
  end

  -- escolhendo aleatoriamente a posicao
  if state.move.rand_path_diago ~= false and #tab > 0 then
      
    local random_pos = love.math.random(1, #tab)

  -- alimentando posicao escolhida
    state.range.fim.x = tab[random_pos].x
    state.range.fim.y = tab[random_pos].y

    tab = nil
  end

end

-- comp - alert_player
local function alert_path(ttype)
  
  range_path_main(enemy_ref)

  state.range.fim.x = ttype.x  ; state.range.fim.y = ttype.y
  
end

-- 0.1 - setup
local function setup_inicial()

  enemy_ref.m_max = enemy_ref.m_max_base
  local_var = "off" -- turn off setup
  dire_diago_path() 
  range_path_final(enemy_ref)

end

-- 0.2  - setup final
local function setup_final()
  
  if func:ma_he(state.player,enemy_ref) == 45 and state.player.x < enemy_ref.x and enemy_ref.scaX == -1 then
    alert_player()
  end
  if func:ma_he(state.player,enemy_ref) == 45 and state.player.x > enemy_ref.x and enemy_ref.scaX == 1 then
    alert_player()
  end
  
  -- attack function
  if func:ma_he(state.player,enemy_ref) == 45 and enemy_ref.comp == "alert_player" then 
    state.combat.enemy_active = "on"
    combate_update()
  end

  if state.combat.enemy_active == "off" then
    -- change enemy
    state.enemy.index_comp = state.enemy.index_comp + 1
    
    index_comp_reset()

    local_var = "on" -- ativa novamente as variaveis locais

    particles_reset() -- particles
  end

end

-- 1 - comp - stop
local function comp_stop()
  
-- muda direcao 
  muda_dire(true)

-- chances de trocar de comportamento
  trocar_comp = love.math.random(1, 2)

-- interrompendo mudança de comportamento
  if trocar_comp == 1 then enemy_ref.change_comp = "on" end
  
  setup_final()

end

-- 2 - comp - move chosing 1 of the 4 regions of the map
local function comp_path_diago()

  -- setup inicial
  if local_var == "on" then
  -- random direction
    state.move.rand_path_diago = love.math.random(1, 4)
    setup_inicial()
  end
  
  enem_move() -- movimento

  -- finalizacao do movimento
  if enemy_ref.m_max == 0 then

    -- chances de trocar de comportamento
    trocar_comp = love.math.random(1, 7) 
    if trocar_comp == 1 then enemy_ref.change_comp = "on" end
    setup_final()

  end

end 

-- 3 - comp - sleep
local function comp_sleep()

-- chances de trocar de comportamento
  trocar_comp = love.math.random(1, 3) -- 1 chance em 2

-- interrompendo mudança de comportamento
  if trocar_comp == 1 then enemy_ref.change_comp = "on" end
  
  setup_final()

end

-- 4 - comp - dead
local function comp_dead()

  setup_final()
-- chances de trocar de comportamento
  trocar_comp = 0

end

-- ///////////////////////////////////////////////////////////////
--// ALERTA
--///////////////////////////////////////////////////////////////

-- 1 - alert - descon
local function alert_descon()

  -- setup inicial
  -- ativa e desativa variaveis locais -- executado 1 vez por inimigo
  if local_var == "on" then
    setup_inicial()
    alert_path(state.player)
    range_path_final(enemy_ref)
  end

  muda_dire(false) -- vira inimigo em direcao ao heroi
  enem_move() -- movimento

  -- finalizacao do movimento
  if enemy_ref.m_max == 0 then
    setup_final()
  end

end

-- 2 - alert - player
local function alert_player()

  -- setup inicial
  if local_var == "on" then
    setup_inicial()
    
    if enemy_ref.comp == "alert_body" then
      alert_path(state.enemy.vision.dead)
    elseif enemy_ref.comp == "alert_item" then
      alert_path(state.enemy.vision.item)
    elseif enemy_ref.comp == 'alert_player' then
      alert_path(state.player)
    end

    range_path_final(enemy_ref)
  end

  if enemy_ref.comp ~= "alert_body" then
    muda_dire(false) 
  end

  enem_move() -- movimento
 
  -- finalizacao do movimento
  if enemy_ref.m_max == 0 then
    setup_final()
  end
  
end

-- ///////////////////////////////////////////////////////////////
--// MAIN
--///////////////////////////////////////////////////////////////

function enemy_comp()

  enemy_ref = state.enemy.list[state.enemy.index_comp]

  -- activate animation / current counter / random behavior 
  if enemy_ref.comp ~= "dead" then 
    state.enemy.counter[state.enemy.index_comp].anim_numb = 2 -- mudando animcao do item da contagem
    -- random behavior
    if state.enemy.index_comp <= #state.enemy.list and enemy_ref.change_comp == "on" then
      enemy_ref.comp = state.enemy.comp_random[love.math.random(1, 2)] -- chosse bahavior
      enemy_ref.change_comp = "off" -- stop behavior change
    end
  end 
    
  -- comp activation functions
  if enemy_ref.comp == "stop" then
    enemy_ref.main_anim = 1
    comp_stop()
  end
  if enemy_ref.comp == "path_diago" then
    enemy_ref.main_anim = 3
    comp_path_diago()
  end
  if enemy_ref.comp == "sleep" then
    enemy_ref.main_anim = 4
    comp_sleep()
  end
  if enemy_ref.comp == "alert_desconf" then
    enemy_ref.main_anim = 3
    enemy_ref.change_comp = "off"
    alert_descon()
  end
  if enemy_ref.comp == "alert_player" or enemy_ref.comp == "alert_body" or enemy_ref.comp == "alert_item" then
    enemy_ref.main_anim = 3
    enemy_ref.change_comp = "off"
    alert_player()
  end
  if enemy_ref.comp == "dead" then
    enemy_ref.main_anim = 4
    enemy_ref.alert_anim = 1 
    comp_dead()
  end
  if enemy_ref.comp == "confuse" then 
    comp_stop()
    enemy_ref.alert_anim = 6
  end

end