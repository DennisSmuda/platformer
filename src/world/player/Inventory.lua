-- local collectibles = require "src.config.collectibles"

Inventory = class('Inventory')

function Inventory:initialize()
  self.size     = 10
  self.numItems = 0
  self.items    = {}
  self.active   = false

  self.xOff = love.graphics.getWidth()/5.8
  self.yOff = love.graphics.getHeight()/7.5
  print(self.xOff)
end

function Inventory:update(dt)

end

function Inventory:draw()
  if self.active == false then return end

  love.graphics.setColor(255, 0, 0, 128)
  love.graphics.setColor(255, 255, 255, 128)
  love.graphics.rectangle("fill", camera.x-self.xOff, camera.y-self.yOff, 120, 120)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf("Inventory", camera.x-self.xOff, camera.y-self.yOff + 4, 120, 'center')


  for i,item in ipairs(self.items) do
    love.graphics.draw(item.inventoryImg, camera.x-self.xOff + (i*28), camera.y-self.yOff+6)
  end

end

function Inventory:addItem(item)

  table.insert(self.items, item)

end

function Inventory:toggle()
  if self.active == true then
    self.active = false
  else
    self.active = true
  end
end
