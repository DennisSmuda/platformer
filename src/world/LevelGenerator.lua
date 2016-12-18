
LevelGenerator = class('LevelGenerator')

function LevelGenerator:initialize()

end

function checkSurroundingTiles(data, width, i)
  local count = 0
  if data[i+1] ~= 0 then count = count+1 end
  if data[i-1] ~= 0 then count = count+1 end
  if data[i+1-width] ~= 0 then count = count+1 end
  if data[i-1-width] ~= 0 then count = count+1 end
  if data[i-width] ~= 0 then count = count+1 end
  if data[i+width] ~= 0 then count = count+1 end
  if data[i+1+width] ~= 0 then count = count+1 end
  if data[i-1+width] ~= 0 then count = count+1 end

  if count >= 5 then
    return true
  else
    return false
  end

end

function LevelGenerator.generateCaves(width, height)
  local generations = 15
  local len = width * height
  local mapData = {}

  --== Fill array 50% blocks
  for i=1,len do
    local rand = love.math.random()
    if rand < 0.3 then
      table.insert(mapData, 3)
    else
      table.insert(mapData, 0)
    end
  end

  for i=1, generations do

    for i=1,len do
      local check = checkSurroundingTiles(mapData, width, i)
      if check == true then
        print("Checked")
        mapData[i] = 3
      end
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
