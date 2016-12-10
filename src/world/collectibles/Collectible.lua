local collectibles = require "src.config.collectibles"

Collectible = class('Collectible')

function Collectible:initialize(x, y, type)
  self.x = x*16
  self.y = y*16
  self.xOff = collectibles[type].xOff
  self.yOff = collectibles[type].yOff
  self.width = collectibles[type].width
  self.height = collectibles[type].height
  self.image  = collectibles[type].image

  self.owner = nil
  self.showMessage = false

  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)
  self.isCollectible = true

end

function Collectible:update(dt)
  if self.showMessage then
    self:handleInput(dt)
  end
end

function Collectible:draw()
  love.graphics.draw(self.img, self.x+self.xOff, self.y+self.yOff)
end

function Collectible:toggleMessage(value)
  self.showMessage = value
end

function Collectible:handleInput(dt)
  if love.keyboard.isDown("e") and self.owner == nil then
    self.owner = player
  end

  if love.keyboard.isDown("q") and self.owner then
    self.owner = nil
  end
end
