require "src.level.gameobjects.Tile"

TileFactory = class('TileFactory')


function TileFactory:initialize()

end

function TileFactory.makeTile(x, y, tileType)
    local tile = Tile(x, y, tileType)
    return tile
end
