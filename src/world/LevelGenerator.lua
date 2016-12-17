
LevelGenerator = class('LevelGenerator')

function LevelGenerator:initialize()

end

function LevelGenerator.generateCaves(width, height)
  local len = width * height
  local mapData = {}

  -- for i=1,len do
  --   table.insert
  -- end

  return {
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
    3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
    3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
    3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
    3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
    3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
    3, 0, 0, 0, 0, 0, 0, 0, 0, 3,
    3, 0, 5, 0, 4, 0, 0, 6, 0, 3,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3
  }


end
