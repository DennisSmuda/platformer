
Tile = class('Tile')

function Tile:initialize(x,y, type)
  self.WorldCoords = {x = x, y = y}
  self.x = x*16
  self.y = y*16
  self.width = 16
  self.height = 16
  self.type = type
  self.health = 5
  self.padding = 1 -- tileset padding to prevent 'bleeding'

  self.psystem = love.graphics.newParticleSystem(block_particle, 8)
	self.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	self.psystem:setEmissionRate(5)
	self.psystem:setSizeVariation(1)
	self.psystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

  --== Check validity and set variables accordingly
  if self.type then
    if self.type > 0 then
      world:add(self, self.x+1, self.y+1, self.width, self.height)
      self.isPlatform = true
    end

    if self.type == 1 then
      self.image = blockQuad
    elseif self.type == 2 then
      self.image = grassQuad
    end
  end



end

function Tile:draw ()

  if self.type > 0 and self.health > 0 then
    love.graphics.draw(tileset, self.image, self.x, self.y)
  end

  if self.health == 4 then
    love.graphics.draw(block_damage_set, block_damage_1, self.x, self.y)
  elseif self.health == 3 then
    love.graphics.draw(block_damage_set, block_damage_2, self.x, self.y)
  elseif self.health == 2 then
    love.graphics.draw(block_damage_set, block_damage_3, self.x, self.y)
  elseif self.health == 1 then
    love.graphics.draw(block_damage_set, block_damage_4, self.x, self.y)
  elseif self.health == 0 then
    --== Draw Particles after destruction
    if self.particleStart == nil then
      self.particleStart = love.timer.getTime()
    end
    love.graphics.draw(self.psystem, self.x+8, self.y+8)
  end

end


function Tile:update(dt)
  self.psystem:update(dt)
end


function Tile:takeDamage(amount)
  print("Take Damage")
  self.health = self.health - amount

  if self.health == 0 then
    world:remove(self)
  end
end
