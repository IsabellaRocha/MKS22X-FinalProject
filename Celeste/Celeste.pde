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
        String[] f = loadStrings("LVL1.txt");

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
    abstract int getType();
}

class AERIAL extends Tile {

    AERIAL(float xpos, float ypos) {
        super(xpos, ypos);
    }

    String interact(Player p) {
        return "0A";
    }

    int getType() {
        return 0;
    }
}

class GROUND extends Tile {

    GROUND(float xpos, float ypos) {
        super(xpos, ypos);
    }

    String interact(Player p) {
        if(p.ypos > ypos && p.ypos < ypos + tileheight || p.ypos + p.playerheight > ypos && p.ypos + p.playerheight < ypos + tileheight) {
            // LEFT
            if(p.xpos == xpos + tilewidth) {
                println("LEFT");
                fill(0, 255, 0);
                ellipse(xpos, ypos, 5, 5);
                return "1L";
            }

            // RIGHT
            if(xpos == p.xpos + p.playerwidth) {
                println("RIGHT");
                fill(0, 255, 0);
                ellipse(xpos, ypos, 5, 5);
                return "1R";
            }
        }
        if(p.xpos >= xpos && p.xpos < xpos + tilewidth) {
            // UP
            if(ypos + tileheight == p.ypos) {
                return "1U";
            }

            // DOWN
            if(ypos == p.ypos + p.playerheight) {
                return "1D";
            }
        }

        return "0A";
    }

    int getType() {
        return 1;
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
            n = ypos + tileheight == p.ypos;        // UP
            s = ypos == p.ypos + p.playerheight;    // DOWN
        }

        if(p.ypos <= ypos && p.ypos >= ypos - tileheight) {
            w = xpos + tilewidth == p.xpos;         // LEFT
            e = xpos == p.xpos + p.playerwidth;     // RIGHT
        }

        if(n || s || w || e) return "2H";
        return "0A";
    }

    int getType() {
        return 2;
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

    boolean getState(String in) {
        for(Tile[] row : mappy.data) {
            for(Tile t : row) {
                if(in.equals(t.interact(madeline))) return true;
            }
        }

        return false;
    }

    void update() {
        if(left && !getState("1L") && xpos != 0) {
            xpos -= 2;
        }

        if(right && !getState("1R") && xpos != width) {
            xpos += 2;
        }
        if(getState("1U")) {
            yvel = 0;
        }
        if(getState("2H") || ypos == height;) {
            xpos = spawnx;
            ypos = spawny;
        }

        /*
        if(getState("0A") && !getState("1D")) {
            ypos += 10;
        }
        if(jump && getState("1D")) {
            ypos -= 100;
        }

        /*

        xpos += xvel;
        ypos += yvel;
        int og = ypos;
        boolean jumped = false;
        if (ypos == og && !jumped) yvel = 0;
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
        */
    }

    void display() {
        image(img, xpos, ypos, playerwidth, playerheight);
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

void test() {
    for(Tile[] arr : mappy.data) {
        for(Tile t : arr) {
            if(t.getType() == 0) fill(255, 255, 255);
            if(t.getType() == 1) fill(0, 0, 0);
            if(t.getType() == 2) fill(255, 0, 0);
            rect(t.xpos, t.ypos, 16, 16);
        }
    }
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
    // image(bg, 0, 0);
    test();
    madeline.display();
    madeline.update();
    fill(0, 0, 255);
    ellipse(madeline.xpos, madeline.ypos, 5, 5);
    ellipse(madeline.xpos + madeline.playerwidth, madeline.ypos, 5, 5);
}
