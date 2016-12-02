
Wall = class('Wall')

function Wall:initialize(x, y, w, h)
  self.type = 'wall'
  world:add(self, x, y, w, h)
end
