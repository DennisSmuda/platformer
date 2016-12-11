
Ladder = class('Ladder')

function Ladder:initialize(x, y)
  self.x = x * 16
  self.y = y * 16
  self.image = ladderQuad
end

function Ladder:update(dt)
end

function Ladder:draw()
  love.graphics.draw(tileset, ladderQuad, self.x, self.y)
end
