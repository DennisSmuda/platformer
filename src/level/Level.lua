require "src.level.gameobjects.Cloud"
require "src.level.TileFactory"
require "src.level.CollectibleFactory"

Level = class('Level')

function Level:initialize()
  self.worldObjects = {}
  self.collectibles = {}

  self.tileFactory        = TileFactory()
  self.collectibleFactory = CollectibleFactory()


  tilelayers = require("assets.data.testlevel_1")["layers"]

  for i,layer in ipairs(tilelayers) do
    if layer.name == 'map' then
      mapLayer = layer
    elseif layer.name == 'spawns' then
      spawnLayer = layer
    elseif layer.name == 'collectibles' then
      collectibleLayer = layer
    end
  end


  --== Map stored as 1-D Array of ID's
  mapData = mapLayer.data
  mapWidth = mapLayer.width
  spawns = spawnLayer.data
  collectibles = collectibleLayer.data

  self:makeWorldobjects(mapData)
  self:makeCollectibles(collectibles)


end

--== Static World Objects (Ground, Wall, Platforms, etc..)
function Level:makeWorldobjects(mapData)
  for i,tileType in ipairs(mapData) do
    --== Correct mapping of index to x/y coords - weird shit happens
    --== because lua starts counting at "1" instead of "0"
    local x,y = i%mapWidth, math.floor(i/mapWidth)
    if x == 0 then
      x = mapWidth
      y = y - 1
    end

    local tile = self.tileFactory.makeTile(x,y, tileType)
    table.insert(self.worldObjects, tile)
  end
end


function Level:makeCollectibles(collectibles)
  for i, collectibleType in ipairs(collectibles) do
    local x,y = i%mapWidth, math.floor(i/mapWidth)
    if x == 0 then
      x = mapWidth
      y = y - 1
    end

    if collectibleType > 0 then
      local collectible = self.collectibleFactory.makeCollectible(x,y,collectibleType)
      table.insert(self.worldObjects, collectible)
    end
  end
end




function Level:update(dt)
  -- map:update(dt)
end

function Level:draw()
  -- map:draw()
  for i,tile in ipairs(self.worldObjects) do
    tile:draw()
  end

end
