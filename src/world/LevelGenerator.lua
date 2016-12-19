
LevelGenerator = class('LevelGenerator')

function LevelGenerator:initialize()

end

function initializeGrid(width, height)
  local grid = {}
  for i=1,width do
    grid[i] = {}

    for j=1,height do
      grid[i][j] = 51
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
  print("height : " .. height )

  for i=1,width do

    for j=1,height do

      if j == 1 then
        grid[i][j] = 54
      end

      if j == height then
        print("last row: " .. i .. ':' ..j .. ' :: ' .. grid[i][j])
        grid[i][j] = 54
        print("last row: " .. i .. ':' ..j .. ' :: ' .. grid[i][j])
      end

      if i == 1 or i == width then
        grid[i][j] = 54
      end

    end

  end

  return grid
end

function makePortalRoom(grid, type, width, height)
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

end


function LevelGenerator.generateCaves(width, height)
  local generations = 15
  local len = width * height
  local mapData = {}

  local emptygrid = initializeGrid(width, height)
  local boundedgrid = makeBounds(emptygrid, width, height)
  makePortalRoom(boundedgrid, 5)
  makePortalRoom(boundedgrid, 6, width, height)
  --== Start/Finish Locations
  -- boundedgrid[1][1] = 5
  -- boundedgrid[4][1] = 6
  local data = convertGridToData(boundedgrid)


  --== Clear First Row
  for i=1,width do
    mapData[i] = 0
  end

  --== Insert Portal (5=in/6=out)
  mapData[1] = 0
  mapData[2] = 5
  mapData[3] = 0
  mapData[1+width] = 3
  mapData[2+width] = 3
  mapData[3+width] = 3

  mapData[7] = 0
  mapData[8] = 6
  mapData[9] = 0
  mapData[7+width] = 3
  mapData[8+width] = 3
  mapData[9+width] = 3

  return data

end
