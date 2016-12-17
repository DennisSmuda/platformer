
Fragment = class('Fragment')

function Fragment:initialize(x, y, type)
  self.x      = x
  self.y      = y
  self.xVel   = love.math.random(-2, 2)
  self.yVel   = love.math.random(-1,-2.5)
  self.gravity = 9.81
  self.type   = type
  self.width  = 8
  self.height = 8
  self.isFragment = true
  self.friction = 3
  self.isGrounded = false


  if self.type == 1 then
    self.image = blockFragmentQuad
  elseif self.type == 2 or self.type == 3 or self.type == 7 then
    self.image = earthFragmentQuad
  end

  world:add(self, self.x, self.y, self.width, self.height)

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
  love.graphics.draw(tileset, self.image, self.x-1, self.y-1)
end
