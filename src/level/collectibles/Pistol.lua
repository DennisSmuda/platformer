
Pistol = class('Pistol')

function Pistol:initialize (x,y)
  self.x = x*16
  self.y = y*16
  self.xOff = 6
  self.yOff = 12
  self.width = 5
  self.height = 4

  self.owner = nil
  self.showMessage = false

  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
  self.isCollectible = true
end


function Pistol:update(dt)
  -- print("Fuck update")
end

function Pistol:draw()
  love.graphics.draw(pistol_img, self.x+self.xOff, self.y+self.yOff)
  if self.showMessage == true then
    love.graphics.printf("[E] to pick up", player.x-50, player.y - 16, 100, "center")
  end
end

function Pistol:toggleMessage(value)
  self.showMessage = value
end
