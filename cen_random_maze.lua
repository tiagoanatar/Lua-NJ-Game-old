-- ///////////////////////////////////////////////////////////////
--// VARS
--///////////////////////////////////////////////////////////////

local set_start_position = false

local front_current_x = 0
local front_current_y = 0
local has_front = true
local pass_current_x = 0
local pass_current_y = 0

local map_stack = {}
local rand_array = {}

-- ///////////////////////////////////////////
-- // MAP LOAD
-- ///////////////////////////////////////////

function cen_random_maze(map_size, map)

	-- object constructor
	local function map_gen()
    return
    {
    ttype = "clear",
    frontier = "off", -- off, on, checked
    current = "off",
    x = 0, y = 0, w = 45, h = 45, item = 0
    }
	end

	-- map object array creation
	for i = 1, map_size do
    table.insert(map, {})
		for j = 1, map_size do
      table.insert(map[i], map_gen())
      map[i][j].ttype = "clear"
      map[i][j].y = (i - 1) * 45
      map[i][j].x = (j - 1) * 45
		end
	end

	-- add frontier
	local function add_frontier(y,x)
    if x < 1 or y < 1 or y > map_size or x > map_size then
      return false
    elseif map[y][x].ttype == "clear" then
      map[y][x].frontier = "on"
    end
	end

	-- call add frontier - INCREASE CORRIDOR SIZE HERE [1]
	local function call_add_frontier()
    add_frontier(pass_current_y-4,pass_current_x); add_frontier(pass_current_y,pass_current_x-4)
    add_frontier(pass_current_y,pass_current_x+4); add_frontier(pass_current_y+4,pass_current_x)
	end
  
	-- add neibour
	local function add_neibor(y,x)
		map[y][x].ttype = "wall"
	end

	-- set pass current
	local function set_pass()
		pass_current_y = map_stack[1][1]
		pass_current_x = map_stack[1][2]
	end

	-- randon frontier
	local function random_frontier()
    rand_array = {}
    
    for y = 1, map_size do
      for x = 1, map_size do	
        if map[y][x].frontier == "on" then
          table.insert(rand_array,{})
          rand_array[#rand_array][1] = y
          rand_array[#rand_array][2] = x
          map[y][x].frontier = "off"
        end	
      end
    end
    
    if #rand_array > 0 then
      local rand = love.math.random(1, #rand_array)
      front_current_y = rand_array[rand][1]
      front_current_x = rand_array[rand][2]

      map[front_current_y][front_current_x].ttype = "wall"

      -- stack feed
      table.insert(map_stack, 1, {})
      map_stack[1][1] = front_current_y
      map_stack[1][2] = front_current_x

      -- making block free - top - left - right - bottom - ALMENTA LARGURA DOS CORREDORES AQUI [2]
      if front_current_y < pass_current_y then
        add_neibor(pass_current_y-1,pass_current_x) 
        add_neibor(pass_current_y-2,pass_current_x)
        add_neibor(pass_current_y-3,pass_current_x)
      elseif front_current_x < pass_current_x then
        add_neibor(pass_current_y,pass_current_x-1)
        add_neibor(pass_current_y,pass_current_x-2)
        add_neibor(pass_current_y,pass_current_x-3)
      elseif front_current_x > pass_current_x then
        add_neibor(pass_current_y,pass_current_x+1)
        add_neibor(pass_current_y,pass_current_x+2)
        add_neibor(pass_current_y,pass_current_x+3)
      elseif front_current_y > pass_current_y then
        add_neibor(pass_current_y+1,pass_current_x)
        add_neibor(pass_current_y+2,pass_current_x)
        add_neibor(pass_current_y+3,pass_current_x)
      end
    
    end
  end

	-- select start position 
	map[3][3].current = "on"
	pass_current_y = 3
	pass_current_x = 3
	map[3][3].ttype = "wall"

	-- stack feed  
  table.insert(map_stack, 1, {})
  map_stack[1][1] = pass_current_y
  map_stack[1][2] = pass_current_x

	-- adding first frontier set
	-- top // left // right // bottom
	call_add_frontier()

	-- pick random frontier
	random_frontier()

	-- set pass_current
	set_pass()

	-- loop	
	while #map_stack > 0 do

		-- top // left // right // bottom
		call_add_frontier()

		-- new current frontier
		random_frontier()

		while #rand_array == 0 and #map_stack > 0 do
      table.remove(map_stack, 1)

			if #map_stack > 0 then
			pass_current_y = map_stack[1][1]
			pass_current_x = map_stack[1][2]

			-- top // left // right // bottom
			call_add_frontier()

			-- new current frontier
			random_frontier()
			end
		end

		-- set pass_current
		if #map_stack > 0 then
			set_pass()
		end

	end-- END WHILE

end