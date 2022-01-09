-- global state variables
state = {
  
  -- save game data
  save = {},
  
  -- general
  -----
  turn = 'off', -- atack, move, item, skill, off, turning_off(will start turn deactivation), enemy
  
  -- player list
  -----
  player = {
    -- when you have multiple, use this istead
    list = {},
    
    -- ** single player
    
    -- base
    x = 45, y = 45, w = 45, h = 45, at_x = 1, at_y = 1, at_w = 45, at_h = 45, scaX = 1, atNumb = 1, 

    -- ficha
    life = 6, life_ref = 6, life_dano_ref = 0, life_bar = 80, life_bar_after = 80, atk_power = 1,

    -- max actions (X_max = move range, X_max_use = use quantity)
    m_max = 15, m_max_new = 15, -- move
    a_max = 1, a_max_new = 1, a_max_use = 1, a_max_use_new = 1, -- attack
    i_max = 3, i_max_new = 3, i_max_use = 5, i_max_use_new = 5, -- item
  
    -- alert box draw
    comp_alert = 1,
    
    -- ** common use
    
    -- range
    range_open_index = 0,
    m_box = {x = 0, y = 0, w = 45, h = 45}, -- posicao final do uso do move box
    trigger_auto_move = false,

    -- atk box
    a_box = {x = 0, y = 0, w = 45, h = 45}, -- posicao final do uso do ataque box
    atk_click = "off", -- cotrole de 1 click da caixa de ataque

    -- item box
    i_box = {x = 0, y = 0}, -- posicao final do uso de item
    item_click = "off", -- para os cliques multiplos dos items
    
  },
  
  -- enemy list
  -----
  enemy = {
    -- enemy active set
    list = {},
    
    -- ** common use
    
    -- enemy types
    ttype = {
      sword_a = {
        -- default stats
        life = 4, life_ref = 4, atk_power = 3,
      },
    }, 
    
    -- comportment module
    comp_random = {"stop", "path_diago", "sleep"},
    index_comp = 1,
    
    -- counter module
    counter = {},
    
    -- alert states
    alert_p = "off", -- player alert var
    alert_p_first = "off",
    alert_p_time = 0, -- see player or body - active time

    alert_d = "off", -- player destrust var
    alert_d_time = 0, -- suspicious - active time
    
    -- vision
    vision = {
      dead = {x = 0, y = 0},
      item = {x = 0, y = 0},
    }
  },
  
  -- combat
  -----
  combat = {
    screen = "off", -- activate combat screen combate: on, off, end
    enemy_index = 0,
    item_active = "off", -- on, off, end
    enemy_active = "off",
    atack_active = "off"
  },
  
  -- range
  -----
  range = {
    path_open = "on", -- on, off, interrupt, free
    open = {},
    fim = {x =0, y = 0},
    temp = {x =0, y = 0},
    path_final = {},
    path_end = "stop", -- stop, on, off
    range_path_main = range_path_main
  },
  
  -- move
  -----
  move = {
    ref_index = 0,
    active = "off",
    key = "off",
    rand_h = 0, -- direcao movimento horizontal
    rand_v = 0 ,-- direcao movimento vertical
    rand_path_diago = 0 -- usado no movimento "path_diago" - escolhe sentido no movimento
  },
  
  -- cenario
  -----
  cenario = {
    global = {
    -- base
    w, h, size, ttype, music, 

    -- enemy
    ene_qtd, ene_type,

    -- style
    tatame_num, tatame_total, tatame_ref, textura_w, textura_h
    }
  }

}