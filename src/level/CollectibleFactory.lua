require "src.level.collectibles.Pistol"
require "src.level.collectibles.Stone"

CollectibleFactory = class('CollectibleFactory')


function CollectibleFactory:initialize()

end

function CollectibleFactory.makeCollectible(x, y, type)

  if type == 8 then
    collectible = Stone(x,y)
  elseif type == 4 then
    collectible = Pistol(x,y)
  end

  return collectible
end
