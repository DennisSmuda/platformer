
GameOverlay = class('GameOverlay')

function GameOverlay:initialize()
  self.startMsg = { x = 0, y = 0, text = 'Space to Start'}
  self.ui = { y = -50}
  self.startTween = tween.new(2, self.startMsg, {y=windowH/2}, 'outExpo')
  self.uiTween    = tween.new(6, self.ui, {y=10}, 'outExpo')


end

function GameOverlay:update(dt)
  self.startTween:update(dt)
  self.uiTween:update(dt)

end

function GameOverlay:draw()
  love.graphics.setColor(Colors.white)
  love.graphics.print('Points: ' .. gamestate.points, 10, self.ui.y)
  love.graphics.printf('Level: ' .. gamestate.currentLevel, 0, self.ui.y, 1000-10, 'right')
  love.graphics.printf('Lives: ' .. gamestate.lives, 0, self.ui.y, 1000, 'center')

  if gamestate.waitingToStart then
    love.graphics.printf(self.startMsg.text, 0, self.startMsg.y, 1000, 'center')
  end
end
