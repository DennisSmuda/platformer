require "src.world.player.Inventory"

Player = class('Player')

function Player:initialize()
  self.isPlayer = true
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

  --== Gameplay
  self.inventory = Inventory()


  world:add(self, self.x, self.y, self.width, self.height)
end


function Player:update(dt)
  self:handleInput(dt)
  self:move(dt)
  self:checkSurroundingsForFragments(dt)

  walkingLeft:update(dt)
  walkingRight:update(dt)
  idleLeft:update(dt)
  idleRight:update(dt)
  jumpLeft:update(dt)
  jumpRight:update(dt)
  wallSlideLeft:update(dt)
  wallSlideRight:update(dt)


end

function Player:checkSurroundingsForFragments()

  local x,y,w,h = world:getRect(self)
  -- print("Player Feel: " .. self.x .. ':' .. self.y .. '::' .. x .. ':' .. y)
  local items, len = world:queryRect(self.x-4, self.y-4, 16, 16)
  -- local items, len = world:getItems()

  for i=1,len do
    if items[i].isFragment == true then
      local x,y,w,h = world:getRect(items[i])

      print(i .. ': Fragment : ' .. x .. ' : ' .. y .. ': :' .. w .. ':' .. h)
    end
  end

end



function Player:draw()
  self.inventory:draw()
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
  if other.isPlatform then return 'slide'
  elseif other.isFragment then return 'cross'
  elseif other.isPortal then return 'cross'
  elseif other.isBullet then
    print("Player hit Bullet")
     return 'cross'
  elseif other.isCollectible then return 'cross'
  else
    return 'slide'
  end
end


function Player:move(dt)
  local goalX, goalY = self.x + self.xVel, self.y + self.yVel
  local actualX, actualY, cols, len = world:move(self, goalX, goalY,playerFilter)


  self.x, self.y = actualX, actualY
  world:update(self, self.x, self.y)
  local isTouchingCollectible = false
  local isTouchingPortal      = false


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

    elseif other.isPortal then
      isTouchingPortal = true
      other:toggleMessage(true)
      other:update(dt)

    end

  end


  if isTouchingCollectible == false then
    level:resetCollectibleMessages()
  end

  if isTouchingPortal == false then
    level:resetStaticMessages()
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
    --== Apply regular gravity while midair
    self.yVel = self.yVel + self.gravity*dt
  end
  -- Limit gravity
  if self.yVel > self.gravity then self.yVel = self.gravity end


  if self.grounded then
    self.isOnWall = false
  end

  --== Stop Running animation a short time before
  --== the character actually stops moving
  if self.xVel < 0.4 and self.xVel > -0.4 then
    self.moving = false
  else
    self.moving = true
  end

  --== No Collisions -> reset wall/grounded variables
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

end


function Player:handleInput(dt)
  local now = love.timer.getTime()
  if love.keyboard.isDown("space") then
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

  end


  if love.keyboard.isDown("d") then
    self.direction = 'right'
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


-- function Player:activeItem
