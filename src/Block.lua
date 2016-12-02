
Block = class("Block")

function Block:initialize(x, y, health)
  self.type = 'block'
  self.width = 90
  self.height = 25
  self.x = x
  self.y = y
  self.health = health

  if self.health == 0 then
    self.isEmpty = true;
  end
  world:add(self, self.x, self.y, self.width, self.height)
end

function Block:moveX(pos)
  self.x = pos
  world:update(self, self.x, self.y)
end


function Block:hit()
  if self.health > 1 then
    blockhit_sound:play()
    screen:setShake(1)
  end
  self.health = self.health - 1
end


function Block:die()
  screen:setShake(4)
  blockbreak_sound:play()
  gamestate.points = gamestate.points + 10
  world:remove(self)
end

function Block:draw()
  if self.health == 3 then
    love.graphics.setColor(Colors.green)
  elseif self.health == 2 then
    love.graphics.setColor(Colors.orange)
  elseif self.health == 1 then
    love.graphics.setColor(Colors.red)
  elseif self.health == 0 then
    love.graphics.setColor(0, 0, 0, 0)
  end
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
