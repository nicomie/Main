import java.util.Map;


class Radio {
    ArrayList<Tank> members = new ArrayList<>();

    void add_member(Tank t){
        members.add(t);
    }

    void send_message(Message m) {
        for(Tank t : members) {
            if(t.id != m.id) {
                t.listenTo(m);
            }
        }
    }

}

interface Sound {
    void perceive_sound(PVector pos);
    void produce_sound(SoundManager sm);

}

class Message {
    int id;
    int status;
    int enemies;

    Message(int id, int status, int enemies) {
        this.id = id;
        this.status = status;
        this.enemies = enemies;
    }
}

class FOV {

    static final int DIAMETER = 350;
    static final int RADIUS = DIAMETER/2;
 
    Game_map map;
    Tank tank;
    color c = color(0, 0, 0, 50);
    boolean in_range = false;
    int enemies_in_range = 0;

    boolean cooldown = false;
    int millis = 0;

    FOV(Game_map _map, Tank _tank){
        map = _map;
        tank = _tank;
    }

    void sense(){
        boolean found = false;
        int amount = 0;

        for (Map.Entry<Integer, Tank> set : map.tanks.entrySet()) {
            Tank t = set.getValue();
            
            PVector point = t.pos;
            PVector center = tank.pos;

            float startArc = tank.heading-PI/8;
            float endArc = tank.heading+PI/8;

            float distance = center.dist(point);
            float angle = atan2(point.y - center.y, point.x - center.x);

            if(distance < RADIUS && angle > startArc && angle < endArc) {
                if(tank.id != t.id && tank.team_color != t.team_color){
                    found = true;
                    enemies_in_range++;
                }
             
            } 
        }
        if(found){
            in_range = true;
            if(!cooldown){
                tank.radio.send_message(new Message(tank.id, tank.status, enemies_in_range));
                cooldown = true;
                millis = 100;
        
            } else {
                millis--;
                if(millis < 0){
                    cooldown = false;
                }
            }
            
           
        } else {
            in_range = false;
            enemies_in_range = 0;
        }
    }

    void draw(){
        noStroke();
        float heading = tank.heading;
        sense();
        if(in_range){
            fill(255, 0, 0, 100);
            arc(tank.pos.x, tank.pos.y, 
            DIAMETER, DIAMETER, 
            heading-PI/8, 
            heading+PI/8
            );
        } else {
            fill(0,0,255,100);
            arc(tank.pos.x, tank.pos.y, 
            DIAMETER, DIAMETER, 
            heading-PI/8, 
            heading+PI/8
            );
        }


    }

}