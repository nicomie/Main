import java.util.Map;

class Sensor {
    Tank tank;
    GameMap map;
    int distance;

    Sensor(Tank tank, int distance){
        this.tank = tank;
        map = tank.map;
        this.distance = distance;
    }

    public HashMap<PVector, Integer> sense(PVector current) {
        
        HashMap<PVector, Integer> adjacent = new HashMap<PVector, Integer>();

        PVector raw = map.lookup(current);
        int x = (int)raw.x;
        int y = (int)raw.y;

        for (int i = x-distance; i <= x+distance; i++){
            for(int j = y-distance; j <= y+distance; j++) {
                if(i >= 0 && j >= 0 && i < map.cols && j < map.rows) {
                    if(map.nodes[i][j].visited){
                        adjacent.put(new PVector(i, j), 1);
                    } else if (map.nodes[i][j].danger) {
                        adjacent.put(new PVector(i, j), 3);
                    } else {
                        adjacent.put(new PVector(i, j), 0);
                    }
                   
                } else {
                    // out of bound
                    adjacent.put(new PVector(i, j), 2);
                }       
            }
        }        
        return adjacent; 
    }

}

