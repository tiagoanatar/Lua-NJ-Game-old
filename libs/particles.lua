-- ///////////////////////////////////////////////////////////////
--// VARIAVEIS
--///////////////////////////////////////////////////////////////

--System Params

-- ///////////////////////////////////////////////////////////////
--// LOAD
--///////////////////////////////////////////////////////////////

function particle_load()
    
  local max_particles = 20000
    
  -- 1 - fog
  -----

  local texture1 = asset.particles.fog -- neblina

  p_neblina = {
    p = love.graphics.newParticleSystem(texture1, max_particles),
    startSize = 1,
    midSize = 3,
    endSize = 0.10
  } 

  p_neblina.p:setEmissionRate(0) -- 233 valor final
  p_neblina.p:setParticleLifetime(2.16*.5, 2.16)
  p_neblina.p:setEmissionArea("normal", 50, 50)
  p_neblina.p:setSpeed(23.33*.5, 23.33)
  p_neblina.p:setRadialAcceleration(26.67*.5, 26.67)
  p_neblina.p:setLinearDamping(0*.5, 0)
  p_neblina.p:setDirection(-0)
  p_neblina.p:setSpread(0)
  p_neblina.p:setSizeVariation(0)
  p_neblina.p:setSpin(0.67*.5, 0.67)
  p_neblina.p:setTangentialAcceleration(0*.5, 0)
  -----

  -- 2 - explosion
  -----

  local image2_1 = asset.particles.explosion_1a
  image2_1:setFilter("linear", "linear")

  local image2_2 = asset.particles.explosion_1b
  image2_2:setFilter("linear", "linear")

  p_explosion_1 = {
    p = love.graphics.newParticleSystem(image2_1, 1),
    emit = 0
  } 

  p_explosion_2 = {
    p = love.graphics.newParticleSystem(image2_2, 120),
    emit = 0
  } 

  -- 01
  p_explosion_1.p:setColors(1, 0.57017749547958, 0.12692308425903, 1, 1, 0.32840237021446, 0.12692308425903, 0.86538463830948)
  p_explosion_1.p:setDirection(0)
  p_explosion_1.p:setEmissionArea("none", 0, 0, 0, false)
  p_explosion_1.p:setEmissionRate(4.5855765342712)
  p_explosion_1.p:setEmitterLifetime(0.39263939857483)
  p_explosion_1.p:setInsertMode("bottom")
  p_explosion_1.p:setLinearAcceleration(0, 0, 0, 0)
  p_explosion_1.p:setLinearDamping(0.00079610705142841, 0.00079610705142841)
  p_explosion_1.p:setOffset(91.551727294922, 90)
  p_explosion_1.p:setParticleLifetime(0.014369731768966, 0.16817760467529)
  p_explosion_1.p:setRadialAcceleration(0, 0)
  p_explosion_1.p:setRelativeRotation(false)
  p_explosion_1.p:setRotation(0, 0)
  p_explosion_1.p:setSizes(0.0026701374445111, 1.642241358757)
  p_explosion_1.p:setSizeVariation(0)
  p_explosion_1.p:setSpeed(0.081124663352966, -0.081124663352966)
  p_explosion_1.p:setSpin(0, 0.050020880997181)
  p_explosion_1.p:setSpinVariation(0)
  p_explosion_1.p:setSpread(0)
  p_explosion_1.p:setTangentialAcceleration(0, 0)

  -- 02
  p_explosion_2.p:setColors(0.46153846383095, 0.39380973577499, 0.17751479148865, 1)
  p_explosion_2.p:setDirection(0)
  p_explosion_2.p:setEmissionArea("ellipse", 17.001308441162, 18.115858078003, 0, true)
  p_explosion_2.p:setEmissionRate(0.181374549866)
  p_explosion_2.p:setEmitterLifetime(0.152082277834415)
  p_explosion_2.p:setInsertMode("bottom")
  p_explosion_2.p:setLinearAcceleration(0, 0, 0, 0)
  p_explosion_2.p:setLinearDamping(0, 0)
  p_explosion_2.p:setOffset(65.948272705078, 81.465515136719)
  p_explosion_2.p:setParticleLifetime(0.028137356042862, 0.50784597992897)
  p_explosion_2.p:setRadialAcceleration(157.20642089844, 414.830078125)
  p_explosion_2.p:setRelativeRotation(false)
  p_explosion_2.p:setRotation(0, 0)
  p_explosion_2.p:setSizes(0.015667909756303, 0.28969967365265, 0.001059150788933)
  p_explosion_2.p:setSizeVariation(0.38485804200172)
  p_explosion_2.p:setSpeed(0, 0)
  p_explosion_2.p:setSpin(0, 0)
  p_explosion_2.p:setSpinVariation(0)
  p_explosion_2.p:setSpread(1.6148372888565)
  p_explosion_2.p:setTangentialAcceleration(0, 0)

  -- 3 - sword atack A (original sword-01_c)
  -----

  local image3_1 = asset.particles.sword_1a
  image3_1:setFilter("linear", "linear")

  local image3_2 = asset.particles.sword_1b
  image3_2:setFilter("linear", "linear")

  p_sword_a_1 = {
    p = love.graphics.newParticleSystem(image3_1, 3),
    emit = 0,
    timmer = 0
  } 

  p_sword_a_2 = {
    p = love.graphics.newParticleSystem(image3_2, 27),
    emit = 0,
    timmer = 0
  } 

  -- 01 - sword
  p_sword_a_1.p:setColors(1, 1, 1, 1, 0.76923078298569, 0, 0, 1, 0.76923078298569, 0.17751479148865, 0.17751479148865, 1)
  p_sword_a_1.p:setDirection(-1.5707963705063)
  p_sword_a_1.p:setEmissionArea("none", 0, 0, 0, false)
  p_sword_a_1.p:setEmissionRate(12.46593952179)
  p_sword_a_1.p:setEmitterLifetime(0.10284388810396)
  p_sword_a_1.p:setInsertMode("bottom")
  p_sword_a_1.p:setLinearAcceleration(4.3887896537781, 0, 331.04351806641, 0)
  p_sword_a_1.p:setLinearDamping(-0.0055899959988892, 0.00062111066654325)
  p_sword_a_1.p:setOffset(99.5, 127.5)
  p_sword_a_1.p:setParticleLifetime(0.14331632852554, 0.43183672428131)
  p_sword_a_1.p:setRadialAcceleration(-0.97528660297394, 0)
  p_sword_a_1.p:setRelativeRotation(true)
  p_sword_a_1.p:setRotation(-0.20749622583389, 1.2847448587418)
  p_sword_a_1.p:setSizes(0.26761208772659, 0.14982230961323)
  p_sword_a_1.p:setSizeVariation(0.9261829584837)
  p_sword_a_1.p:setSpeed(3.0626742839813, 10.563100814819)
  p_sword_a_1.p:setSpin(0.076490052044392, 4.3849091529846)
  p_sword_a_1.p:setSpinVariation(0)
  p_sword_a_1.p:setSpread(0.64593493938446)
  p_sword_a_1.p:setTangentialAcceleration(0, 0)

  -- 02 - particles
  p_sword_a_2.p:setColors(0.2769230902195, 0.082011833786964, 0.082011833786964, 0, 1, 0.29230770468712, 0.29230770468712, 1, 0.72692304849625, 0, 0, 0)
  p_sword_a_2.p:setDirection(-2.9996955394745)
  p_sword_a_2.p:setEmissionArea("none", 0, 0, 0, false)
  p_sword_a_2.p:setEmissionRate(169.37748718262)
  p_sword_a_2.p:setEmitterLifetime(0.177092923223972)
  p_sword_a_2.p:setInsertMode("bottom")
  p_sword_a_2.p:setLinearAcceleration(-0.48917797207832, 0, -4.4026017189026, 0)
  p_sword_a_2.p:setLinearDamping(-7.9134254455566, 0.0042798407375813)
  p_sword_a_2.p:setOffset(90, 91.551727294922)
  p_sword_a_2.p:setParticleLifetime(0.029387755319476, 0.17332777380943)
  p_sword_a_2.p:setRadialAcceleration(0.97835594415665, 47.939441680908)
  p_sword_a_2.p:setRelativeRotation(false)
  p_sword_a_2.p:setRotation(-1.4352686405182, 0.64350110292435)
  p_sword_a_2.p:setSizes(0.21699818968773, 0.035906624048948)
  p_sword_a_2.p:setSizeVariation(0.9261829584837)
  p_sword_a_2.p:setSpeed(0.081894218921661, 304.72839355469)
  p_sword_a_2.p:setSpin(0.058562692254782, 3.3571960926056)
  p_sword_a_2.p:setSpinVariation(0)
  p_sword_a_2.p:setSpread(14.9965261220970)
  p_sword_a_2.p:setTangentialAcceleration(-12492.626953125, 20006.400390625)
  
  -- 4 - Alert Player
  -----
  local image4 = asset.particles.alert_player
  image4:setFilter("linear", "linear")
  
  p_alert_player = {
    p = love.graphics.newParticleSystem(image4, 641),
    emit = 0,
    timmer = 0
  } 

  p_alert_player.p:setColors(1, 0, 0, 1, 0.13846154510975, 0.020769231021404, 0.020769231021404, 1, 0.8807692527771, 0.15244083106518, 0.15244083106518, 1, 0.050000000745058, 0.047692306339741, 0.047692306339741, 1)
  p_alert_player.p:setDirection(-1.5707963705063)
  p_alert_player.p:setEmissionArea("none", 0, 0, 0, false)
  p_alert_player.p:setEmissionRate(30.953380584717)
  p_alert_player.p:setEmitterLifetime(-1)
  p_alert_player.p:setInsertMode("bottom")
  p_alert_player.p:setLinearAcceleration(0.094238862395287, -0.8481497168541, 0.094238862395287, -0.8481497168541)
  p_alert_player.p:setLinearDamping(0, 0)
  p_alert_player.p:setOffset(283, 283)
  p_alert_player.p:setParticleLifetime(0.0084555419161916, 0.26753863692284)
  p_alert_player.p:setRadialAcceleration(0.18847772479057, 1.6962994337082)
  p_alert_player.p:setRelativeRotation(false)
  p_alert_player.p:setRotation(0, 0)
  p_alert_player.p:setSizes(0.05330105900764)
  p_alert_player.p:setSizeVariation(0)
  p_alert_player.p:setSpeed(-7.0377292633057, 26.82067489624) -- itensity
  p_alert_player.p:setSpin(0.0054254257120192, 0.0054254257120192)
  p_alert_player.p:setSpinVariation(0)
  p_alert_player.p:setSpread(0.70465630292892)
  p_alert_player.p:setTangentialAcceleration(1.6962994337082, 1.6962994337082)

  -- 5 - Desconf Player
  -----
  local image5 = asset.particles.alert_desconf
  image5:setFilter("linear", "linear")
  
  p_desconf_player = {
    p = love.graphics.newParticleSystem(image5, 641),
    emit = 0,
    timmer = 0
  } 

  p_desconf_player.p:setColors(0.580392, 0.521569, 0.027451, 0.2)
  p_desconf_player.p:setDirection(-1.5707963705063)
  p_desconf_player.p:setEmissionArea("none", 0, 0, 0, false)
  p_desconf_player.p:setEmissionRate(30.953380584717)
  p_desconf_player.p:setEmitterLifetime(-1)
  p_desconf_player.p:setInsertMode("bottom")
  p_desconf_player.p:setLinearAcceleration(0.094238862395287, -0.8481497168541, 0.094238862395287, -0.8481497168541)
  p_desconf_player.p:setLinearDamping(0, 0)
  p_desconf_player.p:setOffset(283, 283)
  p_desconf_player.p:setParticleLifetime(0.0084555419161916, 0.26753863692284)
  p_desconf_player.p:setRadialAcceleration(0.18847772479057, 1.6962994337082)
  p_desconf_player.p:setRelativeRotation(false)
  p_desconf_player.p:setRotation(0, 0)
  p_desconf_player.p:setSizes(0.05330105900764)
  p_desconf_player.p:setSizeVariation(0)
  p_desconf_player.p:setSpeed(-7.0377292633057, 14.82067489624) -- itensity
  p_desconf_player.p:setSpin(0.0054254257120192, 0.0054254257120192)
  p_desconf_player.p:setSpinVariation(0)
  p_desconf_player.p:setSpread(0.70465630292892)
  p_desconf_player.p:setTangentialAcceleration(1.6962994337082, 1.6962994337082)

  -- 6 - Enemy dead
  -----
  local image6 = asset.particles.alert_dead
  image6:setFilter("linear", "linear")
  
  p_dead_enemy = {
    p = love.graphics.newParticleSystem(image6, 641),
    emit = 0,
    timmer = 0
  } 

  p_dead_enemy.p:setColors(0.627451, 0.341176, 0.054902, 0.8)
  p_dead_enemy.p:setDirection(-1.5707963705063)
  p_dead_enemy.p:setEmissionArea("none", 0, 0, 0, false)
  p_dead_enemy.p:setEmissionRate(30.953380584717)
  p_dead_enemy.p:setEmitterLifetime(-1)
  p_dead_enemy.p:setInsertMode("bottom")
  p_dead_enemy.p:setLinearAcceleration(0.094238862395287, -0.8481497168541, 0.094238862395287, -0.8481497168541)
  p_dead_enemy.p:setLinearDamping(0, 0)
  p_dead_enemy.p:setOffset(283, 283)
  p_dead_enemy.p:setParticleLifetime(0.0084555419161916, 0.26753863692284)
  p_dead_enemy.p:setRadialAcceleration(0.18847772479057, 1.6962994337082)
  p_dead_enemy.p:setRelativeRotation(false)
  p_dead_enemy.p:setRotation(0, 0)
  p_dead_enemy.p:setSizes(0.05330105900764)
  p_dead_enemy.p:setSizeVariation(0)
  p_dead_enemy.p:setSpeed(-7.0377292633057, 26.82067489624) -- itensity
  p_dead_enemy.p:setSpin(0.0054254257120192, 0.0054254257120192)
  p_dead_enemy.p:setSpinVariation(0)
  p_dead_enemy.p:setSpread(0.70465630292892)
  p_dead_enemy.p:setTangentialAcceleration(1.6962994337082, 1.6962994337082)

  -- 7 - Sleep 
  -----
  local image7 = asset.particles.alert_spleep
  image7:setFilter("linear", "linear")
  
  p_enemy_spleep = {
    p = love.graphics.newParticleSystem(image7, 5),
    emit = 0,
    timmer = 0
  } 

  p_enemy_spleep.p:setColors(0.223529, 0.294118, 0.094118, 1)
  p_enemy_spleep.p:setDirection(0.5707963705063)
  p_enemy_spleep.p:setEmissionArea("none", 0, 0, 0, false)
  p_enemy_spleep.p:setEmissionRate(20)
  p_enemy_spleep.p:setEmitterLifetime(-1)
  p_enemy_spleep.p:setInsertMode("bottom")
  p_enemy_spleep.p:setLinearAcceleration(0.094238862395287, -0.8481497168541, 0.094238862395287, -0.8481497168541)
  p_enemy_spleep.p:setLinearDamping(0, 0)
  p_enemy_spleep.p:setOffset(283, 283)
  p_enemy_spleep.p:setParticleLifetime(0.0084555419161916, 4.26753863692284)
  p_enemy_spleep.p:setRadialAcceleration(0.18847772479057, 2.6962994337082)
  p_enemy_spleep.p:setRelativeRotation(false)
  p_enemy_spleep.p:setRotation(0, 0)
  p_enemy_spleep.p:setSizes(0.05330105900764)
  p_enemy_spleep.p:setSizeVariation(0)
  p_enemy_spleep.p:setSpeed(1, 2) -- itensity
  p_enemy_spleep.p:setSpin(0.0054254257120192, 0.0054254257120192)
  p_enemy_spleep.p:setSpinVariation(0)
  p_enemy_spleep.p:setSpread(0.70465630292892)
  p_enemy_spleep.p:setTangentialAcceleration(1.6962994337082, 1.6962994337082)

