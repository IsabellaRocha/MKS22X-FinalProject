abstract class Tile {
    float tilewidth;
    float tileheight;

    float xpos;
    float ypos;

    Tile(float xpos, float ypos) {
        tilewidth = 4;
        tileheight = 4;

        this.xpos = xpos;
        this.ypos = ypos;
    }

    abstract int interact(Player other);
}

class Spike extends Tile {

}

class Ground extends Tile {
    Ground(float xpos, float ypos) {
        super(xpos, ypos);
    }
    int interact(Player other) {
        if (xpos <= other.xpos && xpos + tilewidth >= other.xpos + other.playerwidth) {
            if (ypos == other.ypos - other.playerheight) { // If player is standing on tile
                return 1;
            }
            if (ypos - tileheight == other.ypos) { //If player is hitting tile from bottom
                return 2;
            }
        }
        if (ypos <= other.ypos && ypos + tileheight >= other.ypos + other.playerheight) {
            if (xpos == other.xpos + other.playerwidth) { //If player is approaching wall from right
                return 3;
            }
            if (xpos + tilewidth == other.xpos) { //If player is approaching wall from left
                return 4;
            }
        }
        return 5; //When 5, nothing happens
    }
}

class Air extends Tile{
    Air(float xpos, float ypos) {
        super(xpos, ypos);
    }
    int interact(Player other) {
        return 5;
    }
}
