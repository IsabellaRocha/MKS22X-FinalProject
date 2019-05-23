import java.util.*
class Map {
    Tile[][] map;
    Map(String str) {
        map = new Tile[32][32];
        int count = 0;
        for (int idx = 0; idx < 32; idx++) {
            for (int x = 0; x < 32; x++) {
                if(str.charAt(count) == 'H') map[idx][x] = new HAZARD(idx * 16, x * 16);
                if(str.charAt(count) == 'G') map[idx][x] = new GROUND(idx * 16, x * 16);
                else map[idx][x] = new AERIAL(idx * 16, x * 16);
                count++;
            }
        }
    }
    String convert() throws FileNotFoundException{
        File f = new File("MapArchive.txt");
        Scanner x = new Scanner(f);
        return x.toString();
    }
}
