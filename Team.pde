import java.util.ArrayList;

class Team {
    Game_map map;
    ArrayList<Tank> tanks = new ArrayList<>();
    Base base;
    color team_color;
    float heading;
    Radio radio = new Radio();

    Team(ArrayList<PVector> positions, Game_map map, Base base, color team_color, float heading){
        this.map = map;
        this.team_color = team_color;
        this.base = base;
        this.heading = heading;

      
        
        for(PVector p : positions){
            Tank t = new Tank(p, team_color, heading, map.generateId());
            t.add_fov(new FOV(map, t));
            tanks.add(t);
            radio.add_member(t);
            t.connectTo(radio);
            sm.add_sound(tank);
            t.add_sound_manager(sm);
        }

      
        map.add(tanks);
        
    }

    void render(){
       
        base.render();

        for(Tank tank : tanks){
       
            tank.move();
            map.update(tank);
            tank.display();
        
            tank.fov.sense();
            tank.fov.draw();
       
     
        }

    

    }

}

