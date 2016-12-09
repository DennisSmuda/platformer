
Pistol = class('Pistol')

function Pistol:initialize (x,y)
  print(x, y)
  self.x = x*16
  self.y = y*16
  self.xOff = 6
  self.yOff = 12
  self.width = 5
  self.height = 4

  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
  self.isCollectible = true
end


function Pistol:update(dt)
end

function Pistol:draw()
  love.graphics.draw(pistol_img, self.x+self.xOff, self.y+self.yOff)
end
