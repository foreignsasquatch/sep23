package fb.ldtk;

class LevelRenderer {
    public static inline function drawTilemap(layer:ldtk.Layer_Tiles, tilesetTexture:Aseprite, tileset:ldtk.Tileset, tileSize:Int):Void {
        for(r in 0...layer.cHei) {
            for(c in 0...layer.cWid) {
                if(layer.hasAnyTileAt(c, r)) {
                    var tileAtMapPos = layer.getTileStackAt(c, r);
                    var tilesToDraw = tileAtMapPos[0];
                    var x = c * tileSize;
                    var y = r * tileSize;

                    Rl.drawTextureRec(tilesetTexture.spritesheet, Rl.Rectangle.create(tileset.getAtlasX(tilesToDraw.tileId), tileset.getAtlasY(tilesToDraw.tileId), tileSize, tileSize), Rl.Vector2.create(x, y), Rl.Colors.WHITE);
                }
            }
        }
    }
}
