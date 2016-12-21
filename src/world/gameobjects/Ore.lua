
Ore = class('Ore')

function Ore:initialize(x, y, type)
  self.x = x
  self.y = y
  self.width = 3
  self.height = 3
  self.type = type
  self.xVel   = love.math.random(-2, 2)
  self.yVel   = love.math.random(-1,-2.5)
  self.gravity = 9.81
  self.friction = 3
  self.isFragment = true
  self.isGrounded = false
  self.img = nil

  if self.type == 'stone' then
    self.img = stoneore_img
  end

  world:add(self, self.x, self.y, self.width, self.height)
end

function OreFilter(self, other)
  if other.isFragment then return 'cross'
  elseif other.isPlayer then
    return 'cross'
  elseif other.isPlatform then
    return 'slide'
  end
end

function Ore:update(dt)
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

function Ore:draw()
  print("Draw ORe")
  love.graphics.draw(self.img, self.x, self.y)
end
