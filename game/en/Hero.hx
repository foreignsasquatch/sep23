package en;

import fb.Aseprite;
import fb.Entity;

class Hero extends Entity {
    public var speed = 0.15;
    
    public var gravity = 0.03;
    public var jumpStrength = 0.5;

    public var sprite:Aseprite;

    override function init() {
        sprite = new Aseprite(0, 0, "assets/buninja.ase");
        frictionX = 0.8;

        trace(sprite.tags["Run"].endFrame);
    }

    override function update() {
        resolveCollision();
        if(!isCollidingBottom) velocityY += gravity;

        if(Rl.isKeyDown(Rl.Keys.D)) {
            velocityX = speed;

            sprite.playingAnim = true;
            if(isCollidingBottom) sprite.play("Run", true);
            sprite.direction = 1;
        }
        else if(Rl.isKeyDown(Rl.Keys.A)) {
            velocityX = -speed;
            
            sprite.playingAnim = true;
            if(isCollidingBottom) sprite.play("Run", true);
            sprite.direction = -1;
        } else {
            sprite.playingAnim = false;
            sprite.currentFrame = 0;
        }

        if(Rl.isKeyDown(Rl.Keys.SPACE) && isCollidingBottom) {
            velocityY = -jumpStrength;
        }

        updtPhys();
        sprite.x = Std.int(positionX);
        sprite.y = Std.int(positionY);
    }

    override function draw() {
        sprite.draw();
    }

    override function destroy() {
        sprite.unload();
    }
}