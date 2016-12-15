
Fragment = class('Fragment')

function Fragment:initialize(x, y, type)
  self.x      = x
  self.y      = y
  self.type   = type


  if self.type == 1 then
    self.image = blockFragmentQuad
  elseif self.type == 2 then
    self.image = grassFragmentQuad
  end


end
function Fragment:update(dt)
end
function Fragment:draw()
  love.graphics.draw(tileset, self.image, self.x, self.y)
end
