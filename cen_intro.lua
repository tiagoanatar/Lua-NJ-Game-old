-- ///////////////////////////////////////////////////////////////
--// VARIAVEIS
--///////////////////////////////////////////////////////////////

-- Variaveis cenario - ativação de cada etapa
local start_control_01 = 1
local start_control_02 = 0
local start_control_03 = 0
local start_control_04 = 0

-- Variaveis de alpha
local alpha_grow_01 = 0
local alpha_grow_02 = 0
local alpha_grow_03 = 0

-- ///////////////////////////////////////////////////////////////
--// CENARIO LOAD
--///////////////////////////////////////////////////////////////

function cenario_intro_load()
 
 -- Imagem principal do start
start_0 = love.graphics.newImage("imgs/start/logos_inicio_00.png")
start_01 = love.graphics.newImage("imgs/start/logos_inicio_01.png")
start = love.graphics.newImage("imgs/start/start_sprite.png")

-- Tela de start -- Quad dos sprites
start_quad = love.graphics.newQuad(0, 0, 1200, 700, start:getWidth(), start:getHeight())
start_quad_01 = love.graphics.newQuad(1200, 0, 1200, 700, start:getWidth(), start:getHeight())
-- ( x, y, width, height, sw, sh )
start_draw_quad = start_quad


end -- END CENARIO LOAD


-- ///////////////////////////////////////////////////////////////
--// CENARIO UPDATE
--///////////////////////////////////////////////////////////////

function cenario_intro_up(dt) 

-- Aumentador de alpha

if start_control_01 == 1 and alpha_grow_01 < 1 then
alpha_grow_01 = alpha_grow_01 + (dt/6)
end 

if alpha_grow_01 >= 1 then
start_control_02 = 1
end

if start_control_02 == 1 then 
alpha_grow_01 = alpha_grow_01 - (dt/2)
alpha_grow_02 = alpha_grow_02 + (dt/6)
end

-- Menu control
if love.keyboard.isDown("left") then
start_draw_quad = start_quad
end
if love.keyboard.isDown("right") then
start_draw_quad = start_quad_01
end  

-- gui ---------------------------------------------------

-- botao star game
if suit.Button("Start Game", 350, 550, 200,30).hit then

cen_control = 1

end

-- botao load game
if suit.Button("Load Game", 600, 550, 200,30).hit then

cen_control = 1  

end
-----------------------------------------------------------

end -- END CENARIO LOAD


-- ///////////////////////////////////////////////////////////////
--// CENARIO DRAW
--///////////////////////////////////////////////////////////////

function cenario_intro_draw()

-- Evento que será carregado
if start_control_01 == 1 then

-- Sprite
love.graphics.setColor(1, 1, 1, alpha_grow_01)
love.graphics.draw(start_01, 0, 0)

end

function evento_tempo_01()

-- Sprite
love.graphics.setColor(1, 1, 1, alpha_grow_02)
love.graphics.draw(start, start_draw_quad, 0, 0)
-- love.graphics.draw( texture, quad, x, y, r, sx, sy, ox, oy, kx, ky )

end

end -- END CANARIO DRAW
