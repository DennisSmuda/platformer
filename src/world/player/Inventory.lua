-- local collectibles = require "src.config.collectibles"

Inventory = class('Inventory')

function Inventory:initialize()
  self.size     = 6
  self.numItems = 0
  self.items = {}
  self.activeItem = nil


  for i=1,self.size do
    self.items[i] = {}
  end

  self.xOff = love.graphics.getWidth()
  self.yOff = love.graphics.getHeight()/8
  print(self.xOff)
end

function Inventory:update(dt)

end

function Inventory:draw()
  for i=1,self.size do
    love.graphics.draw(inventoryFrame_img, camera.x-85 + (i*24), camera.y+self.yOff)
  end

end

function Inventory:addItem(type)

end
