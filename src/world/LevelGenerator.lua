
LevelGenerator = class('LevelGenerator')

function LevelGenerator:initialize()

end

function initializeGrid(width, height)
  local grid = {}
  for i=1,width do
    grid[i] = {}

    for j=1,height do
      grid[i][j] = 3
    end

  end

  grid[1][1] = 5
  grid[4][1] = 6

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


function LevelGenerator.generateCaves(width, height)
  local generations = 15
  local len = width * height
  local mapData = {}

  local grid = initializeGrid(width, height)
  local data = convertGridToData(grid)


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
