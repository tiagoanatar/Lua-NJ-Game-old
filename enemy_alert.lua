function enemy_alert()

  local enemy_ref = state.enemy.list
  
  for i,v in ipairs(enemy_ref) do
  
    -- alert player
    if enemy_ref[i].comp == "alert_player" then
      p_alert_player.p:start()
      
      love.graphics.setColor(1, 1, 1, 0.5)
      love.graphics.draw(asset.particles.alert_base, enemy_ref[i].x+2, enemy_ref[i].y -49, 0, 0.065, 0.065)
      love.graphics.setColor(1, 1, 1, 0.3)
      
      love.graphics.setBlendMode("add")
      for x = 1, 5 do
        love.graphics.draw(p_alert_player.p, enemy_ref[i].x +20, enemy_ref[i].y -30)
      end
      love.graphics.setBlendMode("alpha")
    end
    
    -- destrust player
    if enemy_ref[i].comp == "alert_desconf" then
      p_desconf_player.p:start()
      
      love.graphics.setColor(1, 1, 1, 0.5)
      love.graphics.draw(asset.particles.alert_base, enemy_ref[i].x+2, enemy_ref[i].y -49, 0, 0.065, 0.065)
      love.graphics.setColor(1, 1, 1, 0.3)
      
      love.graphics.setBlendMode("add")
      for x = 1, 5 do
        love.graphics.draw(p_desconf_player.p, enemy_ref[i].x +20, enemy_ref[i].y -30)
      end
      love.graphics.setBlendMode("alpha")
    end
    
    -- dead enemy
    if enemy_ref[i].comp == "alert_body" then -- alert_body
      p_dead_enemy.p:start()
      
      love.graphics.setColor(1, 1, 1, 0.8)
      love.graphics.draw(asset.particles.alert_base, enemy_ref[i].x+2, enemy_ref[i].y -49, 0, 0.065, 0.065)
      love.graphics.setColor(1, 1, 1, 0.1)
      
      love.graphics.setBlendMode("add")
      for x = 1, 5 do
        love.graphics.draw(p_dead_enemy.p, enemy_ref[i].x +20, enemy_ref[i].y -30)
      end
      love.graphics.setBlendMode("alpha")
    end
    
    -- sleep enemy
    if enemy_ref[i].comp == "sleep" then
      p_enemy_spleep.p:start()
      
      love.graphics.setColor(1, 1, 1, 0.8)
      --love.graphics.draw(asset.particles.alert_base, enemy_ref[i].x+2, enemy_ref[i].y -49, 0, 0.065, 0.065)
      love.graphics.setColor(1, 1, 1, 1)
      
      love.graphics.setBlendMode("add")
      --for x = 1, 2 do
      love.graphics.draw(p_enemy_spleep.p, enemy_ref[i].x +20, enemy_ref[i].y -30)
      --end
      love.graphics.setBlendMode("alpha")
    end
  
  end

end