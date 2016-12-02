
Player = class('Player')

function Player:initialize()
  self.type = 'player'
  self.width = 16
  self.height = 16
  self.x = 60
  self.y = 86
  self.xVel = 0
  self.yVel = 0
  self.speed = 20
  self.jumpForce = 200
  self.friction = 10
  self.gravity = 9.81
  --== Movement
  self.direction = 'right'
  self.moving    = false;
  self.grounded  = false;
  self.timeJumped = 0
  self.jumpDelay = 0.4


  world:add(self, self.x, self.y, self.width, self.height)
end


function Player:update(dt)
  self:handleInput(dt)
  self:move(dt)

  walkingAnim:update(dt)
  idleAnim:update(dt)

end


function Player:draw()

    if self.moving then
      walkingAnim:draw(playerset, self.x, self.y)
    else
      idleAnim:draw(playerset, self.x, self.y)
    end

end

playerFilter = function(item, other)
  if other.isPlatform then return 'slide' end
  return 'slide'
end


function Player:move(dt)
  local goalX, goalY = self.x + self.xVel, self.y + self.yVel
  local actualX, actualY, cols, len = world:move(player, goalX, goalY)


  player.x, player.y = actualX, actualY
  world:update(self, self.x, self.y)
  print(len)

  for i=1, len do
    local other = cols[i].other
    local normal = cols[i].normal
    if other.isPlatform then

      print("normal: " .. normal.x .. normal.y)
      --== Player is touching platform from the top
      if normal.y == -1 then
        player.grounded = true
      end
    end

  end



  --== Apply Friction / Gravity
  self.xVel = self.xVel * (1 - math.min(dt*self.friction, 1))
  self.yVel = self.yVel + self.gravity*dt

  -- print(self.yVel)

  if self.grounded then
    self.yVel = self.gravity
  end


  --== Stop Animation a short time before actual stop
  if self.xVel < 0.4 and self.xVel > -0.4 then
    self.moving = false
  else
    self.moving = true
  end

end



function Player:handleInput(dt)
  if love.keyboard.isDown("space") or love.keyboard.isDown("w") then
    local now = love.timer.getTime()
    if now - self.timeJumped > self.jumpDelay then
      print("Jump")
      self.grounded = false
      self.yVel =  -self.jumpForce*dt
      self.timeJumped = now
    end
  end
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    if self.direction ~= 'left' then
      self.direction = 'left'
      walkingAnim:flipH()
      idleAnim:flipH()
    end
    self.xVel = self.xVel - self.speed*dt
  end


  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    if self.direction ~= 'right' then
      self.direction = 'right'
      walkingAnim:flipH()
      idleAnim:flipH()
    end
    self.xVel = self.xVel + self.speed*dt
  end
end
