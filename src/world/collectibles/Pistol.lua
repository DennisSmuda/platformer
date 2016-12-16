require 'src.world.collectibles.Collectible'
require 'src.world.gameobjects.Bullet'

Pistol = class('Pistol', Collectible)

function Pistol:initialize (x,y)
  Collectible.initialize(self, x, y, 'Pistol')

  self.lastShot   = 0
  self.shotDelay  = 0.3
  self.canShoot   = false
  self.direction  = nil
  self.inventoryImg = blaster_right
  self.isActive   = false

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

  --== Update Gun - Recoil
  if self.owner then
    if self.xOff < 1 then
      self.xOff = self.xOff + 10*dt
    elseif self.xOff > 1 then
      self.xOff = self.xOff - 10*dt
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
    love.graphics.draw(blaster_right, self.owner.x+self.xOff, self.owner.y+self.yOff)
  elseif self.direction == 'left' then
    love.graphics.draw(blaster_left, self.owner.x+self.xOff, self.owner.y+self.yOff)
  end
end


function Pistol:handleInput(dt)
  local now = love.timer.getTime()
  -- print("Handle Input: " .. self.lastShot .. tostring(self.canShoot) )
  self.canShoot = now - self.lastShot > self.shotDelay
  if self.owner.isOnLeftWall or self.owner.isOnRightWall then
    self.canShoot = false
  end

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
    self.xOff = 1
    self.yOff = 5
    self.owner = player
    self.owner.inventory:addItem(self)
    world:remove(self)
  end

end

function Pistol:shoot(dir)
  -- Recoil for player and gun
  if dir == 'left' then
    self.xOff = self.xOff+3
    self.owner.xVel = self.owner.xVel + 1.5
  elseif dir == 'right' then
    self.xOff = self.xOff-3
    self.owner.xVel = self.owner.xVel - 1.5
  end

  -- print("Shoot : " .. dir)
  local bullet = Bullet(self.owner.x, self.owner.y, dir)
  table.insert(self.bullets, bullet)

end
