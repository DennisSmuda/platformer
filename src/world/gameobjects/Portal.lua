
Portal = class('Portal')

function Portal:initialize(x, y, type)
  self.x = x*16-8
  self.y = y*16-8
  self.image = portal_purple_img
  if type == 'purple' then
    self.image = portal_purple_img
  elseif type == 'green' then
    self.image = portal_green_img
  end

end

function Portal:draw()
  love.graphics.draw(self.image, self.x, self.y)
end
