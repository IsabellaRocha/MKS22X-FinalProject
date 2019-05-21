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
    
    abstract int interact();
}

class Spike extends Tile {

}

class Ground extends Tile {

}
