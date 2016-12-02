
Ball = class('Ball')

function Ball:initialize()
  self.x = player.x + player.width/2
  self.y = 500
  self.speed = 30
  self.xVel = 0
  self.yVel = 0
  self.radius = 6
  world:add(self, self.x, self.y, self.radius, self.radius)

  self.trail = trail:new({
    type = "point",
    content = {
      type = "circle",
      radius = self.radius/1.2
    },
    fade = "shrink",
    duration = 0.8
  })

end

function Ball:reset()
  self.x = player.x + player.width/2
  self.y = player.y - 50
  self.y = 500
  world:update(self, self.x, self.y)
  self.xVel = player.xVel
  self.yVel = 0
end


function Ball:start()
  self.yVel = -10
end

ballFilter = function(item, other)
  if other.type == "wallRight" then
    return 'bounce'
  else
    return 'bounce'
  end
end

function Ball:update(dt)
  if (gamestate.waitingToStart) then
    self:reset()
  end


  local goalX, goalY = self.x + self.xVel*self.speed*dt, self.y + self.yVel*self.speed*dt
  local actualX, actualY, cols, len = world:move(self, goalX, goalY)
  self.x, self.y = actualX, actualY

  for i=1,len do
    local col = cols[i]
    self:handleCollision(col)
  end

  if self.y > windowH then
    ballOOB_sound:play()
    self:reset()
    gamestate.waitingToStart = true
  end

  self.trail:setPosition(self.x, self.y)
  self.trail:update(dt)
end


function Ball:draw()
  love.graphics.setColor(Colors.yellow)
  love.graphics.circle("fill", self.x, self.y, self.radius)

  self.trail:draw()
end

--== Collision Handling
--== All Basic normal vector 'inversions'
--== Player can influence the ball's xVelocity
function Ball:handleCollision(col)
  if col.other.isEmpty then return end

    if col.other.type == 'block' then
      local block = col.other
      block:hit()
    end

    if col.normal.x ~= 0 then
      self.xVel = -1 * self.xVel
    end

    if col.normal.y ~= 0 then
      self.yVel = -1 * self.yVel
    end

    if col.other.type == 'player' then
      envhit_sound:play(true)
      local player = col.other
      local playerMiddle = player.x + player.width/2
      local diff =  self.x - playerMiddle
      -- Player can influence the ball-reflection based on where
      -- the ball hits the paddle, and how fast the paddle is going
      self.xVel = self.xVel + diff/7
      -- self.xVel = self.xVel + player.xVel/10
    end

    if col.other.type == 'wall' then
      envhit_sound:play(true)
    end
end
