import java.io.FileNotFoundException;

import java.util.Scanner;

class Map {
    Tile[][] data;
    String[] map_archive;
    int room_ID;

    Map() {
        data = new Tile[32][32];

        String[] maps = {
            "LVL1.txt",
            "LVL2.txt"
        };
        map_archive = maps;

        room_ID = 0;

        maplayout();
    }

    void maplayout() throws FileNotFoundException {
        File f = new File(map_archive[room_ID]);
        Scanner in = new Scanner(f);

        for(int i=0; i<in.toString().length(); i++) {
            int row = i / 16;
            int col = i - 16 * (i / 16);

            if(str.charAt(i) == 'H') map[row][col] = new HAZARD(row * 16, col * 16);
            if(str.charAt(i) == 'G') map[row][col] = new GROUND(row * 16, col * 16);
            else map[row][col] = new AERIAL(row * 16, col * 16);
        }
    }
}

abstract class Tile {
    float tilewidth;
    float tileheight;

    float xpos;
    float ypos;

    Tile(float xpos, float ypos) {
        tilewidth = 16;
        tileheight = 16;

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
            if (ypos + tileheight == p.ypos) {
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

class Player {

    PImage img;

    // player position
    float xpos, ypos;

    // player dimensions
    int playerwidth;
    int playerheight;

    // float y velocity
    float xvel, yvel;

    // gravitational constant
    float grav;

    // player spawn point
    float spawnx, spawny;

    // can jump, can air dash
    boolean jump, dash;

    Player(float xpos, float ypos) {
        this.xpos = xpos;
        this.ypos = ypos;

        spawnx = xpos;
        spawny = ypos;

        xvel = 0.00;
        yvel = 0.00;

        grav = 1.00;

        playerwidth = 36;
        playerheight = 28;

        img = loadImage("img/izze.png");
    }

    String getState() {
        for (Tile[] arr: play.data) {
            for (Tile t: arr) {
                return t.interact(this);
            }
        }
    }

    void update() {
        /*
        xpos += xvel;
        ypos += yvel;
        int og = ypos;
        boolean jumped = false;
        if (ypos == og && !jumped) yvel = 0;
        if(keyPressed) {
            if(keyCode == RIGHT && !getState().equals("1R") && xpos != width) {
                xvel = 2.0;
            }
            if(keyCode == LEFT && !getState().equals("1L") && xpos != 0) {
                xvel = -2.0;
            }
            else if (keyCode != RIGHT && keyCode != LEFT) xvel = 0;
            if(getState().equals("1D")) {
                jumped = false;
                if(key == 'c') {
                    og = ypos;
                    jumped = true;
                    yvel = -4;
                }
            }
        }
        if(getState().equals("0A")) {
            yvel += grav;
        }
        if(getState().equals("1U")) {
            yvel = 0;
        }
        if(getState().equals("2H") || ypos == height) {
            xpos = spawnx;
            ypos = spawny;
        }
        */
    }

    void display() {
        image(img, xpos, ypos, playerwidth, playerheight);
    }
}

boolean up, down, left, right;

void keyPressed() {
    setMove(keyCode, true);
}

void keyReleased() {
    setMove(keyCode, false);
}

boolean setMove(int k, boolean active) {
    if(k == 74) return dash  = active;     // J
    if(k == 75) return jump  = active;     // K

    if(k == 87) return up    = active;     // W
    if(k == 83) return down  = active;     // S
    if(k == 65) return left  = active;     // A
    if(k == 68) return right = active;     // D

    return active;
}

void setup() {
    size(512, 512);
    frameRate(60);
}

void draw() {
    
}
