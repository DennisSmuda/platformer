
Bat = class('Bat')

function Bat:initialize(x, y)
  self.x = x
  self.y = y
  self.xVel = 0
  self.yVel = 0

  self.width = 4
  self.height = 10
  self.xOff = 2
  self.yOff = 2
  self.health = 5
  self.direction = 'left'

  self.target = nil
  self.alive = true

  self.isEnemy = true
  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)

end

function Bat:checkSurroundings()

  local items, len = world:queryRect(self.x-26, self.y-(4+16), 64, 16+32)

  for i=1,len do
    if items[i].isPlayer == true then
      local player = items[i]

      self.target = player


    end
  end

end


function Bat:update(dt)
  if self.target == nil then
    self:checkSurroundings()
  end

  if self.target and self.alive then
    self:moveTowardsTarget(dt)
  end


  batRight:update(dt)
  batLeft:update(dt)

end

function Bat:draw()
  if self.health > 0 then

    if self.direction == 'left' then
      batRight:draw(batset, self.x, self.y)
    elseif self.direction == 'right' then
      batLeft:draw(batset, self.x, self.y)
    end

  end


end


function Bat:takeDamage(value, dir)
  self.health = self.health - value

  if self.target == nil then
    self.target = player
  end

  if dir == 'left' then
    self.x = self.x - 6
  elseif dir == 'right' then
    self.x = self.x + 6
  end

  if self.health <= 0 then
    world:remove(self)
    self.alive = false
  end
end


function Bat:moveTowardsTarget(dt)
  local goalX, goalY = self.target.x, self.target.y

  self.x = self.x + ((goalX - self.x)*0.008)
  self.y = self.y + ((goalY - self.y)*0.008)
  world:update(self, self.x, self.y)

end
