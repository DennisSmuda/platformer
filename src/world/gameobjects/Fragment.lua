
Fragment = class('Fragment')

function Fragment:initialize(x, y, type)
  self.x      = x+8
  self.y      = y+4
  self.xVel   = love.math.random(-2, 2)
  self.yVel   = love.math.random(-1,-2.5)
  self.gravity = 9.81
  self.type   = type
  self.width  = 8
  self.height = 8
  self.isFragment = true
  self.fragmentCount = 0
  self.friction = 3
  self.isGrounded = false


  self.pickupTarget = nil
  self.name = 'Empty'


  if self.type == 53 then
    self.image = blockFragmentQuad
    self.name = 'Block'
    world:add(self, self.x, self.y, self.width, self.height)
  elseif self.type == 51 or self.type == 52 or self.type == 54 then
    self.image = earthFragmentQuad
    self.name = 'Dirt'
    world:add(self, self.x, self.y, self.width, self.height)
  end

end

function FragmentFilter(self, other)
  if other.isFragment then return 'cross'
  elseif other.isPlayer then
    return 'cross'
  elseif other.isPlatform then
    return 'slide'
  end
end

function Fragment:update(dt)
  --== When Item is getting picked up, make it fly towards left of
  --== the screen (Where Inventory is)
  if self.pickupTarget then

    if self.fragmentCount == 1 then
      --== First fragment follows player
      local goalX, goalY = self.pickupTarget.x-6, self.pickupTarget.y-6
      self.x = self.x + ((goalX - self.x)*0.05)
      self.y = self.y + ((goalY - self.y)*0.05)
      return
    else
      local goalX = self.pickupTarget.fragments[self.fragmentCount-1].x-6
      local goalY = self.pickupTarget.fragments[self.fragmentCount-1].y
      self.x = self.x + ((goalX - self.x)*0.05)
      self.y = self.y + ((goalY - self.y)*0.05)
      return
    end

  end

  local goalX, goalY = self.x+ self.xVel, self.y + self.yVel
  local actualX, actualY, cols, len = world:move(self, goalX, goalY, FragmentFilter)

  self.x, self.y = actualX, actualY

  for i=1, len do
    local other = cols[i].other
    local normal = cols[i].normal

    if normal.y == -1 then
      -- print("Fragment Hit Ground")
      self.grounded = true
    end

  end

  --== Gravity and Friction
  self.yVel = self.yVel + self.gravity*dt
  if self.yVel > self.gravity then self.yVel = self.gravity end
  self.xVel = self.xVel * (1 - math.min(dt*self.friction, 1))

  if self.grounded == true and self.yVel > self.gravity*0.5 then
    self.yVel = 0
  end

end
function Fragment:draw()
  love.graphics.draw(fragment_set, self.image, self.x-1, self.y-1)
end
