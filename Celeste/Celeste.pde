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
        try {
            File f = new File(map_archive[room_ID]);
            Scanner in = new Scanner(f);

            String str = in.toString();
            for(int i=0; i<str.length(); i++) {
                int row = i / 16;
                int col = i - 16 * (i / 16);

                if(str.charAt(i) == 'H') data[row][col] = new HAZARD(row * 16, col * 16);
                if(str.charAt(i) == 'G') data[row][col] = new GROUND(row * 16, col * 16);
                else data[row][col] = new AERIAL(row * 16, col * 16);
            }
        } catch(FileNotFoundException e) {
            e.printStackTrace();
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
    String toStringDebug() {
        println("A");
    }
}

class GROUND extends Tile {

    GROUND(float xpos, float ypos) {
        super(xpos, ypos);
    }

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
    String toStringDebug() {
        println("G");
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
    String toStringDebug() {
        println("H");
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
                println(this);
                println(t);
                println(in);
                if(in.equals(t.interact(this))) return true;
            }
        }

        return false;
    }

    void update() {
        if(left && !getState("1L")) {
            xpos -= 1;
        }

        if(right && !getState("1R")) {
            xpos += 1;
        }
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
