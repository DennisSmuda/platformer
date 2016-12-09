
Tile = class('Tile')

function Tile:initialize(x,y, type)
  self.WorldCoords = {x = x, y = y}
  self.x = x*16
  self.y = y*16
  self.width = 16
  self.height = 15
  self.type = type

  --== Check validity and set variables accordingly
  if self.type then
    if self.type > 0 then
      world:add(self, self.x, self.y, self.width, self.height)
      self.isPlatform = true
    end

    if self.type == 1 then
      self.image = blockQuad
    elseif self.type == 2 then
      self.image = grassQuad
    end
  end



end

function Tile:draw ()

  if self.type > 0 then
    love.graphics.draw(tileset, self.image, self.x, self.y)
  end

end
