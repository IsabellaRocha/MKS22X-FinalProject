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
            "LVL2.txt",
            "VICTORY.txt"
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
        if(p.xpos >= xpos && p.xpos < xpos + tilewidth || p.xpos + p.playerwidth > xpos && p.xpos + p.playerwidth <= xpos + tilewidth) {
            // UP
            if(ypos + tileheight + 3 >= p.ypos && ypos + tileheight - 3 <= p.ypos) {
                return "1U";
            }

            // DOWN
            if(ypos + 3 >= p.ypos + p.playerheight && ypos - 3 <= p.ypos + p.playerheight) {
                return "1D";
            }
        }

        if(p.ypos > ypos && p.ypos < ypos + tileheight || p.ypos + p.playerheight > ypos && p.ypos + p.playerheight < ypos + tileheight) {
            // LEFT
            if(p.xpos >= xpos + tilewidth - 2.5 && p.xpos <= xpos + tilewidth + 2.5) {
                return "1L";
            }

            // RIGHT
            if(xpos - 2.5 <= p.xpos + p.playerwidth && xpos + 2.5 >= p.xpos + p.playerwidth) {
                return "1R";
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

        if(p.xpos >= xpos && p.xpos < xpos + tilewidth || p.xpos + p.playerwidth > xpos && p.xpos + p.playerwidth <= xpos + tilewidth) {
            n = ypos + tileheight + 2.5 >= p.ypos && ypos + tileheight - 2.5 <= p.ypos;        // UP
            s = ypos + 2.5 >= p.ypos + p.playerheight && ypos - 2.5 <= p.ypos + p.playerheight;    // DOWN
        }

        if(p.ypos > ypos && p.ypos < ypos + tileheight || p.ypos + p.playerheight > ypos && p.ypos + p.playerheight < ypos + tileheight) {
            w = p.xpos >= xpos + tilewidth - 2.5 && p.xpos <= xpos + tilewidth + 2.5;         // LEFT
            e = xpos - 2.5 <= p.xpos + p.playerwidth && xpos + 2.5 >= p.xpos + p.playerwidth;     // RIGHT
        }

        if(n || s || w || e) return "2H";
        return "0A";
    }
}

class Player {

    PImage right_false;
    PImage right_true;
    PImage left_false;
    PImage left_true;

    PImage last;

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

    // true if player has dashed and not touched the ground since
    boolean dashed;


    Player(float xpos, float ypos) {
        this.xpos = xpos;
        this.ypos = ypos;

        spawnx = xpos;
        spawny = ypos;

        xvel = 0.00;
        yvel = 0.00;

        grav = 0.00;

        playerwidth = 30;
        playerheight = 28;

        dashed = false;

        right_false = loadImage("img/izze_FRAME0.png");
        right_true = loadImage("img/izze_FRAME1.png");

        left_false = loadImage("img/izze_FRAME2.png");
        left_true = loadImage("img/izze_FRAME3.png");

        last = right_false;
    }

    //Loops through tiles, returns state of player (touching wall/ground/ceiling/spike/air)
    boolean getState(String in) {
        for(Tile[] row : mappy.data) {
            for(Tile t : row) {
                if(in.equals(t.interact(madeline))) return true;
            }
        }
        return false;
    }

    //Returns tile player is interacting with
    Tile getTile(String in) {
        for(Tile[] row : mappy.data) {
            for(Tile t : row) {
                if(in.equals(t.interact(madeline))) return t;
            }
        }
        return null;
    }

    void respawn() {
        xpos = spawnx;
        ypos = spawny;
    }

    //Used to time dash
    int start = 0;
    int end = 0;