end

-- ///////////////////////////////////////////////////////////////
--// UPDATE
--///////////////////////////////////////////////////////////////

function particle_update(dt)
  
    -- increase particle test timmer
    local function particle_time_test(particle)
      particle.timmer = particle.timmer + (dt/2) 
    end
  
    -- 1 - fog 01
    p_neblina.p:setSizes(p_neblina.startSize, p_neblina.midSize, p_neblina.endSize)
    p_neblina.p:update(dt)
        
    -- 2 - explosion 01
    --p_explosion_1.p:setSizes(p_neblina.startSize, p_neblina.midSize, p_neblina.endSize)
    p_explosion_1.p:update(dt)

    --p_explosion_2.p:setSizes(p_neblina.startSize, p_neblina.midSize, p_neblina.endSize)
    p_explosion_2.p:update(dt)

    -- 3 - sword A
    p_sword_a_1.p:update(dt)
    p_sword_a_2.p:update(dt)
    
    -- 3.1
    if state.combat.screen == 'on' and p_sword_a_1.timmer < p_sword_a_1.p:getEmitterLifetime() then
      p_sword_a_1.p:start()
      -- increase particle test timmer
      particle_time_test(p_sword_a_1)
    end
    if p_sword_a_1.timmer > p_sword_a_1.p:getEmitterLifetime() then
        p_sword_a_1.p:stop()
        p_sword_a_1.timmer = 99
    end
    
    -- 3.2
    if state.combat.screen == 'on' and p_sword_a_2.timmer < p_sword_a_2.p:getEmitterLifetime() then
      p_sword_a_2.p:start()
      -- increase particle test timmer
      particle_time_test(p_sword_a_2)
    end
    if p_sword_a_2.timmer > p_sword_a_2.p:getEmitterLifetime() then
      p_sword_a_2.p:stop()
      p_sword_a_2.timmer = 99
    end
    
    -- 4 - alert player
    p_alert_player.p:update(dt)
    -- 5 - alert desconf
    p_desconf_player.p:update(dt)
    -- 6 - alert desconf
    p_dead_enemy.p:update(dt)
    -- 7 - enemy sleep
    p_enemy_spleep.p:update(dt)
    
end

-- ///////////////////////////////////////////////////////////////
--// DRAW
--///////////////////////////////////////////////////////////////

function particle_draw(p_type,x,y)
  
  --Draw particle system
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(p_type, x, y)
    
end

-- ///////////////////////////////////////////////////////////////
--// CUSTOM DRAW
--///////////////////////////////////////////////////////////////

function particle_player_atack_01_draw()
  
  if state.combat.screen == 'on' then
    p_sword_a_1.p:start()
    
    love.graphics.setBlendMode("add")
    
    for x = 1, 10 do
      particle_draw(p_sword_a_1.p, state.enemy.list[state.combat.enemy_index].x+10, state.enemy.list[state.combat.enemy_index].y+20)
    end
    
    for x = 1, 3 do
      particle_draw(p_sword_a_2.p, state.enemy.list[state.combat.enemy_index].x+20, state.enemy.list[state.combat.enemy_index].y+20)
    end
    
    love.graphics.setBlendMode("alpha")
  end
    
end

-- ///////////////////////////////////////////////////////////////
--// PARTICLES RESET
--///////////////////////////////////////////////////////////////

function particles_reset()
  
  -- 3 - sowrd_a
  p_sword_a_1.timmer = 0
  p_sword_a_2.timmer = 0
  
end