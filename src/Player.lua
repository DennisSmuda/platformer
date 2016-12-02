
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
  self.friction = 5
  self.gravity = 9.81
  --== Movement
  self.direction = 'right'
  self.moving    = false;
  self.grounded  = false;


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
  if other.isPlatform then return 'touch' end
  return 'touch'
end


function Player:move(dt)
  local goalX, goalY = self.x + self.xVel, self.y + self.yVel
  local actualX, actualY, cols, len = world:move(player, goalX, goalY, playerFilter)


  player.x, player.y = actualX, actualY
  world:update(self, self.x, self.y)

  if #cols > 0 then
    print("logging" .. len)
    print(cols.isPlatform)
  end


  --== Apply Friction
  self.xVel = self.xVel * (1 - math.min(dt*self.friction, 1))
  self.yVel = self.yVel + self.gravity*dt



  --== Stop Animation a short time before actual stop
  if self.xVel < 0.4 and self.xVel > -0.4 then
    self.moving = false
  else
    self.moving = true
  end

end



function Player:handleInput(dt)
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
