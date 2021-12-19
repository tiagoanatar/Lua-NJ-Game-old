-- enemy ref holder
local enemy_ref = state.enemy.list

-- factory function
local function enen_cont_tab_data()
  return
  {ativo = "off", x = 0, y = 0, scaX = 1, anim_numb = 1}  
end

-- ///////////////////////////////////////////////////////////////
--// CONTAGEM DE MOVIMENTOS DO INIMIGO
--///////////////////////////////////////////////////////////////

--// contagem ///////////////////////////////////////////////////

function enen_cont()

  for i = 1, table.maxn(enemy_ref) do
    
    state.enemy.counter[i] = enen_cont_tab_data()

    state.enemy.counter[i].anim_grid = anim8.newGrid(17, 47, asset.ui.enemy_count:getWidth(), asset.ui.enemy_count:getHeight())

    state.enemy.counter[i].anim_type = {
    anim8.newAnimation(state.enemy.counter[i].anim_grid('1-1',1), 1, "pauseAtEnd"), -- 1 -- nao ativado
    anim8.newAnimation(state.enemy.counter[i].anim_grid('2-2',1), 1, "pauseAtEnd"),  -- 2 -- ativado
    anim8.newAnimation(state.enemy.counter[i].anim_grid('3-3',1), 1, "pauseAtEnd")  -- 3 -- dead
          }
    
  end

end
--------------------------
-- END - enen_cont()
--------------------------

--// contagem draw ///////////////////////////////////////////////////

function enen_cont_draw()
  
for i,v in ipairs(state.enemy.counter) do
  
-- ativa o dead
if enemy_ref[i].comp == "dead" then
state.enemy.counter[i].anim_numb = 3  
end
  
state.enemy.counter[i].x = state.player.x - 300 + (i * 40) 
state.enemy.counter[i].y = state.player.y + 280
  
-- sprite do inimigo
love.graphics.setColor(1, 0.5, 1, 1) -- normalizador de cor
state.enemy.counter[i].anim_type[state.enemy.counter[i].anim_numb]:draw(asset.ui.enemy_count, state.enemy.counter[i].x, state.enemy.counter[i].y, 0, state.enemy.counter[i].scaX, 1, 0, 0) -- 0 e 0 são o ponto de origem
  
end
  
end