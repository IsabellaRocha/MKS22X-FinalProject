import java.io.FileNotFoundException;

class Map {
    Tile[][] data;
    String[] map_archive;
    int room_ID;

    Map() {
        data = new Tile[32][32];

        String[] maps = {
            "LVL1.txt",
            "LVL2.txt"
        }
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
