
Portal = class('Portal')

function Portal:initialize(x, y, type)
  self.x        = x*16-8
  self.y        = y*16-8
  self.width    = 24
  self.height   = 24
  self.isPortal = true
  self.showMessage = false
  self.image  = portal_purple_img

  if type == 'purple' then
    self.image = portal_purple_img
  elseif type == 'green' then
    self.image = portal_green_img
  end

  world:add(self, self.x, self.y, self.width, self.height)

end

function Portal:update(dt)
  print("Handle Input")
  if self.showMessage then
    self:handlePassiveInput(dt)
  end
end

function Portal:toggleMessage(value)
  self.showMessage = value
end

function Portal:draw()
  love.graphics.draw(self.image, self.x, self.y)

  if self.showMessage == true then

    love.graphics.printf("[E] to Teleport", self.x-20, self.y - 16, 70, "center")
  end
end

function Portal:handlePassiveInput(dt)
  if love.keyboard.isDown('e') then
    print("Teleport")
  end

end
