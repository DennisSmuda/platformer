
LevelGenerator = class('LevelGenerator')

function LevelGenerator:initialize()

end

function LevelGenerator.generateCaves(width, height)
  local len = width * height
  local mapData = {}

  --== Fill array 50% blocks
  for i=1,len do
    local rand = love.math.random()
    if rand < 0.5 then
      table.insert(mapData, 0)
    else
      table.insert(mapData, 0)
    end
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

  return mapData


  -- return {
  --   3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  --   3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
  --   3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
  --   3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
  --   3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
  --   3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
  --   3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
  --   3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
  --   3, 0, 5, 0, 4, 0, 0, 6, 0, 3,
  --   3, 3, 3, 3, 3, 3, 3, 3, 3, 3
  -- }


end
