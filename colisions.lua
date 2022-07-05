-- enemy ref holder
local enemy_ref = state.enemy.list

-- tabela geral com todos os retangulos da grid 
-- tipos de blocos: clear, wall, water, enemy, enem_dead, player, item
grid_global = {}

-- GRID GLOBAL UPDATE
function grid_global_update()
  
  for y,v in ipairs(grid_global) do
    for x,w in ipairs(grid_global[y]) do
      
      if grid_global[y][x].line == true then 
        grid_global[y][x].line = false
      end

      if grid_global[y][x].ttype == "enemy" then 
        grid_global[y][x].ttype = "clear"
      end
      
      for j,w in ipairs(enemy_ref) do
        if enemy_ref[j].x == grid_global[y][x].x and enemy_ref[j].y == grid_global[y][x].y and enemy_ref[j].comp ~= "dead" then 
          grid_global[y][x].ttype = "enemy" 
        end 
      end
      
      if state.turn == "enemy" and enemy_ref[state.enemy.index_comp].x == grid_global[y][x].x and enemy_ref[state.enemy.index_comp].y == grid_global[y][x].y and enemy_ref[state.enemy.index_comp].comp ~= "dead" then 
        grid_global[y][x].ttype = "clear" 
      end 
        
    end
  end
  
end

-- COLISION -- funcao principal de colisao simples - quando x e y sao iguais sempre 
function colisao_main(n,pos_val_x,pos_val_y)
  
  -- bloqueia mov - item and atack
  for i,v in ipairs(state.range.open) do
    if n.x + pos_val_x == state.range.open[i].x and n.y + pos_val_y == state.range.open[i].y 
    and state.range.open[i].check == "close" then
      return true
    end
  end

  return false
  
end