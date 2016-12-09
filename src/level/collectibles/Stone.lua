
Stone = class('Stone')

function Stone:initialize(x, y)
  self.x = x*16
  self.y = y*16
  self.xOff = 6
  self.yOff = 12
  self.width = 4
  self.height = 4

  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
  self.isCollectible = true
end

function Stone:update(dt)

end

function Stone:draw()
  love.graphics.draw(stone_img, self.x+self.xOff, self.y+self.yOff)
end
