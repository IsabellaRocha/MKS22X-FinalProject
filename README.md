# MKS22X-FinalProject

5/20/19:
Izzy: Made the tile class and started making all of its subclasses. Wrote very basic constructors and started the interact() method which determines what the player is allowed to do in difference circumstances.

Tim: Helped edit the tile class so that it worked as efficiently as possible without extra constructors or parameters. Also thought up of most of the concepts and how interact() should work.


5/21/19:
Izzy: Continued working on interact, finished first version that would only work if a player was completely on one tile. First finished interact for ground and air and then for spikes.

Tim: Renamed spikes to have more telling names, fixed interact so that a player can be located on two tiles at once if part of it's body is on one and part is on the other. Changed interact to return a string rather than an int to make more sense when reading the code as to what should happen.


5/22/19 and 5/23/19:
Izzy: Started map class, with the map being made up of a 2D array of tiles. Wrote the constructor and methods so that it can take in a text file with the layout of the map, with hazards being an H, aerial tiles being an A, and ground tiles being a G, and then convert it into a map with the correct tile.

Tim: Made it so that we could easily switch to the next level once the first is completed, implemented scanner, edited the method in which the txt file is converted into the map such that it only has to use one counter variable rather than 3.

5/24/19:
Izzy: Hardcoded the first level txt file. Fixed a minor issue in the interact method. Fixed the first level file to fit the new tile dimensions. Started writing the player class, wrote the constructor and display.

Tim: Merged the Tile and Map branches into master. Changed the tile dimensions such that spikes are now the correct size. Fixed the constructor in player and the formatting of the code.

5/26/19:
Izzy: Started writing the update and getState() method for the player to determine whether they can move left or right or jump. Finished hardcoding the second level. Made player respawn if it falls off map or hits a spike.
