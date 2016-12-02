--==============0
--== Formula
--== 100 * i, 50 + 35 * i

LevelManager = class('LevelManager')

function LevelManager:initialize()
  self.blockPositions = {x=-windowW*2, y=0}
  self.blockTween = tween.new(1, self.blockPositions, {x=0}, 'outExpo')

end


function LevelManager:update(dt)
  local complete = self.blockTween:update(dt)

  if complete == false then
    for i,block in ipairs(blocks) do
      local x = i%8+1 -- y position irrelevant
      block:moveX((100*x) + self.blockPositions.x)
    end
  end

end

function LevelManager:newLevel()
  self:setupLevel()

  self.blockTween:reset()
end


function LevelManager:setupLevel()
  level = (levels[gamestate.currentLevel])
  for i,row in ipairs(level) do
    for j,bHealth in ipairs(row) do
      -- print("Block: " .. j .. ',' .. i .. ": " .. blocktype)
      if bHealth > 0 then
        local block = Block((100*j)-windowW*2, (50 + 35 * i), bHealth)
        table.insert(blocks, block)
      end
    end
  end
end
