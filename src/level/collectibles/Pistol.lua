require('src.level.collectibles.Collectible')

Pistol = class('Pistol', Collectible)

function Pistol:initialize (x,y)
  Collectible.initialize(self, x, y, 'Pistol')

end


function Pistol:update(dt)
  if self.showMessage then
    -- self:handleInput(dt)
    Collectible:handleInput(dt)
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
  if love.keyboard.isDown("e") and self.owner == nil then
    print("Fuck yea")
    self.owner = player
  end
end
