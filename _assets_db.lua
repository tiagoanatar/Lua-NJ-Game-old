-- ///////////////////////////////////////////////////////////////
--// FONTS, IMAGES AND MUSIC
--///////////////////////////////////////////////////////////////

function assets()
  
  asset = {
    
    player = {
      main = love.graphics.newImage("imgs/play_main-02.png"),
      alert_icon = love.graphics.newImage("imgs/enem/alert.png"),
    },
    
    enemy = {
      ttype = {
        sword_a = {
          sprite = love.graphics.newImage("imgs/enem/enen_01.png"),
          profile = love.graphics.newImage("imgs/enem/enen_01/ene_01_foto.png"),
        },
      },
      alert = love.graphics.newImage("imgs/enem/alert.png"),
    },
    
    fonts = {
      f1 = love.graphics.newFont("fonts/Roboto-Regular.ttf", 12),
      f2 = love.graphics.newFont("fonts/Roboto-Regular.ttf", 39),
      f3 = love.graphics.newFont("fonts/Roboto-Regular.ttf", 12),
      f4 = love.graphics.newFont("fonts/Roboto-Regular.ttf", 18),
    },
    
    music = {
      bgm1 = love.audio.newSource("music/teste_01.mp3", "stream") -- "stream" para musica e "static" para som
    },
    
    ui = {
      enemy_count = love.graphics.newImage("imgs/enem/ene_contagem_01.png"), -- enemy count
      mouse_cursor = love.graphics.newImage("imgs/cur_ninja.png"),
      combat_bk = love.graphics.newImage("imgs/combate/combat_bk.png"),
      topbar = love.graphics.newImage("imgs/telas/top_bar.png"),
      sub_screen_01 = love.graphics.newImage("imgs/telas/sub_tela_01.png"),
      toplife_bar = love.graphics.newImage("imgs/telas/top_lifebar.png"),
      
      turn = {
        bt = love.graphics.newImage("imgs/telas/bt_turn_sprite.png"),
        bt_attack = love.graphics.newImage("imgs/telas/bts_baixo_a_atk_sprite.png"),
        bt_move = love.graphics.newImage("imgs/telas/bts_baixo_b_mov_sprite.png"),
        bt_item = love.graphics.newImage("imgs/telas/bts_baixo_c_item_sprite.png"),
        bt_skil = love.graphics.newImage("imgs/telas/bts_baixo_d_tech_sprite.png")
      }
      
    },
    
    particles = {
      fog = love.graphics.newImage("imgs/particles/cloud.png"),
      
      explosion_1a = love.graphics.newImage("imgs/particles/lightDot.png"),
      explosion_1b = love.graphics.newImage("imgs/particles/light.png"),
      
      sword_1a = love.graphics.newImage("imgs/particles/atack-01.png"),
      sword_1b = love.graphics.newImage("imgs/particles/lightDot.png"),
      
      alert_player = love.graphics.newImage("imgs/particles/enemy-alert.png"),
      alert_desconf = love.graphics.newImage("imgs/particles/enemy-desconf.png"),
      alert_dead = love.graphics.newImage("imgs/particles/enemy-dead.png"),
      alert_spleep = love.graphics.newImage("imgs/particles/enemy-spleep.png"),
      alert_base = love.graphics.newImage("imgs/particles/enemy-alert-black.png"),
    },
    
  }
  
end