class Tile {
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
}

class Spike extends Tile {
    Spike(float xpos, float ypos) {
        super();
    }
}

class Ground extends Tile {

}
