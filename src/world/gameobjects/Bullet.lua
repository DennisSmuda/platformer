
Bullet = class('Bullet')


function Bullet:initialize(x, y, dir)
  self.x      = x
  self.y      = y
  self.xOff   = 6
  self.yOff   = 2
  self.explosionXOff = 0
  self.explosionYOff = 0
  self.spread = love.math.random(-5, 1)
  self.dir    = dir
  self.image  = bullet_img
  self.width  = 4
  self.height = 4
  self.speedX  = 0
  self.speedY  = 0
  self.active = true
  self.isBullet = true

  self.explosionG = anim8.newGrid(18,18, explosionset:getDimensions())
  self.explosion_anim = anim8.newAnimation(self.explosionG('1-4', 1), 0.05, function(anim, numLoops)
    self.dead = true
  end)

  self.exploding = false
  self.dead      = false

  self.psystem = love.graphics.newParticleSystem(particle_img, 2)
	self.psystem:setParticleLifetime(2, 4) -- Particles live at least 2s and at most 5s.
	self.psystem:setEmissionRate(5000)
	self.psystem:setSizeVariation(0.1)
	self.psystem:setLinearAcceleration(-200, -200, 200, 250)
	self.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

  --== Set Velocity and Particle direction depending on direction
  if self.dir == 'right' then
    self.speedX  = 200
    self.explosionXOff = -4
    self.explosionYOff = -5
    self.psystem:setLinearAcceleration(-400, -100, -500, 100)
  elseif self.dir == 'left' then
    self.speedX  = -200
    self.explosionXOff = -7
    self.explosionYOff = -5
    self.psystem:setLinearAcceleration(400, -100, 500, 100)
  elseif self.dir == 'down' then
    self.speedY  = 200
    self.xOff = 2
    self.explosionXOff = -5
    self.explosionYOff = -7
    self.psystem:setLinearAcceleration(-100, 400, 100, 500)
  elseif self.dir == 'up' then
    self.speedY  = -200
    self.xOff = 2
    self.explosionXOff = -5
    self.explosionYOff = -7
    self.psystem:setLinearAcceleration(-100, 400, 100, 500)
  end

  --== Set initial world position
  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
  self.x = self.x+self.xOff
  self.y = self.y+self.yOff
end

function BulletFilter(self, other)
  if other.isPlatform then
    return 'touch'
  elseif other.isPlayer == true then
     return 'cross'
  elseif other.isCollectible or other.isFragment then
    return 'cross'
  elseif other.isEnemy then
    return 'touch'
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
  local goalX, goalY
  if self.speedX ~= 0 then --== Bullet moves either horizontally or vertically
    goalX, goalY = self.x + self.speedX*dt, self.y + self.spread*dt
  else
    goalX, goalY = self.x + self.spread*dt, self.y + self.speedY*dt
  end

  local actualX, actualY, cols, len = world:move(self, goalX, goalY, BulletFilter)

  self.x = actualX
  self.y = actualY

  for i=1, len do
    local other = cols[i].other
    local normal = cols[i].normal

    if other.isPlatform == true or other.isEnemy == true then
      self.exploding = true
      screen:setShake(4)
      world:remove(self)
      if other.isPlatform then
        other:takeDamage(1)
      elseif other.isEnemy then
        other:takeDamage(1, self.dir)
      end
    end

  end

end

function Bullet:draw()

  if self.exploding == false and self.dead == false then
    love.graphics.draw(self.image, self.x, self.y)
  elseif self.exploding == true and self.dead == false then
    self.explosion_anim:draw(explosionset, self.x+self.explosionXOff, self.y+self.explosionYOff)
    --== Draw Particles after destruction
    if self.particleStart == nil then
      self.particleStart = love.timer.getTime()
    end
    love.graphics.draw(self.psystem, self.x+4, self.y+4)
  end
end
