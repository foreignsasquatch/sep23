package fb;

import Rl.Camera2D;
import sys.io.File;
import cpp.vm.Profiler;
import cpp.ConstCharStar;
import cpp.Callable;
import Rl.Vector2;
import Rl.Rectangle;
import Rl.RenderTexture;

typedef Cfg = {
    windowWidth:Int,
    windowHeight:Int,
    gameWidth:Int,
    gameHeight:Int,
    title:String
}

class App {
    public static var cfg:Cfg;
    public static var process:Process;

    static var vRatio:Float;
    public static var target:RenderTexture;
    static var sourceRec:Rectangle;
    static var destRec:Rectangle;

    static var timeCounter = 0.0;
    static var timeStep = 1 / 60;

    static var screenSpaceCamera:Camera2D;

    public function new(c:String, p:Class<Process>, targetFps:Int = 60) {
        App.cfg = parse(c);
        vRatio = cfg.windowWidth / cfg.gameWidth;

        Profiler.start("profiler.out");
        var t:String = cast cfg.title; // becsause of hxcpp madness it wont compile without being separate
        Rl.initWindow(cfg.windowWidth, cfg.windowHeight, ConstCharStar.fromString(t));
        #if emscripten 
        Rl.setTargetFPS(63);
        #else
        Rl.setTargetFPS(60);
        #end
        Rl.setExitKey(Rl.Keys.NULL);

        screenSpaceCamera = Camera2D.create(Rl.Vector2.zero(), Rl.Vector2.zero());

        target = Rl.loadRenderTexture(cfg.gameWidth, cfg.gameHeight);
        sourceRec = Rectangle.create(0, 0, cfg.gameWidth, -cfg.gameHeight);
        destRec = Rectangle.create(-vRatio, -vRatio, cfg.windowWidth + (vRatio * 2), cfg.windowHeight + (vRatio * 2));

        App.process = Type.createInstance(p, []);

        #if emscripten
        emscripten.Emscripten.setMainLoop(Callable.fromStaticFunction(update), 70, 1);
        #else
        while(!Rl.windowShouldClose()) {
            update();
        }
        #end

        Rl.unloadRenderTexture(target);

        App.process.destroy();
        Rl.closeWindow();
        Profiler.stop();
    }

    static function update() {
        timeCounter += Rl.getFrameTime(); 
        while(timeCounter > timeStep) {
            App.process.update();
            timeCounter -= timeStep;
        }

        screenSpaceCamera.target.x = Camera.inst.targetX;

        Camera.inst.rl.target.x = Std.int(screenSpaceCamera.target.x);
        screenSpaceCamera.target.x = screenSpaceCamera.target.x - Camera.inst.rl.target.x;
        screenSpaceCamera.target.x *= vRatio;

        Rl.beginTextureMode(target);
        Rl.clearBackground(Rl.Colors.GRAY);
        App.process.draw();
        Rl.endTextureMode();

        Rl.beginDrawing();
        Rl.clearBackground(Rl.Colors.BLACK);
        Rl.beginMode2D(screenSpaceCamera);
        Rl.drawTexturePro(target.texture, sourceRec, destRec, Vector2.zero(), 0, Rl.Colors.WHITE);
        Rl.endMode2D();
        Rl.drawFPS(0, 0);
        Rl.endDrawing();
    }

    public static function parse(s:String):Cfg {
#if emscripten
        var f = haxe.Resource.getString("cfgfile");
#else
        var f = File.getContent(s);
#end
        var lines = f.split("\n");
        var values:Map<String, Dynamic> = [];
        for(l in lines) {
            var line = StringTools.trim(l);
            var name = line.split(":")[0];
            var value = line.split(":")[1];
            if(StringTools.contains(value, '"')) {
                values.set(name, StringTools.replace(value, '"', ""));
            } else {
                values.set(name, Std.parseInt(value));
            }
        }
        var cfg:Cfg = {
            windowWidth: values["windowWidth"],
            windowHeight: values["windowHeight"],
            gameWidth: values["gameWidth"],
            gameHeight: values["gameHeight"],
            title: values["title"],
        }
        trace(cfg);
        return cfg;
    }

    public static function change(s:Class<Process>) {
        App.process = null;
        App.process = Type.createInstance(s, []);
    }
}
