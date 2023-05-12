import java.util.ArrayList;

class Tank implements Sound {

    PVector pos;

    PVector velocity;
    PVector acceleration;
    PVector target;
    float heading;
    float topspeed = 1;
    float rotationspeed = 2;

    boolean rotating = false;
    SoundManager sm;

    Radio radio;

    int id;
    int status = 3;

    int w = 45;
    int h = 45;
    color team_color;
    FOV fov;

    Tank(PVector pos, color team_color, float heading, int id){
        this.pos = pos;
        this.team_color = team_color;
        this.heading = heading;
        this.id = id;
        velocity = acceleration = new PVector(0,0);
        target = pos;
    }

    void add_fov(FOV f){
        fov = f;
    }

    void produce_sound(SoundManager s){
        s.make_sound(pos);
    }

    void perceive_sound(PVector pos){
        
    }

    void add_sound_manager(SoundManager s){
        sm = s;
    }
    void connectTo(Radio r) {
        radio = r;
    }

    void listenTo(Message m) {
        print("Message received from " + m.id + " by " + id);
    }

    void rotate() {
    PVector desired = PVector.sub(target, pos);
    float dif = heading - desired.heading();

    if(abs(dif) > radians(rotationspeed)){
        produce_sound(sm);
        if(dif <= 0){
            heading += radians(rotationspeed);
        } else {
            heading -= radians(rotationspeed);
        }
      
    } else {
        heading = desired.heading();
        rotating = false;
    }

}

    void step() {
            float stepx = random(-250, 250);
            float stepy = random(-250, 250);
            while(pos.x+stepx < 0 || pos.x+stepx > width || pos.y+stepy < 0 || pos.y+stepy > height){
                stepx = random(-250, 250);
                stepy = random(-250, 250);
            }
            target = new PVector(pos.x + stepx, pos.y + stepy);
            rotating = true;
        } 
   
    void arrive() {
            PVector desired = PVector.sub(target, pos);
            float d = desired.mag();
            desired.normalize();

            if (d < 1) {
                float m = map(d,0,100,0,topspeed);
                desired.setMag(m);
                step(); 
            } else {
                desired.setMag(topspeed);
            }

            PVector steer = PVector.sub(desired,velocity);
            steer.limit(1);
            acceleration.add(steer);
        } 
    
    
    

    // Move in cardinal directions
    // Rotate 
    // Fire @Target
    // Reload canon (3 sec)
    // Add sensors

    void move(){
        if(rotating){
            //rotate();
        } else {
            //arrive();
            velocity.add(acceleration);
            velocity.limit(topspeed);
            pos.add(velocity);
            acceleration.mult(0);
        }
       
    }

    void display(){
        stroke(0);
        strokeWeight(2);

        fill(team_color);
        ellipse(pos.x, pos.y, w, h);

        // Health status
        rect(pos.x-20, pos.y-40, 15, 5);
        rect(pos.x-5, pos.y-40, 15, 5);
        rect(pos.x+10, pos.y-40, 15, 5);
    }

}