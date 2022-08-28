-- ///////////////////////////////////////////////////////////////
--// LIBRARIES
--///////////////////////////////////////////////////////////////

-- anim 8 - (animation/sprites)
anim8 = require 'libs/anim8'

-- suit - (menu)
suit = require 'suit-master'

-- camera (my library)
require 'libs/camera'

-- particles (particles system)
require 'libs/particles'

Luven = require 'libs/luven/luven'

bresenham = require 'libs/bresenham'

-- ///////////////////////////////////////////////////////////////
--// IMPORT FILES
--///////////////////////////////////////////////////////////////

require '_state'
require '_functions'
require '_assets_db'
require '_strings_db'

require 'range_data'
require "colisions"
require "move"
require "play"

-- cenario
cen_control = 0 -- switch cen change 
require "cen_design"
require "cen_opcoes"
require "cen_intro"
require "cen_random_maze"
require "cen_a" 

-- enemies
require "enemy_test"
require "enemy_alert"
require "enemy_vision"
require "enemy_counter"
require "enemy_comp_coli"

require "turn"

require "combat"

require "items"

-- ///////////////////////////////////////////////////////////////
--// GLOBAL VARS
--///////////////////////////////////////////////////////////////

-- activate at the start of each cenario
star_cenario = "true"

-- save index of colision table
tabela_sincro_inim = {}

m_size_tile = 45

-- ///////////////////////////////////////////////////////////////
-- // LOAD 
-- ///////////////////////////////////////////////////////////////

function love.load()
      
  -- cen design
  cen_design_load()

  -- assents
  assets()

  -- botoes - turnos
  turn_load()

  -- items
  items_load()

  -- cursor do mouse
  -- love.mouse.setVisible(false) -- esconde o mouse atual

  -- cenarios
  cenario_intro_load(dt) -- intro
  cenario_a_load() -- primeiro cenario

  -- player
  play_load()

  -- inimigos
  enemy_a_load()

  -- combat canvas
  combate_load()

  -- particles load
  particle_load()

  -- camera
  --camera:setBounds(-60, -60, cen_global.w+60, cen_global.h+60)

  -- luvem
  Luven.init()
  Luven.setAmbientLightColor({ 0.5, 0.5, 0.5 })
  Luven.camera:init(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2) -- center the camera.
  Luven.camera:setScale(1) -- set a x2 zoom on the camera.

  -- adding ligths
  for y,v in ipairs(grid_global) do
    for x,w in ipairs(grid_global[y]) do
      if grid_global[y][x].ttype == "wall" and grid_global[y][x].elements == 2 then 
        lightId = Luven.addFlickeringLight(grid_global[y][x].x+5, grid_global[y][x].y+44, { min = { 97/255, 90/255, 17/255, 0.6 }, max = { 87/255, 80/255, 7/255, 01 } }, { min = 0.75, max = 1 }, { min = 0.12, max = 0.2 })
      end
    end
  end
  
end -- END LOAD

-- ///////////////////////////////////////////////////////////////
-- // UPDATE
-- //////////////////////////////////////////////////////////////

function love.update(dt)
  
  -- mouse
  camera:mousePosition()

  -- player
  play_update(dt)

  -- inimigo
  enemy_a_update(dt)

  -- sistema de turnos
  if cen_control > 0 then
    -- turn
    turn_update()

    -- call atck function
    if state.turn.current == state.turn.ttype.attack or state.turn.current == state.turn.ttype.item then
      combate_update()
    end

  end

-- modificador de cenario 
  if love.keyboard.isDown("a") then
    love.audio.stop()
    cen_control = 1  
  end
    
  if love.keyboard.isDown("b") then 
    love.audio.stop()
    cen_control = 0  
  end

-- cenario ----------------------------
  if cen_control == 0 then
    cenario_intro_up(dt)
  end
----------------------------------------

-- camera update posição------------
  camera:setPosition(state.player.x - 600, state.player.y - 325)
--camera:setPosition(0, 0)
-----------------------------

-- posicao da sub tela
  sub_tela_x = camera.x + 272
  sub_tela_y = camera.y + 140

  particle_update(dt)

-- Luven
  Luven.update(dt)

  Luven.camera:setPosition(state.player.x, state.player.y)

-- p_explosion_2.pSystem:setEmissionRate(50) 

end -- END UPDATE

-- ///////////////////////////////////////////////////////////////
-- // DRAW 
-- ///////////////////////////////////////////////////////////////

function love.draw() -- Carregar e atualizar gráfico
 
-- cenario ---------------------
      
-- intro
  if cen_control == 0 then
    cenario_intro_draw()
  end
--
      
-- cenario camera ---------------
        
-- ligths camera
  Luven.drawBegin()

    if cen_control == 1 then  
              
      cenario_a_draw()
      play_draw()
            
    end

  Luven.drawEnd()

  Luven.camera:draw()

-- standard camera
  camera:set()
        
    -- items use
    love.graphics.setColor(1, 1, 1, 1)
    items_draw_use()
        
    -- combat
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha")
    combate_draw()
        
    -- player ui
    play_ui()
        
    particle_player_atack_01_draw()
    
    -- enemy alert animation boxes
    enemy_alert()
        
  camera:unset()

--------------------------------

-- gui
  suit.draw()

-- desenha novo cursor para seguir o mouse
  love.graphics.setColor(1, 1, 1, 1) -- isso ira normalizar as cores dentro do canvas
  love.graphics.draw(asset.ui.mouse_cursor, love.mouse.getX(), love.mouse.getY())

-- system 

-- checar desempenho
  love.graphics.print("Current FPS: " .. love.timer.getFPS(), 50, 50)
  
end -- END DRAW