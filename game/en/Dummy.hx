package en;

import Rl.Rectangle;
import fb.Aseprite;
import fb.Entity;

class Dummy extends Entity {
    public var speed = 0.08;    
    public var gravity = 0.03;
    public var sightRectangle:Rectangle;
    public var sightLength = 3;
    
    var sprite:Aseprite;

    override function init() {
        frictionX = 0.8;
        sprite = new Aseprite(0, 0, "assets/basic.ase");

        sightRectangle = Rectangle.create(positionX, positionY, 8 * sightLength * sprite.direction, 8);
    }

    var dir = 0;
    override function update() {
        resolveCollision();
        if(!isCollidingBottom) velocityY += gravity;

        // basic movement logic for now (just testing)
        if(!isColliding && layer.hasAnyTileAt(gridX + (1 * sprite.direction), gridY + 1)) velocityX = speed * sprite.direction;
        else velocityX = speed * -sprite.direction;

        updtPhys();
        sprite.x = positionX;
        sprite.y = positionY;

        for(i in 0...sightLength) {
            if(layer.hasAnyTileAt(gridX + sightLength, gridY)) {
                if(i != 0) sightLength = i - 1;
                else sightLength = 0;
            }
        }

        sightRectangle.x = positionX;
        sightRectangle.y = positionY;
        sightRectangle.width = 8 * sightLength * sprite.direction;
    }

    override function draw() {
        sprite.draw();
    }

    override function destroy() {
        sprite.unload();
    }
}