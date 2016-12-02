
GameBackdrop = class('GameBackdrop')


function GameBackdrop:initialize()

  self.particles = {}
  self.size = 150
  self.speed = 10
  windowW, windowH = love.graphics.getDimensions()

  for i=1,self.size do
    -- body...
    self.particles[i] = {
      x = love.math.random(1, windowW),
      y = love.math.random(1, windowH),
    }
  end

end


function GameBackdrop:update(dt)

  local offset = (player.x - windowW/2) / 10
  for i,p in ipairs(self.particles) do
    p.x = p.x + offset * dt
    p.y = p.y + self.speed * dt

    if p.x > windowW then
      p.x = 0
    end
    if p.x < 0 then
      p.x = windowW
    end
    if p.y > windowH then
      p.y = -1
      p.x = love.math.random(1, windowW)
    end
  end

end


function GameBackdrop:draw()
  love.graphics.setColor(Colors.orange)

  for i,p in ipairs(self.particles) do
    love.graphics.circle("fill", p.x, p.y, 1)
  end

end
