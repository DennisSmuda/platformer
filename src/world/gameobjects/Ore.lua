require "src.world.gameobjects.Fragment"

Ore = class('Ore', Fragment)

function Ore:initialize(x, y, type)
  Fragment.initialize(self, x, y)
  self.x = x+8
  self.y = y+8
  self.width = 3
  self.height = 3
  self.type = type
  self.img = nil

  if self.type == 'stone' then
    self.img = stoneOre_img
    self.name = 'Stone'
  elseif self.type == 'iron' then
    self.img = ironOre_img
    self.name = 'Iron Ore'
  elseif self.type == 'copper' then
    self.img = copperOre_img
    self.name = 'Copper Ore'
  elseif self.type == 'silver' then
    self.img = silverOre_img
    self.name = 'Silver Ore'
  elseif self.type == 'gold' then
    self.img = goldOre_img
    self.name = 'Gold Ore'
  end


  world:add(self, self.x, self.y, self.width, self.height)
end


function Ore:draw()
  love.graphics.draw(self.img, self.x, self.y)
end
