require "src.world.TileFactory"
require "src.world.CollectibleFactory"
require "src.world.gameobjects.Cloud"
require "src.world.gameobjects.Portal"
require "src.world.gameobjects.Ladder"
require "src.world.gameobjects.Fragment"


Level = class('Level')

function Level:initialize()
  self.worldObjects = {}
  self.collectibles = {}
  self.statics = {}
  self.fragments = {}

  self.tileFactory        = TileFactory()
  self.collectibleFactory = CollectibleFactory()


  tilelayers = require("assets.data.testlevel_1")["layers"]

  for i,layer in ipairs(tilelayers) do
    if layer.name == 'map' then
      mapLayer = layer
    elseif layer.name == 'staticgameobjects' then
      staticgameobjects = layer
    elseif layer.name == 'collectibles' then
      collectibleLayer = layer
    end
  end

  --== Map stored as 1-D Array of ID's
  mapData = mapLayer.data
  mapWidth = mapLayer.width
  statics = staticgameobjects.data
  collectibles = collectibleLayer.data

  self:makeWorldobjects(mapData)
  self:makeCollectibles(collectibles)
  --== Portals, Ladders, etc..
  self:setStatics(statics)

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
      table.insert(self.collectibles, collectible)
    end
  end

  -- local col = Pistol(6, 18)
  -- table.insert(self.collectibles, col)

end

function Level:setStatics(statics)
  for i,object in ipairs(statics) do
    local x,y = i%mapWidth, math.floor(i/mapWidth)
    if x == 0 then
      x = mapWidth
      y = y - 1
    end

    if object == 5 then
      --== Portal -> Set start Location
      gamestate.spawnLocation.x, gamestate.spawnLocation.y = x, y
      local static = Portal(x,y, 'purple')
      table.insert(self.statics, static)
    elseif object == 6 then
      local static = Portal(x,y, 'green')
      table.insert(self.statics, static)
    end
  end
end


function Level:resetMessages()
  for i,collectible in ipairs(self.collectibles) do
    collectible:toggleMessage(false)
  end
end


function Level:update(dt)
  for i,object in ipairs(self.worldObjects) do
    object:update(dt)
  end
  -- map:update(dt)
  for i,collectible in ipairs(self.collectibles) do
    collectible:update(dt)
  end

  for i,fragment in ipairs(self.fragments) do
    fragment:update(dt)
  end
end

function Level:draw()

end

function Level:drawStatics()
  for i,object in ipairs(self.statics) do
    object:draw()
    -- print(i , object)
  end
end

function Level:drawCollectibles()
  for i,collectible in ipairs(self.collectibles) do
    collectible:draw()
  end
end

function Level:drawTiles()
  for i,tile in ipairs(self.worldObjects) do
    tile:draw()
  end

  for i,fragment in ipairs(self.fragments) do
    fragment:draw()
  end
end


function Level:spawnFragments(x, y, type, amount)
  for i=1,amount do
    local xOff, yOff = 1, 1

    if i == 2 then
      xOff,yOff = 7, 1
    elseif i == 3 then
      xOff,yOff = 1, 8
    elseif i == 4 then
      xOff,yOff = 7, 8
    end

    local fragment = Fragment(x+xOff, y+yOff, type)
    table.insert(self.fragments, fragment)
  end

end
