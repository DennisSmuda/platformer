
Player = class('Player')

function Player:initialize()
  self.type = 'player'
  self.width = 12
  self.height = 12
  self.x = 60
  self.y = 30
  self.xVel = 0
  self.yVel = 0
  self.speed = 20
  self.jumpForce = 3
  self.friction = 10
  self.gravity = 9.81
  self.mass = 10
  --== Movement
  self.direction = 'right'
  self.moving    = false;
  self.grounded  = false;
  self.timeJumped = 0
  self.jumpDelay = 0.4
  self.isOnWall  = false;


  world:add(self, self.x, self.y, self.width, self.height)
end


function Player:update(dt)
  self:handleInput(dt)
  self:move(dt)

  walkingLeft:update(dt)
  walkingRight:update(dt)
  idleLeft:update(dt)
  idleRight:update(dt)
  jumpLeft:update(dt)
  jumpRight:update(dt)
  wallSlideLeft:update(dt)
  wallSlideRight:update(dt)

end


function Player:draw()
  -- love.graphics.setColor(255,255,255,255)

    if self.grounded ~= true then

      if self.isOnWall then

        if self.direction == 'right' then
          wallSlideRight:draw(playerset, self.x, self.y)
        else
          wallSlideLeft:draw(playerset, self.x, self.y)
        end

      else
        if self.direction == 'right' then
          jumpRight:draw(playerset, self.x, self.y)
        else
          jumpLeft:draw(playerset, self.x, self.y)
        end
      end

    elseif self.moving then

        if self.direction == 'right' then
          walkingRight:draw(playerset, self.x, self.y)
        else
          walkingLeft:draw(playerset, self.x, self.y)
        end

    else

        if self.direction == 'right' then
          idleRight:draw(playerset, self.x, self.y)
        else
          idleLeft:draw(playerset, self.x, self.y)
        end
    end

end

playerFilter = function(item, other)
  if other.isPlatform then return 'slide' end
  return 'slide'
end


function Player:move(dt)
  local goalX, goalY = self.x + self.xVel, self.y + self.yVel
  local actualX, actualY, cols, len = world:move(player, goalX, goalY)


  self.x, self.y = actualX, actualY
  world:update(self, self.x, self.y)





  for i=1, len do
    local other = cols[i].other
    local normal = cols[i].normal
    if other.isPlatform then

      -- print("normal: " .. normal.x .. normal.y)
      --== Player is touching platform from the top
      if normal.y == -1 then
        player.grounded = true
      end

      if normal.x == -1 then
        -- Is On right wall
        self.isOnWall = true
      end

      if normal.x == 1 then
        self.isOnWall = true
      end
    end

  end



  --== Apply Friction / Gravity
  self.xVel = self.xVel * (1 - math.min(dt*self.friction, 1))
  self.yVel = self.yVel + self.gravity*dt
  -- Limit gravity
  if self.yVel > self.gravity then self.yVel = self.gravity end

  -- print(self.yVel)

  if self.grounded then
    self.isOnWall = false
  end


  --== Stop Animation a short time before actual stop
  if self.xVel < 0.4 and self.xVel > -0.4 then
    self.moving = false
  else
    self.moving = true
  end

  if len == 0 then
    if self.grounded then
      self.grounded = false
      self.yVel = self.gravity/6
      self.yVel = 1
    end
  end

  print(self.yVel)


end



function Player:handleInput(dt)
  if love.keyboard.isDown("space") or love.keyboard.isDown("w") then
    local now = love.timer.getTime()
    local canJump = now - self.timeJumped > self.jumpDelay

    if canJump and self.grounded == true then
      print("Jump")
      self.yVel =  -self.jumpForce
      -- self.yVel = -3
      self.grounded = false
      self.timeJumped = now
    end

    if canJump and self.isOnWall then
      print("Wall Jump")
      self.timeJumped = now
      if self.direction == 'right' then
        self.isOnWall = false
        self.direction = 'left'
        self.xVel = -self.jumpForce
        self.yVel = -self.jumpForce
      else
        self.isOnWall = false
        self.direction = 'left'
        self.xVel = self.jumpForce
        self.yVel = -self.jumpForce
      end
    end
  end
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    if self.direction ~= 'left' then
      self.direction = 'left'
      -- walkingAnim:flipH()
      -- idleAnim:flipH()
      -- jumpAnim:flipH()
    end
    self.xVel = self.xVel - self.speed*dt
  end


  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    if self.direction ~= 'right' then
      self.direction = 'right'
      -- walkingAnim:flipH()
      -- idleAnim:flipH()
      -- jumpAnim:flipH()
    end
    self.xVel = self.xVel + self.speed*dt
  end
end
