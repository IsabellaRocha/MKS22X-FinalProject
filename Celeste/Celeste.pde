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

    void maplayout() {
        String[] f = loadStrings(map_archive[room_ID]);

        for(int i=0; i<f.length; i++) {
            for(int j=0; j<f[i].length(); j++) {
                if(f[i].charAt(j) == 'G') data[i][j] = new GROUND(j*16, i*16);
                else if(f[i].charAt(j) == 'H') data[i][j] = new HAZARD(j*16, i*16);
                else data[i][j] = new AERIAL(j*16, i*16);
            }
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

    AERIAL(float xpos, float ypos) {
        super(xpos, ypos);
    }

    String interact(Player p) {
        return "0A";
    }
}

class GROUND extends Tile {

    GROUND(float xpos, float ypos) {
        super(xpos, ypos);
    }

    String interact(Player p) {
        if(p.ypos > ypos && p.ypos < ypos + tileheight || p.ypos + p.playerheight > ypos && p.ypos + p.playerheight < ypos + tileheight) {
            // LEFT
            if(p.xpos >= xpos + tilewidth - .601 && p.xpos <= xpos + tilewidth + .601) {
                return "1L";
            }

            // RIGHT
            if(xpos - .601 <= p.xpos + p.playerwidth && xpos + .601 >= p.xpos + p.playerwidth) {
                return "1R";
            }
        }
        if(p.xpos >= xpos && p.xpos < xpos + tilewidth) {
            // UP
            if(ypos + tileheight + .601 >= p.ypos && ypos + tileheight - .601 <= p.ypos) {
                return "1U";
            }

            // DOWN
            if(ypos + .601 <= p.ypos + p.playerheight && ypos - .601 >= p.ypos + p.playerheight) {
                return "1D";
            }
        }

        return "0A";
    }
}

class HAZARD extends Tile {

    HAZARD(float xpos, float ypos) {
        super(xpos, ypos);
    }

    String interact(Player p) {
        boolean n, s, w, e;
        n = false;
        s = false;
        w = false;
        e = false;

        if(p.xpos >= xpos && p.xpos < xpos + tilewidth) {
            n = ypos + tileheight + .601 >= p.ypos && ypos + tileheight - .601 <= p.ypos;        // UP
            s = ypos + .601 <= p.ypos + p.playerheight && ypos - .601 >= p.ypos + p.playerheight;    // DOWN
        }

        if(p.ypos > ypos && p.ypos < ypos + tileheight || p.ypos + p.playerheight > ypos && p.ypos + p.playerheight < ypos + tileheight) {
            w = (p.xpos >= xpos + tilewidth - .601 && p.xpos <= xpos + tilewidth + .601);         // LEFT
            e = (xpos - .601 <= p.xpos + p.playerwidth && xpos + .601 >= p.xpos + p.playerwidth);     // RIGHT
        }

        if(n || s || w || e) return "2H";
        return "0A";
    }
}

class Player {

    // PImage img;

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

    Player(float xpos, float ypos) {
        this.xpos = xpos;
        this.ypos = ypos;

        spawnx = xpos;
        spawny = ypos;

        xvel = 0.00;
        yvel = 0.00;

        grav = 1.00;

        // playerwidth = 36;
        // playerheight = 28;

        playerwidth = 30;
        playerheight = 28;

        // img = loadImage("img/izze.png");
    }

    boolean getState(String in) {
        for(Tile[] row : mappy.data) {
            for(Tile t : row) {
                if(in.equals(t.interact(madeline))) return true;
            }
        }

        return false;
    }

    void update() {
        if(left && !getState("1L") && xpos > 0) {
            xpos -= 3;
        }

        if(right && !getState("1R") && xpos < width) {
            xpos += 3;
        }

        /*
        if(getState("1U")) {
            yvel = 0;
        }

        if(getState("2H") || ypos > height) {
            xpos = spawnx;
            ypos = spawny;
        }
        */

    }

    void display() {
        // image(img, xpos, ypos, playerwidth, playerheight);

        noStroke();

        fill(215, 20, 20);
        rect(xpos, ypos, playerwidth, playerheight);
    }
}

boolean dash, jump;
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

PImage bg;

Map mappy;
Player madeline;

void setup() {
    size(512, 512);
    frameRate(60);

    bg = loadImage("img/LEVEL_01.png");

    mappy = new Map();
    madeline = new Player(30, 388);
}

void draw() {
    image(bg, 0, 0);

    madeline.display();
    madeline.update();
}
