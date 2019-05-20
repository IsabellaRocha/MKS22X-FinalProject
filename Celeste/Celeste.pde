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
        this.width = 16;
        this.height = 20;
        this.xpos = xpos;
        this.ypos = ypos;
    }
}

class Ground extends Tile {
    Ground(float xpos, float ypos) {
        super(xpos, ypos);
    }
}

class Exit extends Tile {
    Exit(float xpos, float ypos) {
        super(xpos, ypos);
    }
}
