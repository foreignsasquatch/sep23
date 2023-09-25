package fb;

import Rl.Vector2;
import Rl.Camera2D;

class Camera {
    public var targetX:Float = 0;
    public var targetY:Float = 0;
    public var offsetX:Float = 0;
    public var offsetY:Float = 0;
    public var deadzoneX:Float = 16;
    public var deadzoneY:Float = 16;
    public var speedX:Float = 2;
    public var speedY:Float = 2;
    public var rl:Camera2D;

    public static var inst:Camera;

    public function new(offset:Vector2, target:Vector2) {
        rl = Camera2D.create(offset, target);
        inst = this;
    }

    public function follow(x:Float, y:Float) {
        targetX = x;
        targetY = y;

        if((targetX - rl.target.x) > deadzoneX)
            rl.target.x = rl.target.x + speedX;
        if((targetX - rl.target.x) < -deadzoneX)
            rl.target.x = rl.target.x - speedX;

        if((targetY - rl.target.y) > deadzoneY)
            rl.target.y = rl.target.y + speedY;
        if((targetY - rl.target.y) < -deadzoneY)
            rl.target.y = rl.target.y - speedY;
    }

    public static function distance(v:Vector2, v1:Vector2):Float {
        return Math.sqrt(((v1.x - v.x) * (v1.x - v.x)) + ((v1.y - v.y) * (v1.y - v.y)));
    }

    // move to somewhere else later
    public static inline function lerp(a:Float, b:Float, t:Float):Float {
        return a + (b - a) * t;
    }
}