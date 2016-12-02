require "src.level.Cloud"

Level = class('Level')

function Level:initialize()
  self.platforms = {}
  map = require("assets.data.testlevel")["layers"][1]
  --== Map stored as 1-D Array of ID's
  mapData = map.data
  mapWidth = map.width


  for i,tile in ipairs(mapData) do
    --== Correct mapping of index to x/y coords
    local x,y = i%mapWidth, math.floor(i/mapWidth)
    if x == 0 then
      x = i
      if x >= 100 then
        x = x/mapWidth
      end
    end
    -- print(i, x,y, tile)
    local platform = Platform(x, y, tile)
    table.insert(self.platforms, platform)

  end



end

function Level:update(dt)
  -- map:update(dt)

end

function Level:draw()
  -- map:draw()
  for i,tile in ipairs(self.platforms) do
    tile:draw()
  end


end
