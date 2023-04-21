class Tank implements GameObject{
    int width = 50;
    int height = 50;
    
    GameMap map;
    boolean inMotion = false;
    
    PVector position;
    PVector velocity;
    PVector acceleration;
    PVector target;
    float heading;
    float topspeed = 12;

    public Sensor sensor;
    boolean paused = true;
    
    Tank(GameMap map) {
        this.map = map;
        map.tank = this;
        sensor = new Sensor(this, 1);
        heading = 50;
        
        position = new PVector(300, 300);
        velocity = acceleration = target = new PVector(0,0);


        executeAction();
        
    }
    
    HashMap<PVector, Integer> percept() {
        return sensor.sense(position);
    }
    
    void executeAction() {
        float prob = 0.01;
        HashMap<PVector, Integer> percepts = percept();
        
        for (Map.Entry me : percepts.entrySet()) {
         //   print(me.getKey() + " is ");
          //  println(me.getValue());
        }
        
        PVector nextPos = getNextPosition();

        int info = percepts.get(nextPos);

        boolean ready = false;
        while(!ready){
            if(info == 3){
                map.rememberDanger(position);
                nextPos = getNextPosition();
                info = percepts.get(nextPos);
            } else if(info == 2){
                nextPos = getNextPosition();
                info = percepts.get(nextPos);
            } else if (info == 1){
                float r = random(1);
                if (r < prob){
                    ready = true;
                } else {
                    nextPos = getNextPosition();
                    info = percepts.get(nextPos);
                }
            } else {
                ready = true;
            }

        }

        map.setVisited(position);

        target = map.gridToMap(nextPos);
        rotateTo(target);
        
    }

    void rotateTo(PVector to){
        PVector rotate = PVector.sub(to, position);
        heading = rotate.heading();
    }
    
    PVector getNextPosition() {
        PVector raw = map.lookup(position);
        int stepx = int(random(3)) - 1;
        int stepy = int(random(3)) - 1;

        print("X" + stepx);
        print("Y" + stepy);
        println();
        
        return new PVector((int)raw.x + stepx, (int)raw.y + stepy);
        
        
    }
    
    public PVector getPosition() {
        return this.position;
    }
    public float getWidth() {
        return this.width;
    }
    public float getHeight() {
        return this.height;
    }
    
    void moveTo(PVector target) {
        this.target = target;
    }
    
    void arrive() {

        PVector desired = PVector.sub(target, position);
       

        float d = desired.mag();
        desired.normalize();
       
        if (d < 10) {
            float m = map(d,0,100,0,topspeed);
            desired.setMag(m);
        } else {
            desired.setMag(topspeed);
        }
        
        PVector steer = PVector.sub(desired,velocity);
        steer.limit(1);
        acceleration.add(steer);

        if (d < 1) {
            executeAction();       
        }
    } 
    
    void resume(){
        paused = false;
    }
    
    
    
    void render() {
        arrive();
        // Update velocity
        velocity.add(acceleration);
        // Limit speed
        velocity.limit(topspeed);
        position.add(velocity);
        // Reset accelerationelertion to 0 each cycle
        acceleration.mult(0);
        display();
        
    }
    
    void display() {
        stroke(0);
        strokeWeight(2);
        fill(127);
        ellipse(position.x, position.y, 50, 50);
        line(position.x, position.y, position.x + (50*cos(heading)), position.y + (50*sin(heading)));

    }
    
}
