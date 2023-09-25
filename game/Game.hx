import fb.Camera;
import fb.App;
import en.Dummy;
import Rl.Camera2D;
import en.Hero;
import fb.Aseprite;
import fb.ldtk.LevelRenderer;
import fb.Process;

class Game implements Process {
    var tilemap:Aseprite;

    var world:WorldMap;
    var level:WorldMap.WorldMap_Level;

    var hero:Hero;
    var camera:Camera;

    var dummy:Array<Dummy> = [];

    public function new() {
        tilemap = new Aseprite(0, 0, "assets/tileset.ase");

        world = new WorldMap(sys.io.File.getContent("assets/data/world.ldtk"));
        level = world.all_levels.Level_0;

        var hero_en = level.l_En.all_Hero[0];
        hero = new Hero(hero_en.pixelX, hero_en.pixelY, level.l_Fg);
        camera = new Camera(Rl.Vector2.create(App.cfg.gameWidth / 2, App.cfg.gameHeight / 2), Rl.Vector2.create(hero.positionX, hero.positionY));

        var dummy_en = level.l_En.all_Dummy;
        // for(d in dummy_en) dummy.push(new Dummy(d.pixelX, d.pixelY, level.l_Fg));
    }

    public function update() {
        hero.update();
        camera.follow(hero.positionX, hero.positionY);

        for(d in dummy) d.update();
    }

    // TODO: make layer based render system
    public function draw() {
        Rl.beginMode2D(camera.rl);
        hero.draw();
        for(d in dummy) {
            d.draw();
            Rl.drawRectangleRec(d.sightRectangle, Rl.Color.create(255, 0, 0, 155));
        }
        LevelRenderer.drawTilemap(level.l_Fg, tilemap, world.all_tilesets.Tileset, 8);
        Rl.endMode2D();
    }

    public function destroy() {
        hero.destroy();
        for(d in dummy) d.destroy();
        tilemap.unload();
    }
}