require 'src.world.collectibles.Collectible'
require 'src.world.gameobjects.Bullet'

Pistol = class('Pistol', Collectible)

function Pistol:initialize (x,y)
  Collectible.initialize(self, x, y, 'Pistol')
love.keyboard.setKeyRepeat(false)

  self.lastShot   = 0
  self.shotDelay  = 1


  self.bullets    = {}

end


function Pistol:update(dt)
  if self.showMessage then
    Collectible:handleInput(dt)
  end

  if self.owner then
    self:handleInput(dt)
  end
  --== Update Bullets
  for i,bullet in ipairs(self.bullets) do
    bullet:update(dt)
  end
end

function Pistol:draw()

  if self.owner == nil then
    love.graphics.draw(pistol_img, self.x+self.xOff, self.y+self.yOff)
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
  -- TODO: Draw
  love.graphics.draw(pistol_img, self.owner.x+self.xOff, self.owner.y+self.height+1)
end


function Pistol:handleInput(dt)

  if love.keyboard.isScancodeDown('right') then
    local now = love.timer.getTime()
    local canShoot = now - self.lastShot > self.shotDelay

    if  canShoot then
    -- self:shoot('right')
      local bullet = Bullet(self.owner.x, self.owner.y, 'right')
      table.insert(self.bullets, bullet)

      self.lastShot = love.timer.getTime()
    end

  end
end

function Pistol:shoot(dir)
  screen:setShake(3)

  -- print("Shoot : " .. dir)
  local bullet = Bullet(self.owner.x, self.owner.y, dir)
  table.insert(self.bullets, bullet)
end
