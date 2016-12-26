
Bat = class('Bat')

function Bat:initialize(x, y)
  self.x = x
  self.y = y

  print(self.x .. ':' .. self.y)

  self.width = 4
  self.height = 10
  self.xOff = 2
  self.yOff = 2
  self.health = 5
  self.direction = 'left'

  self.isEnemy = true
  world:add(self, self.x+self.xOff, self.y+self.yOff, self.width, self.height)

end


function Bat:update(dt)
  batRight:update(dt)
  batLeft:update(dt)

end

function Bat:draw()
  if self.health > 0 then

    if self.direction == 'left' then
      batRight:draw(batset, self.x, self.y)
    elseif self.direction == 'right' then
      batLeft:draw(batset, self.x, self.y)
    end

  end


end


function Bat:takeDamage(value)
  self.health = self.health - value

  if self.health <= 0 then
    -- level:spawnFragments(self.x, self.y, self.type, self.fragments, self.oreType)
    world:remove(self)
  end
end
