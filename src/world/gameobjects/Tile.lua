
Tile = class('Tile')

function Tile:initialize(x,y, type, location)
  self.WorldCoords = {x = x, y = y}
  self.x          = x*16
  self.y          = y*16
  self.width      = 16
  self.height     = 16
  self.type       = type
  self.health     = 5
  self.destructible = true
  self.padding    = 1 -- tileset padding to prevent 'bleeding'
  self.location   = location
  self.fragments  = love.math.random(2,5)
  self.oreImg     = nil
  self.oreType    = nil

  if self.type then
  else self.type = 0 end


  --== Check validity and set variables accordingly
  if self.type then
    if self.type > 0 then
      world:add(self, self.x+1, self.y+1, self.width, self.height)
      self.isPlatform = true
      self:setImage()
    end

  end

end

function Tile:setImage()
  if self.type == 51 then
    self.image = earthQuad
    if self.location ~= 'home' then
      self.health = love.math.random(3,5)
      self:spawnOre()
    end
  elseif self.type == 52 then
    self.image = grassQuad
  elseif self.type == 53 then
    self.image = blockQuad
  elseif self.type == 54 then
    self.image = boundaryBlockQuad
    self.destructible = false
  elseif self.type == 55 then
    self.image = earthEmptyQuad
  end
end

function Tile:spawnOre()
  local rand = love.math.random()

  if rand < 0.4 then -- 10% Chance stone
    self.oreImg = stoneOreQuad
    self.oreType = 'stone'
  elseif rand < 0.65 then
    self.oreImg = ironOreQuad
    self.oreType = 'iron'
  elseif rand < 0.75 then
    self.oreImg = copperOreQuad
    self.oreType = 'copper'
  elseif rand < 0.85 then
    self.oreImg = silverOreQuad
    self.oreType = 'silver'
  elseif rand < 0.95 then
    self.oreImg = goldOreQuad
    self.oreType = 'gold'
  end

end

function Tile:draw ()

  if self.type > 0 and self.health > 0 then
    love.graphics.draw(tileset, self.image, self.x, self.y)
  end

  if self.health == 4 then
    love.graphics.draw(block_damage_set, block_damage_1, self.x, self.y+1)
  elseif self.health == 3 then
    love.graphics.draw(block_damage_set, block_damage_2, self.x, self.y+1)
  elseif self.health == 2 then
    love.graphics.draw(block_damage_set, block_damage_3, self.x, self.y+1)
  elseif self.health == 1 then
    love.graphics.draw(block_damage_set, block_damage_4, self.x, self.y+1)
  elseif self.health == 0 then
    --== Earth Quad resets to empty image
    if self.type == 3 and self.image ~= earthEmptyQuad then
      self.image = earthEmptyQuad
    end
  end

  if self.oreType and self.health > 0 then
    love.graphics.draw(oreset, self.oreImg, self.x+1, self.y+1)
  end

  -- love.graphics.print(self.x .. ":" .. self.y, self.x, self.y)

end


function Tile:update(dt)
  -- self.psystem:update(dt)
end


function Tile:takeDamage(amount)
  if self.destructible == false then return end
  self.health = self.health - amount

  if self.health <= 0 then
    level:spawnFragments(self.x, self.y, self.type, self.fragments, self.oreType)
    world:remove(self)
  end
end
