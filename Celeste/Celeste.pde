abstract class Tile {
    float tilewidth;
    float tileheight;

    float xpos;
    float ypos;

    Tile(float xpos, float ypos) {
        tilewidth = 32;
        tileheight = 32;

        this.xpos = xpos;
        this.ypos = ypos;
    }
    abstract int interact();
}

class Spike extends Tile {
    Spike(float xpos, float ypos) {
        this.tilewidth = 16;
        this.tileheight = 20;
        this.xpos = xpos;
        this.ypos = ypos;
    }

}

class Ground extends Tile {
    Ground(float xpos, float ypos) {
        super(xpos, ypos);
    }
    int interact(Player other) {
        if (xpos <= other.xpos && xpos + tilewidth >= other.xpos + other.playerWidth) {
            if (ypos == other.ypos - other.playerheight) {
                return 1;
            }
            if (ypos - tileheight == other.ypos) {
                return 2;
            }
        }
    }
}
