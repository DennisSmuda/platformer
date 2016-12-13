
Bullet = class('Bullet')


function Bullet:initialize(x, y, dir)
  self.x      = x
  self.y      = y
  self.xOff   = 0
  self.yOff   = 5
  self.dir    = dir
  self.image  = bullet_img
  self.width  = 4
  self.height = 4
  self.speed  = 0
  self.active = true

  self.explosionG = anim8.newGrid(12,12, explosionset:getDimensions())
  self.explosion_anim = anim8.newAnimation(self.explosionG('1-4', 1), 0.1, function(anim, numLoops)
    self.dead = true
    print("FUCK")
    -- screen:setShake(0)
  end)

  self.exploding = false
  self.dead      = false

  if self.dir == 'right' then
    self.speed  = 80
    self.xOff = 14
  elseif self.dir == 'left' then
    self.xOff = -10
    self.speed  = -80
  end

  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
end

function BulletFilter(other, b)
  if other.isPlatform then return 'touch'
  elseif other.isPlayer then return nil
  else return 'touch'
  end
end

function Bullet:update(dt)
  if self.exploding then
    self.explosion_anim:update(dt)
    return
  end


  local goalX = self.x + self.speed*dt
  local actualX, actualY, cols, len = world:move(self, goalX, self.y+self.yOff, BulletFilter)

  self.x = actualX

  for i=1, len do
    local other = cols[i].other
    local normal = cols[i].normal

    if other.isPlatform == true then
      self.exploding = true
      screen:setShake(4)
      world:remove(self)
      other:takeDamage(1)
    end


  end

end

function Bullet:draw()

  if self.exploding == false and self.dead == false then
    love.graphics.draw(self.image, self.x, self.y+self.yOff)
  elseif self.exploding == true and self.dead == false then
    self.explosion_anim:draw(explosionset, self.x, self.y)
  end
end
