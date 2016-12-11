
Portal = class('Portal')

function Portal:initialize(x, y)
  self.x = x*16-8
  self.y = y*16-8
  self.image = portal_img

end

function Portal:draw()
  love.graphics.draw(self.image, self.x, self.y)
end
