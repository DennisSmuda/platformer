
Bat = class('Bat')

function Bat:initialize(x, y)
  self.x = player.x + 23
  self.y = player.y

end


function Bat:update(dt)
end

function Bat:draw()
  batRight:draw(batset, self.x, self.y)

end
