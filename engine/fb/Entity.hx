package fb;

import ldtk.Layer_Tiles;

class Entity {
    public var layer:Layer_Tiles;

    public var gridX:Int;
    public var gridY:Int;

    public var gridRatioX:Float;
    public var gridRatioY:Float;

    public var velocityX:Float;
    public var velocityY:Float;

    public var frictionX:Float = 0.98;
    public var frictionY:Float = 0.98;

    public var positionX:Float;
    public var positionY:Float;

    public var length:Int = 1;
    public var radius:Float = 4;
    public var pushForce = 0.3;

    public var isColliding = false;
    public var isCollidingEn = false;
    public var isCollidingTop = false;
    public var isCollidingBottom = false;
    public var isCollidingLeft = false;
    public var isCollidingRight = false;

    public static var ALL:Array<Entity> = [];

    public function new(x:Int, y:Int, layer:Layer_Tiles) {
        this.layer = layer;
        setCoords(x, y);
        ALL.push(this);
        init();
    }

    public function init() {}
    public function draw() {}
    public function destroy() {
        ALL.remove(this);
    }

    public function update() {
    }

    public function updtPhys() {
        gridRatioX += velocityX;
        velocityX *= frictionX;

        for(i in 0...length) {
            if (layer.isCoordValid(gridX + 1, gridY + i) && layer.hasAnyTileAt(gridX + 1, gridY + i) && gridRatioX >= 0) {
                gridRatioX = 0;
                velocityX = 0;
                isColliding = true;
                isCollidingRight = true;
            } else {
                isCollidingRight = false;
                isColliding = false;
            }

            if (layer.isCoordValid(gridX - 1, gridY + i) && layer.hasAnyTileAt(gridX - 1, gridY + i) && gridRatioX <= 0) {
                gridRatioX = 0;
                velocityX = 0;
                isColliding = true;
                isCollidingLeft = true;
            } else {
                isColliding = false;
                isCollidingLeft = false;
            }
        }

        while (gridRatioX > 1) {
            gridRatioX = 0;
            gridX++;
        }
        while (gridRatioX < 0) {
            gridRatioX = 1;
            gridX--;
        }

        gridRatioY += velocityY;
        velocityY *= frictionY;

        for(i in 1...length+1) {
            if (layer.isCoordValid(gridX, gridY - i) && layer.hasAnyTileAt(gridX, gridY - i) && gridRatioY <= 0) {
                gridRatioY = 0;
                velocityY = 0;
                isColliding = true;
                isCollidingTop = true;
            } else {
                isColliding = false;
                isCollidingTop = false;
            }

            if (layer.isCoordValid(gridX, gridY + i) && layer.hasAnyTileAt(gridX, gridY + i) && gridRatioY >= 0) {
                gridRatioY = 0;
                velocityY = 0;
                isColliding = true;
                isCollidingBottom = true;
            } else {
                isColliding = false;
                isCollidingBottom = false;
            }
        }

        while (gridRatioY > 1) {
            gridRatioY = 0;
            gridY++;
        }
        while (gridRatioY < 0) {
            gridRatioY = 1;
            gridY--;
        }

        positionX = (gridX + gridRatioX) * layer.gridSize;
        positionY = (gridY + gridRatioY) * layer.gridSize;
    }

    public function setCoords(x:Float, y:Float) {
        positionX = x;
        positionY = y;
        gridX = Std.int(x / layer.gridSize);
        gridY = Std.int(y / layer.gridSize);
        gridRatioX = (x - gridX * layer.gridSize) / layer.gridSize;
        gridRatioY = (y - gridY * layer.gridSize) / layer.gridSize;
    }


    public function resolveCollision() {
        for (e in ALL) {
            if (e != this && Math.abs(gridX - e.gridX) <= 2 && Math.abs(gridY - e.gridY) <= 2) {
                var dist = Math.sqrt((e.positionX - positionX) * (e.positionX - positionX) + (e.positionY - positionY) * (e.positionY - positionY));
                if (dist <= radius + e.radius) {
                    var ang = Math.atan2(e.positionY - positionY, e.positionX - positionX);
                    var force = pushForce;
                    var repelPower = (radius + e.radius - dist) / (radius + e.radius);
                    velocityX -= Math.cos(ang) * repelPower * force;
                    velocityY -= Math.sin(ang) * repelPower * force;
                    e.velocityX += Math.cos(ang) * repelPower * force;
                    e.velocityY += Math.sin(ang) * repelPower * force;
                    isCollidingEn = true;
                } else {
                    isCollidingEn = false;
                }
            }
        }
    }

    public inline function overlapsEntity(e:Entity):Bool {
        var maxDist = radius + e.radius;
        var distSqr = (e.positionX - positionX) * (e.positionX - positionX) + (e.positionY - positionY) * (e.positionY - positionY);
        return distSqr <= maxDist * maxDist;
    }
}