    //Responsible for all player movement
    void update() {
        xpos += xvel;
        ypos += yvel;
        if(xvel < 0) xvel += .25;
        if(xvel > 0) xvel -= .25;
        if(yvel < 0) yvel += .25;
        if(yvel > 0) yvel -= .25;

        //Move left
        if(left && !getState("1L") && xpos > 0 && xvel == 0) {
            xpos -= 3;
        }

        //Move right
        if(right && !getState("1R") && xpos < width && xvel == 0) {
            xpos += 3;
        }

        //Adjust position of player against right wall
        if(getState("1R")) {
            xvel = 0;
            if(getTile("1R") == null) {
                if(xpos % 1 > .5) ypos = (int) (xpos + 1);
                else xpos = (int)xpos;
            }
            else {
                xpos = getTile("1R").xpos - playerwidth;
            }
        }

        //Adjust position of player against left wall
        if(getState("1L")) {
            xvel = 0;
            if(getTile("1L") == null) {
                if(xpos % 1 > .5) ypos = (int) (xpos + 1);
                else xpos = (int)xpos;
            }
            else {
                xpos = getTile("1L").xpos + getTile("1L").tilewidth;
            }
        }

        //Don't go through sides of map
        if(xpos < 0) xpos = 0;
        if(xpos > width) xpos = width - playerwidth;

        //Switching levels
        if(ypos <= 0) {
            mappy.room_ID += 1;
            mappy.maplayout();

            if(mappy.room_ID == 1) {
                spawnx = 24;
                spawny = 388;
            }
            respawn();
        }

        //Stop when you hit bottom of a tile
        if(getState("1U")) {
            grav = 0;
            yvel = 0;
            ypos += 3;
        }

        //Wall jumping off right wall
        if(!getState("1D") && getState("1R") && jump) {
            xvel = -6;
            grav = 5;
            ypos -= 4;
        }

        //Wall jumping off left wall
        if(!getState("1D") && getState("1L") && jump) {
            xvel = 6;
            grav = 5;
            ypos -= 4;
        }

        //Don't fall through the floor
        if(getState("1D") && !jump) {
            grav = 0;
            yvel = 0;
            if(getTile("1D") == null) {
                if(ypos % 1 > .5) ypos = (int) (ypos + 1);
                else ypos = (int)ypos;
            }
            else {
                ypos = getTile("1D").ypos - playerheight;
            }
            dashed = false;
            start = 0;
        }

        //Jumping
        if(jump && getState("1D")) {
            grav = 6;
            ypos -= 5;
        }

        //Falling in air
        if(!getState("1D") && !getState("1R") && !getState("1L") && !dashed) {
            ypos -= grav;
            if (grav > -5) {
                grav -= .25;
            }
        }

        //Gravity doesn't interfere while dash is still in effect
        if(!getState("1D") && !getState("1R") && !getState("1L") && dashed) {
            if(start == 0) start = frameCount;
            end = frameCount;
            if(end - start > 27) {
                ypos -= grav;
                if (grav > -5) {
                    grav -= .25;
                }
            }

        }

        //Falling when against the wall
        if(!getState("1D") && getState("1R") && !jump || !getState("1D") && getState("1L") && !jump) {
            ypos -= grav;
            if(grav > -1.5) {
                grav -= .25;
            }
            if(grav < -1.5) {
                grav = -1.5;
            }
        }

        //Dashing in all 8 directions
        if(dash && right && up && !down && !left && !dashed) {
            if(!getState("1U") && !getState("1R")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 7;
                    yvel = -7;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1U") && !getState("1R")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 7;
                    yvel = 0;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1R") && !getState("1U")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 0;
                    yvel = -7;
                }
                dashed = true;
                grav = 0;
            }
        }
        if(dash && right && down && !up && !left && !dashed) {
            if(!getState("1D") && !getState("1R")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 7;
                    yvel = 7;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1D") && !getState("1R")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 7;
                    yvel = 0;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1R") && !getState("1D")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 0;
                    yvel = 7;
                }
                dashed = true;
                grav = 0;
            }
        }
        if(dash && right && !down && !up && !left && !dashed && !getState("1R")) {
            if(start == 0) start = frameCount;
            end = frameCount;
            if(end - start < 75) {
                xvel = 7;
                yvel = 0;
            }
            dashed = true;
            grav = 0;
        }
        if(dash && !right && !down && up && left && !dashed) {
            if(!getState("1U") && !getState("1L")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = -7;
                    yvel = -7;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1U") && !getState("1L")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = -7;
                    yvel = 0;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1L") && !getState("1U")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 0;
                    yvel = -7;
                }
                dashed = true;
                grav = 0;
            }
        }
        if(dash && !right && down && !up && left && !dashed) {
            if(!getState("1D") && !getState("1L")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = -7;
                    yvel = 7;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1D") && !getState("1L")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = -7;
                    yvel = 0;
                }
                dashed = true;
                grav = 0;
            }
            if(getState("1L") && !getState("1D")) {
                if(start == 0) start = frameCount;
                end = frameCount;
                if(end - start < 75) {
                    xvel = 0;
                    yvel = 7;
                }
                dashed = true;
                grav = 0;
            }
        }
        if(dash && !right && !down && !up && left && !dashed && !getState("1L")) {
            if(start == 0) start = frameCount;
            end = frameCount;
            if(end - start < 75) {
                xvel = -7;
                yvel = 0;
            }
            dashed = true;
            grav = 0;
        }
        if(dash && !right && !down && up && !left && !dashed && !getState("1U")) {
            if(start == 0) start = frameCount;
            end = frameCount;
            if(end - start < 75) {
                xvel = 0;
                yvel = -7;
            }
            dashed = true;
            grav = 0;
        }
        if(dash && !right && down && !up && !left && !dashed && !getState("1D")) {
            if(start == 0) start = frameCount;
            end = frameCount;
            if(end - start < 75) {
                xvel = 0;
                yvel = 7;
            }
            dashed = true;
            grav = 0;
        }

        //Dying when you hit spike or fall through bottom of world
        if(getState("2H") || ypos > height) {
            respawn();
        }
    }

    void display() {
        // LEFT
        if(xvel < 0 || xvel == 0 && left) {
            if(dashed) {
                image(left_true, xpos, ypos, playerwidth, playerheight);
                last = left_true;
            } else {
                image(left_false, xpos, ypos, playerwidth, playerheight);
                last = left_false;
            }
        }

        // RIGHT
        if(xvel > 0 || xvel == 0 && right) {
            if(dashed) {
                image(right_true, xpos, ypos, playerwidth, playerheight);
                last = right_true;
            } else {
                image(right_false, xpos, ypos, playerwidth, playerheight);
                last = right_false;
            }
        }

        //UP AND DOWN
        else if(dashed && down || dashed && up) {
            if(last == right_false || last == right_true) {
                image(right_true, xpos, ypos, playerwidth, playerheight);
                last = right_true;
            }
            if(last == left_false || last == left_true) {
                image(left_true, xpos, ypos, playerwidth, playerheight);
                last = left_true;
            }
        }

        //Change back to normal color as soon as you touch the ground
        if(xvel == 0 && getState("1D")) {
            if(last == right_false || last == right_true) {
                image(right_false, xpos, ypos, playerwidth, playerheight);
                last = right_false;
            }
            if(last == left_false || last == left_true) {
                image(left_false, xpos, ypos, playerwidth, playerheight);
                last = left_false;
            }
        }
        // DEFAULT CASE
        else {
            image(last, xpos, ypos, playerwidth, playerheight);
        }
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

PImage LVL1;
PImage LVL2;
PImage VICTORY;

Map mappy;
Player madeline;

void setup() {
    size(512, 512);
    frameRate(60);

    LVL1 = loadImage("img/LEVEL_01.png");
    LVL2 = loadImage("img/LEVEL_02.png");
    VICTORY = loadImage("img/VICTORY.png");

    mappy = new Map();
    madeline = new Player(24, 388);
}

void draw() {
    if(mappy.room_ID == 0) image(LVL1, 0, 0);
    if(mappy.room_ID == 1) image(LVL2, 0, 0);

    if(mappy.room_ID != 2) {
        madeline.display();
        madeline.update();
    }
    else image(VICTORY, 0, 0);
}
