require 'src.world.collectibles.Collectible'
require 'src.world.gameobjects.Bullet'

Pistol = class('Pistol', Collectible)

function Pistol:initialize (x,y)
  Collectible.initialize(self, x, y, 'Pistol')

  self.lastShot   = 0
  self.shotDelay  = 1
  self.canShoot   = false
  self.direction  = nil

  self.bullets    = {}
end


function Pistol:update(dt)
  if self.showMessage then
    self:handlePassiveInput(dt)
  end

  if self.owner then
    self:handleInput(dt)
    -- Update direction
    self.direction  = self.owner.direction
  end

  --== Update Bullets
  for i,bullet in ipairs(self.bullets) do
    bullet:update(dt)

    if bullet.dead == true then
      -- world:remove(bullet)
      table.remove(self.bullets, i)
    end

  end

end

function Pistol:draw()

  if self.owner == nil then
    love.graphics.draw(blaster_right, self.x+self.xOff, self.y+self.yOff)
  else
    self:drawOnOwner()
  end

  --== Draw Bullets
  for i,bullet in ipairs(self.bullets) do
    bullet:draw()
  end


  --== Show Pickup Message
  if self.showMessage == true and self.owner == nil then
    love.graphics.printf("[E] to pick up", player.x-30, player.y - 16, 70, "center")
  end
end


--== Needs to be drawn depending on owners location and direction
function Pistol:drawOnOwner()

  if self.direction == 'right' then
    love.graphics.draw(blaster_right, self.owner.x+self.xOff, self.owner.y+self.height+1)
  elseif self.direction == 'left' then
    love.graphics.draw(blaster_left, self.owner.x+self.xOff, self.owner.y+self.height+1)
  end
end


function Pistol:handleInput(dt)
  local now = love.timer.getTime()
  -- print("Handle Input: " .. self.lastShot .. tostring(self.canShoot) )
  self.canShoot = now - self.lastShot > self.shotDelay

  --== Shoot Bullets Left/Right
  if love.keyboard.isDown('right') and self.canShoot == true then

    self.canShoot = false
    self.lastShot = love.timer.getTime()
    self:shoot('right')

  elseif love.keyboard.isDown('left') and self.canShoot == true then

    self.canShoot = false
    self.lastShot = love.timer.getTime()
    self:shoot('left')

  end
end

function Pistol:handlePassiveInput(dt)
  if love.keyboard.isDown("e") then
    self.owner = player
    world:remove(self)
  end

end

function Pistol:shoot(dir)
  screen:setShake(3)

  -- print("Shoot : " .. dir)
  local bullet = Bullet(self.owner.x, self.owner.y, dir)
  table.insert(self.bullets, bullet)

end
