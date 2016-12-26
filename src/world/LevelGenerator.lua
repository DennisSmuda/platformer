
LevelGenerator = class('LevelGenerator')

function LevelGenerator:initialize()
end

function initializeGrid(width, height, chance)
  local grid = {}
  for i=1,width do
    grid[i] = {}

    for j=1,height do

      local rand = love.math.random()
      if rand > chance/100 then
        grid[i][j] = 51
      else
        grid[i][j] = 0
      end

    end
  end

  return grid
end

function convertGridToData(grid)
  local data = {}
  for i,col in ipairs(grid) do
    for j,row in ipairs(grid) do
      table.insert(data, grid[j][i])
    end
  end

  return data
end


function makeBounds(grid, width, height)
  local grid = grid

  for i=1,width do
    for j=1,height do

      if j == 1 or j == height then
        grid[i][j] = 54
      end

      if i == 1 or i == width then
        grid[i][j] = 54
      end

    end
  end

  return grid
end


function makePortalRoomInCorner(grid, type, width, height)
  local x, y
  if type == 5 then -- Top Right beginning
    x, y = 3,3
  elseif type == 6 then
    x, y = width-3,height-1
  end

  --== Occupies 3x3 Tilespace, clear 2x3 on top, and set boundary on the ground.
  grid[x][y] = type
  grid[x-1][y] = 0
  grid[x+1][y] = 0
  grid[x][y-1] = 0
  grid[x+1][y-1] = 0
  grid[x-1][y-1] = 0
  grid[x][y+1] = 54
  grid[x+1][y+1] = 54
  grid[x-1][y+1] = 54

  return grid

end

--== Returns true if the current tile is surrounded by more than 5 walls
function checkSurroundingTiles(grid, x, y, width, height)
  local count = 0

  if x > 1 and y > 1 then
    if grid[x-1][y-1] ~= 0 then count = count+1 end
  end
  if x < width and y < height then
    if grid[x+1][y+1] ~= 0 then count = count+1 end
  end
  if y > 1 then
    if grid[x  ][y-1] ~= 0 then count = count+1 end
  end
  if x > 1 then
    if grid[x-1][y  ] ~= 0 then count = count+1 end
  end
  if x < width and y > 1 then
    if grid[x+1][y-1] ~= 0 then count = count+1 end
  end
  if x < width then
    if grid[x+1][y  ] ~= 0 then count = count+1 end
  end
  if x > 1 and y < height then
    if grid[x-1][y+1] ~= 0 then count = count+1 end
  end
  if y < height then
    if grid[x  ][y+1] ~= 0 then count = count+1 end
  end


  if count >= 5 then
    return true
  else
    return false
  end
end

function cellularAutomata(grid, width, height)
  -- 10 Generations
  for i=1,3 do
    for i=1,width do
      for j=1,height do

        if checkSurroundingTiles(grid, i, j, width, height) == true then
          grid[i][j] = 51
        end

      end
    end
  end

  return grid
end


function LevelGenerator.generateCaves(width, height)
  local len = width * height

  local emptygrid = initializeGrid(width, height, 70) --== 65% empty initial spawn
  local cellulargrid = cellularAutomata(emptygrid, width, height)
  local boundedgrid = makeBounds(cellulargrid, width, height)
  --== Start/Finish Locations
  makePortalRoomInCorner(boundedgrid, 5)
  makePortalRoomInCorner(boundedgrid, 6, width, height)
  --== Convert to 1D
  local data = convertGridToData(boundedgrid)

  return data

end
