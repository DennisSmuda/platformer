
Portal = class('Portal')

function Portal:initialize(x, y)
  self.x = x*16
  self.y = y*16
  self.image = portalQuad

end

function Portal:draw()
  love.graphics.draw(tileset, self.image, self.x, self.y)
end
