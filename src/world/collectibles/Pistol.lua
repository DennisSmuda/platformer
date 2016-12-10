require('src.world.collectibles.Collectible')

Pistol = class('Pistol', Collectible)

function Pistol:initialize (x,y)
  Collectible.initialize(self, x, y, 'Pistol')

  self.lastShot   = 0
  self.shotDelay  = 300

  self.bullets    = {}

end


function Pistol:update(dt)
  if self.showMessage then
    Collectible:handleInput(dt)
  end

  if self.owner then
    self:handleInput(dt)
  end
end

function Pistol:draw()

  if self.owner == nil then
    love.graphics.draw(pistol_img, self.x+self.xOff, self.y+self.yOff)
  else
    self:drawOnOwner()
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

  if love.keyboard.isDown("right") then
    self:shoot('right')
  end
end

function Pistol:shoot(dir)
  print("Shoot : " .. dir)
end
