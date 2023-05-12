import java.util.HashMap;

class Game_map {
    int w, h;
    public int id = 0;
    HashMap<Integer, Tank> tanks = new HashMap<>();

    Game_map(){
        this.w = width;
        this.h = height; 
    }

    int generateId(){
        return id++;
    }

    void add(ArrayList<Tank> tanks) {
        for(Tank t : tanks){
            this.tanks.put(t.id, t);
        }
    }

    void update(Tank t){
        tanks.replace(t.id, t);
    }
     

}