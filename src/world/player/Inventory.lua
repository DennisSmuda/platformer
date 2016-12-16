-- local collectibles = require "src.config.collectibles"

Inventory = class('Inventory')

function Inventory:initialize()
  self.size     = 6
  self.numItems = 0
  self.items = {}
  self.activeItem = 1


  self.xOff = love.graphics.getWidth()
  self.yOff = love.graphics.getHeight()/7.5
  print(self.xOff)
end

function Inventory:update(dt)

end

function Inventory:draw()
  for i=1,self.size do

    if i == self.activeItem then
      love.graphics.setColor(255, 0, 0, 128)
    else
      love.graphics.setColor(255, 255, 255, 128)
    end
    love.graphics.draw(inventoryFrame_img, camera.x-85 + (i*24), camera.y+self.yOff)
    love.graphics.print(tostring(i), camera.x-84 + (i*24), camera.y+self.yOff+1)
    love.graphics.setColor(255, 255, 255, 255)
  end

  for i,item in ipairs(self.items) do
    love.graphics.draw(item.inventoryImg, camera.x-81 + (i*24), camera.y+self.yOff+6)
  end

end

function Inventory:addItem(item)

  table.insert(self.items, item)

end
