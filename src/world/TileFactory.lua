require "src.world.gameobjects.Tile"

TileFactory = class('TileFactory')


function TileFactory:initialize()

end

function TileFactory.makeTile(x, y, tileType, location)
    local tile = Tile(x, y, tileType, location)
    return tile
end
