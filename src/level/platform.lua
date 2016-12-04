
Platform = class('Platform')

function Platform:initialize(x,y, type)
  self.WorldCoords = {x = x, y = y}
  self.x = x*16
  self.y = y*16
  self.width = 16
  self.height = 15
  self.type = type

  if self.type then
    -- print(self.type > 0)
    if self.type > 0 then
      world:add(self, self.x, self.y, self.width, self.height)
      self.isPlatform = true
    end
  end

  self.alpha = love.math.random(0, 255)



end

function Platform:draw ()

  -- love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.setColor(0, 0, 0, self.alpha)
  if self.type > 0 then
    love.graphics.draw(tileset, block, self.x, self.y)
  end
  -- love.graphics.rectangle("fill", self.x, self.x, 16, 16)

end
