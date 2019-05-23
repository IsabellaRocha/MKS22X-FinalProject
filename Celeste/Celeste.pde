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

    abstract String interact(Player p);
}

class AERIAL extends Tile {

    String interact(Player p) {
        return "0A";
    }

}

class GROUND extends Tile {

    String interact(Player p) {
        if(p.xpos >= xpos && p.xpos < xpos + tilewidth) {
            // UP
            if (ypos == p.ypos - tileheight) {
                return "1U";
            }

            // DOWN
            if (ypos == p.ypos + p.playerheight) {
                return "1D";
            }
        }

        if(p.ypos <= ypos && p.ypos >= ypos - tileheight) {
            // LEFT
            if (xpos + tilewidth == p.xpos) {
                return "1L";
            }

            // RIGHT
            if (xpos == p.xpos + p.playerwidth) {
                return "1R";
            }
        }

        return "0A";
    }

}

class HAZARD extends Tile {

    String interact(Player p) {
        return "2H";
    }

}
