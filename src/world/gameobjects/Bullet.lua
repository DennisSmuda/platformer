
Bullet = class('Bullet')


function Bullet:initialize(x, y, dir)
  self.x      = x
  self.y      = y
  self.xOff   = 0
  self.yOff   = 5
  self.dir    = dir
  self.image  = bullet_img
  self.width  = 2
  self.height = 2
  self.speed  = 0

  if self.dir == 'right' then
    -- self.speed  = 80
    self.speed  = 20
    self.xOff = 14
  elseif self.dir == 'left' then
    self.xOff = 0
    self.speed  = -80
  end

  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
  print("Bullet Constructor")
end

function Bullet:update(dt)

  local goalX = self.x + self.speed*dt
  local actualX, actualY, cols, len = world:move(self, goalX, self.y+self.yOff)

  self.x = actualX



end

function Bullet:draw()
  love.graphics.draw(self.image, self.x, self.y+self.yOff)
end
