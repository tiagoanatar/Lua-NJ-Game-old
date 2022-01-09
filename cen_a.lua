-- ///////////////////////////////////////////////////////////////
--// VARIAVEIS
--///////////////////////////////////////////////////////////////

local triger_once = true

local cen_ttype = {"dojo","armory","mansion","cave","fortress","woods","city","village"}

local texture_draw = 0
local cb_a_draw = 0
local pared_im_baix = 0

-- variaveis da grid
local grid = {}
local grid_raiz = 0

-- factory function
local function tab_add()
  return {x = 0, y = 0, w = 45, h = 45, ttype = "clear", item = 0}
end

-- grid generator
local function feed_grid()
  for x=1, state.cenario.global.size do
    table.insert(grid, {})
    for i=1, state.cenario.global.size do 
      table.insert(grid[x], {ttype = 0})
      -- adicionando aleatoriedade dos blocos que serao de colisao
      local random_coli = love.math.random(1, 12)  

      if random_coli == 1 then 
        grid[x][i].ttype = 1
      else
        grid[x][i].ttype = 0
      end
    end
  end
end

-- ///////////////////////////////////////////////////////////////
--// CENARIO -A- LOAD
--///////////////////////////////////////////////////////////////

function cenario_a_load()

  -- enemy quantity
  state.cenario.global.ene_qtd = 3 -- love.math.random(1, 3)

  -- map size
  state.cenario.global.size = 14 --love.math.random(30, 32)

  -- cen type
  state.cenario.global.ttype = cen_ttype[1]

  -----
  -- generate grid
  -----

  -- random blocks 
  --feed_grid()

  -- room generator
  cen_random_maze(state.cenario.global.size, grid)

  -- fix grid feed
  --grid = cen_op_01

  -----
  -----

  -- chao base - gerando tabuleiro
  state.cenario.global.w = 45 * state.cenario.global.size
  state.cenario.global.h = 45 * state.cenario.global.size

  -- textura externa
  state.cenario.global.textura_w = state.cenario.global.w +3000
  state.cenario.global.textura_h = state.cenario.global.h +3000

  -- gerador de estilos
  state.cenario.global.tatame_num = love.math.random(1, 3)

  -- Carregando imagem da texura
  texture_draw = love.graphics.newImage("imgs/cen/text_1.jpg")
  texture_draw:setWrap("repeat", "repeat") -- repete no eixo x e y

  -- New Quad -- Posição x/y - tamanho do quad(bloco da imagem) -- tamanho da imagem puxada
  texture_quad = love.graphics.newQuad(0, 0, state.cenario.global.textura_w , state.cenario.global.textura_h, texture_draw:getWidth(), texture_draw:getHeight())

  -- walls generator
  for y,v in ipairs(grid) do
    for x,w in ipairs(grid[y]) do
      
      table.insert(grid_global, tab_add())
      grid_global[#grid_global].x = (y-1) * 45
      grid_global[#grid_global].y = (x-1) * 45
      
      -- WALL
      if grid[y][x].ttype == 1 then
        grid_global[#grid_global].ttype = "wall" 
      end
      
      -- end/edges always free
      if y == state.cenario.global.size or x == state.cenario.global.size then
        grid_global[#grid_global].ttype = "clear" 
      end
      
      -- DOORS
      local rand = love.math.random(1, 10)
      
      -- 2 entry passages - horizontal wall
      if x > 3 and x < state.cenario.global.size-3 and rand == 1 and grid[y][x+1].ttype == 1 and grid[y][x-1].ttype == 1 then
        grid_global[#grid_global].ttype = "clear"
        grid[y][x].ttype = 0
      end
      
      -- 2 entry passages - vertical wall
      if y > 3 and y < state.cenario.global.size-3 and rand == 1 and grid[y+1][x].ttype == 1 and grid[y-1][x].ttype == 1 then
        grid_global[#grid_global].ttype = "clear"
        grid[y][x].ttype = 0
      end
  
    end
  end

  -- cen design
  cen_design_set(grid)

end

-- ///////////////////////////////////////////////////////////////
--// CENARIO DRAW
--///////////////////////////////////////////////////////////////

function cenario_a_draw()
  
  -- texture bk
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(texture_draw, texture_quad, -1500, -1500)
    
  -- Base
  cb_a_base = love.graphics.setColor(1,1,1,1)
  cb_a_base = love.graphics.rectangle("fill", 0, 0, state.cenario.global.w, state.cenario.global.h )
    
  love.graphics.setColor(1,1,1,1)

  -- cen design draw
  cen_design_draw()

  -- enemy life bar
  enemy_life_bar()

end -- END CANARIO DRAW
