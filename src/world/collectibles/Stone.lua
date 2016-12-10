require('src.world.collectibles.Collectible')

Stone = class('Stone', Collectible)

function Stone:initialize(x, y)
  Collectible.initialize(self, x, y, 'Stone')
end

function Stone:update(dt)

end

function Stone:draw()
  love.graphics.draw(stone_img, self.x+self.xOff, self.y+self.yOff)

  --== Show Pickup Message
  if self.showMessage == true and self.owner == nil then
    love.graphics.printf("[E] to pick up", player.x-30, player.y - 16, 70, "center")
  end
end


function Stone:toggleMessage(value)
  self.showMessage = value

end
