// Created by Nicholas Miettinen

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;


// AI Relevant code: Registers the tank as a Sound to be able to produce and receive sound
class Tank implements Sound {
    
    PVector pos;
    
    PVector velocity;
    PVector acceleration;
    PVector target;
    float heading;
    float topspeed = 2;
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
    
    Cannon cannon;

    PVector soundTarget = new PVector(0,0);
    
    Tank(PVector pos, color team_color, float heading, int id) {
        this.pos = pos;
        this.team_color = team_color;
        this.heading = heading;
        this.id = id;
        velocity = acceleration = new PVector(0,0);
        target = pos;
        cannon = new Cannon();
    }
    
    void add_fov(FOV f) {
        fov = f;
    }
    
    void produce_sound(SoundManager s) {
        s.make_sound(pos);
    }
    
    // AI Relevant code: The warning shot used for task announcement. 
    // This together with the message should generate a bidding process
    // A bidding process is started if a message is received and a sound is perceived in a certain time interval.
    void perceive_sound(PVector pos) {
        print("starting the bidding process");
        soundTarget = pos;
    }
    
    void add_sound_manager(SoundManager s) {
        sm = s;
    }
    void connectTo(Radio r) {
        radio = r;
    }
    
    // AI Relevant code: The method is used by agents to receive the task announcement
    void listenTo(Message m) {
        println("Message received from " + m.id + " by " + id);
        // Start bid
    }


    
    void rotate() {
        PVector desired = PVector.sub(target, pos);
        float dif = heading - desired.heading();
        
        if (abs(dif) > radians(rotationspeed)) {
            if (dif <= 0) {
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
        float stepx = random( -250, 250);
        float stepy = random( -250, 250);
        while(pos.x + stepx < 0 || pos.x + stepx > width || pos.y + stepy < 0 || pos.y + stepy > height) {
            stepx = random( -250, 250);
            stepy = random( -250, 250);
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
    
    void move() {
        if (rotating) {
            rotate();
        } else {
            arrive();
            velocity.add(acceleration);
            velocity.limit(topspeed);
            pos.add(velocity);
            acceleration.mult(0);
        }
        
    }
    
    void display() {
        
        stroke(0);
        strokeWeight(2);
        
        fill(team_color);
        ellipse(pos.x, pos.y, w, h);
        
        cannon.draw();
        
        // Health status
        fill(team_color);
        rect(pos.x - 20, pos.y - 40, 15, 5);
        rect(pos.x - 5, pos.y - 40, 15, 5);
        rect(pos.x + 10, pos.y - 40, 15, 5);
    }
    
    class Cannon {
        // Fire @Target
        // Reload canon (3 sec)
        boolean charging = false;
        int timer;
        
        
        void fire(PVector position) {
            if (!charging) {
                
                /* AI Relevant code: [UNIMPLEMENTED] Here goes a warning shot and is used together with the message broadcast
                * to start a task announcement. It should also make a sound. 
                */
                print("FIRED");

                timer = 180;
            } else {
                if (timer-- < 0) {
                    charging = false;
                }
            }
            
        }
        
        void draw() {
            stroke(0);
            strokeWeight(2);
            fill(127);
            ellipse(pos.x, pos.y, 25, 25);
            line(pos.x, pos.y, pos.x + (50 * cos(heading)), pos.y + (50 * sin(heading)));
        }
        
    }   
    
}