# MKS22X-FinalProject

## CELESTE

"  
[Celeste](http://www.celestegame.com/) is a platforming video game by Canadian video game developers Matt Thorson and Noel Berry, with art of the Brazilian Studio MiniBoss. The game was originally created as a prototype in four days during a game jam, and later expanded into a full release.  
"  

In this game, players control a single player character, Madeline, as she scales Celeste in search of self-worth and accomplishment. Celeste plays true to the standard platformer game formula, introducing only two deviations –- air dashing and wall jumping. The goal is to get to the top of the screen using any means necessary.

To play, the controls are very simple. Press D to move right and A to move left. Press K to jump and J to dash. Hold down W, A, S, D, or a combination of the two while pressing J to indicate which direction you'd like to dash in. You can only dash once while in the air, so be careful!


## DEVLOG

### 5/20/19:
**Izzy:** Made the Tile class and started making all of its subclasses. Wrote very basic constructors and started the interact() method which determines what the player is allowed to do in difference circumstances.

**Tim:** Helped edit the tile class so that it worked as efficiently as possible without extra constructors or parameters. Also thought up of most of the concepts and how interact() should work.


### 5/21/19:
**Izzy:** Continued working on interact, finished first version that would only work if a player was completely on one tile. First finished interact for ground and air and then for spikes.

**Tim:** Renamed spikes to have more telling names, fixed interact so that a player can be located on two tiles at once if part of it's body is on one and part is on the other. Changed interact to return a string rather than an int to make more sense when reading the code as to what should happen.


### 5/22/19 - 5/23/19:
**Izzy:** Started map class, with the map being made up of a 2D array of tiles. Wrote the constructor and methods so that it can take in a text file with the layout of the map, with hazards being an H, aerial tiles being an A, and ground tiles being a G, and then convert it into a map with the correct tile.

**Tim:** Made it so that we could easily switch to the next level once the first is completed, implemented scanner, edited the method in which the txt file is converted into the map such that it only has to use one counter variable rather than 3.


### 5/24/19:
**Izzy:** Hardcoded the first level txt file. Fixed a minor issue in the interact method. Fixed the first level file to fit the new tile dimensions. Started writing the player class, wrote the constructor and display.

**Tim:** Merged the Tile and Map branches into master. Changed the tile dimensions such that spikes are now the correct size. Fixed the constructor in player and the formatting of the code.


### 5/26/19:
**Izzy:** Started writing the update and getState() method for the player to determine whether they can move left or right or jump. Finished hardcoding the second level. Made player respawn if it falls off map or hits a spike.


### 5/28/19:
**Izzy:** Updated the horizontal movement of the player. Also updated it so that the player now spawns in the correct spot.

**Tim:** Changed how movement works, utilized booleans so that we don't check keyPressed every time. This allows for much smoother movement. Also added the setup() and draw() methods to display our map and player.


### 5/29/19:
**Izzy:** Changed how spike interact works so that it doesn't always return that the player is dying. Now it only returns 2H when the player is touching the spike. Created a toString for testing. Changed getState() to take in a String and return a boolean.

**Tim:** Figured out that getState() was only checking the first tile because the return statement ended it early, changed getState() to return a boolean instead. Merged what we had with master and changed map constructor to read files correctly now.


### 5/30/19:
**Izzy:** Spent most of the time confused as to why last row of map wasn't being made and we were getting null pointer exception, turns out LVL1 was missing 2 lines so it wasn't filling up the array, updated LVL1.txt.

**Tim:** Wrote toStringDebug(), found out that the last row was missing which was causing our problems.


### 5/31/19:
**Izzy:** Added test cases to see why player was being stopped despite not running into walls, changed interact so touching the floor didn't stop it. Made it so you can't run through the side of the map and that you respawn in the original spot when you fall off map or hit a spike, deleted test functions.

**Tim:** Added test cases to see which interactions were triggering, if cases weren't being triggered. Also color coded map to see if it was being generated properly, it wasn't, fixed map layout to properly generate map by scale of 16. Also realized that when updating position by a float, you could still run through tiles, suggested adding a range.


### 6/1/19:
**Izzy:** Added the range so that you could update position by a float and the position of the player would not need to be exactly equal to the location of the tile. Also added the ranges to the edge of the map so that you can't run through that.


### 6/2/19:
**Izzy:** Added jumping and messed around with gravity constant. Fixed switching between levels and mostly fixed bugs that occur while jumping. Made it so you die as soon as you hit a spike and that your jump is stopped when you hit a tile above you.

**Tim:** Cleaned up code to make it work a little more smoothly, thought of ways to fix the last jump bugs. Also drew the map for level 2.


### 6/3/19:
**Izzy:** Fixed bugs where half your body would be in the floor. Also changed the way we calculate ypos by having it equal that of the tile such that it is flush with the tile and the player doesn't get stuck in the floor. Implemented wall jumping and dashing, fixed almost all cases in which you go into the wall through edge detection except when wall jumping and dashing. Wrote code for generating victory screen once you reach the end.

**Tim:** Tried to fix the problem of going into the wall when dashing, as well as help to think of a way to adjust ypos accordingly. Continued drawing second map and trying to shrink the ranges necessary for tile detection.
