
Portal = class('Portal')

function Portal:initialize(x, y, color, location, destination)
  self.x        = x*16-4
  self.y        = y*16-9
  self.width    = 24
  self.height   = 24
  self.isPortal = true
  self.showMessage = false
  self.image  = portal_purple_img
  self.location = location
  self.destination = destination

  if color == 'purple' then
    self.image = portal_purple_img
  elseif color == 'green' then
    self.image = portal_green_img
  end

  world:add(self, self.x, self.y, self.width, self.height)

end

function Portal:update(dt)
  if self.showMessage and player.inputEnabled then
    self:handlePassiveInput(dt)
  end

end

function Portal:toggleMessage(value)
  if self.destination then
    self.showMessage = value
  end
end

function Portal:draw()
  love.graphics.draw(self.image, self.x, self.y)

  if self.showMessage == true then
    love.graphics.printf("Teleport " .. self.destination, self.x-20, self.y - 16, 70, "center")
  end
end

function Portal:handlePassiveInput(dt)
  if love.keyboard.isDown('e') and self.destination then
    self.showMessage = false
    print("Teleport to " .. self.destination)
    player:toggleFloat(true, self.destination)
  end

end
