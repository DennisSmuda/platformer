
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

  self.explosionG = anim8.newGrid(18,18, explosionset:getDimensions())
  self.explosion_anim = anim8.newAnimation(self.explosionG('1-4', 1), 0.065, function(anim, numLoops)
    self.dead = true
  end)

  self.exploding = false
  self.dead      = false


  self.psystem = love.graphics.newParticleSystem(particle_img, 2)
	self.psystem:setParticleLifetime(2, 4) -- Particles live at least 2s and at most 5s.
	self.psystem:setEmissionRate(5000)
	self.psystem:setSizeVariation(0.1)
	self.psystem:setLinearAcceleration(-200, -200, 200, 250) -- Random movement in all directions.
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.


  if self.dir == 'right' then
    self.speed  = 120
    self.xOff = 12
    self.psystem:setLinearAcceleration(-400, -100, -500, 100) -- Random movement in all directions.
  elseif self.dir == 'left' then
    self.xOff = -12
    self.speed  = -120
    self.psystem:setLinearAcceleration(400, -100, 500, 100) -- Random movement in all directions.
  end
  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
end

function BulletFilter(self, other)
  if other.isPlatform then return 'touch'
  elseif other.isPlayer == true then
     return 'touch'
  elseif other.isCollectible or other.isFragment then
    return 'cross'
  end
end

function Bullet:update(dt)
  --== If something was hit, the explosion starts playing, and
  if self.exploding then
    self.explosion_anim:update(dt)
    self.psystem:update(dt)
    return
  end


  --== Move Bullet
  -- local goalX = (self.x+self.xOff) + self.speed*dt
  local goalX = self.x+ self.speed*dt
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
    self.explosion_anim:draw(explosionset, self.x-9, self.y-3)
    --== Draw Particles after destruction
    if self.particleStart == nil then
      self.particleStart = love.timer.getTime()
    end
    love.graphics.draw(self.psystem, self.x+4, self.y+4)
  end
end
