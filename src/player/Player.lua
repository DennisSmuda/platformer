
Player = class('Player')

function Player:initialize()
  self.type = 'player'
  self.width = 12
  self.height = 12
  self.x = gamestate.spawnLocation.x * 16
  self.y = gamestate.spawnLocation.y * 16
  self.xVel = 0
  self.yVel = 0
  self.speed = 20
  self.jumpForce = 3
  self.friction = 10
  self.gravity = 9.81
  self.mass = 10
  --== Movement
  self.direction      = 'right'
  self.moving         = false;
  self.grounded       = false;
  self.timeJumped     = 0
  self.jumpDelay      = 0.4
  self.isOnLeftWall   = false;
  self.isOnRightWall  = false;
  self.wallHitTime    = 0
  self.wallJumpDelay  = 0.25


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
      --== Player is either on a wall or midair
      if self.isOnLeftWall then
        wallSlideLeft:draw(playerset, self.x, self.y)
      elseif self.isOnRightWall == true then
        wallSlideRight:draw(playerset, self.x, self.y)
      elseif self.direction == 'right' then
        jumpRight:draw(playerset, self.x, self.y)
      else
        jumpLeft:draw(playerset, self.x, self.y)
      end

    elseif self.moving then
      --== Player is walkink
      if self.direction == 'right' then
        walkingRight:draw(playerset, self.x, self.y)
      else
        walkingLeft:draw(playerset, self.x, self.y)
      end

    else
      --== Player is idle
      if self.direction == 'right' then
        idleRight:draw(playerset, self.x, self.y)
      else
        idleLeft:draw(playerset, self.x, self.y)
      end
    end

end

playerFilter = function(item, other)
  if other.isPlatform then return 'slide' end
  if other.isCollectible then return 'cross' end
  return 'slide'
end


function Player:move(dt)
  local goalX, goalY = self.x + self.xVel, self.y + self.yVel
  local actualX, actualY, cols, len = world:move(self, goalX, goalY,playerFilter)


  self.x, self.y = actualX, actualY
  world:update(self, self.x, self.y)
  local isTouchingCollectible = false


  for i=1, len do
    local other = cols[i].other
    local normal = cols[i].normal
    if other.isPlatform then

      --== Player is touching platform from the top
      if normal.y == -1 then
        player.grounded = true
      end


      if normal.x == -1 then
        self.isOnRightWall = true

        if self.wallHitTime == nil then
          self.wallHitTime = love.timer.getTime()
        end
      else
        self.isOnRightWall = false
      end


      if normal.x == 1 then
        self.isOnLeftWall = true

        if self.wallHitTime == nil then
          self.wallHitTime = love.timer.getTime()
        end
      else
        self.isOnLeftWall = false
      end
    --== Collectibles (Guns, Stones..)
    elseif other.isCollectible then
      other:toggleMessage(true)
      isTouchingCollectible = true
    end

  end


  if isTouchingCollectible == false then
    level:resetMessages()

  end



  --== Apply Friction
  self.xVel = self.xVel * (1 - math.min(dt*self.friction, 1))
  --== Lower Gravity is applied when on Wall
  --== If Player moves 'against the wall' while on it, he
  --== can control the downslide
  if self.isOnLeftWall == true then
    if love.keyboard.isDown('a') then
      self.yVel = self.yVel * (1 - math.min(dt*self.friction, 1))
    else
      self.yVel = self.yVel + self.gravity*dt/1.5
    end
  elseif self.isOnRightWall == true then
    if love.keyboard.isDown('d') then
      self.yVel = self.yVel * (1 - math.min(dt*self.friction, 1))
    else
      self.yVel = self.yVel + self.gravity*dt/1.5
    end
  else
    self.yVel = self.yVel + self.gravity*dt
  end
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

  --== No Collisions -> reset wall/grounded
  if len == 0 then
    self.isOnWall = false
    self.isOnLeftWall = false
    self.isOnRightWall = false
    self.wallHitTime = nil

    if self.grounded then
      self.grounded = false
      self.yVel = 0.125
    end
  end
  -- print(love.timer.getTime() .. tostring(self.isOnRightWall))


end



function Player:handleInput(dt)
  if love.keyboard.isDown("space") then
    local now = love.timer.getTime()
    local canJump = now - self.timeJumped > self.jumpDelay

    if canJump and self.grounded == true then
      -- print("Jump")
      self.yVel =  -self.jumpForce
      -- self.yVel = -3
      self.grounded = false
      self.timeJumped = now
    end

    if canJump then
      self.timeJumped = now
      if self.isOnRightWall == true then
        self.isOnRightWall = false
        self.direction = 'left'
        self.xVel = -self.jumpForce
        self.yVel = -self.jumpForce
      elseif self.isOnLeftWall == true then
        self.isOnRightWall = false
        self.direction = 'left'
        self.xVel = self.jumpForce
        self.yVel = -self.jumpForce
      end
    end

  end

  local now = love.timer.getTime()

  if love.keyboard.isDown("a") then

    if self.direction ~= 'left' then
      self.direction = 'left'
    end
    self.xVel = self.xVel - self.speed*dt

    if self.isOnRightWall == true then
      local canWallJump = now - self.wallHitTime > self.wallJumpDelay

      if canWallJump == false then
        self.direction = 'right'
        self.xVel = self.xVel + self.speed*dt
      end
    end
    -- self.xVel = self.xVel - self.speed*dt

  end


  if love.keyboard.isDown("d") then
    if self.direction ~= 'right' then
      self.direction = 'right'
    end
    self.xVel = self.xVel + self.speed*dt

    if self.isOnLeftWall == true then
      local canWallJump = now - self.wallHitTime > self.wallJumpDelay

      if canWallJump == false then
        self.direction = 'left'
        self.xVel = self.xVel - self.speed*dt
      end

    end
  end


  if love.keyboard.isDown("left") then
    self.direction = 'left'
  end

  if love.keyboard.isDown("right") then
    self.direction = 'right'
  end
end
