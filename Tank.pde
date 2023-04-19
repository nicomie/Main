class Tank implements GameObject{
  int width = 50;
  int height = 50;

  Grid map;
  GameLogic gl;
  boolean inMotion = false;

  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector target;
  float topspeed = 6;
  
  State patrolState;
  State fleeState;
  State currentState;

  
   Tank(Grid map, GameLogic _gl) {
    this.map = map;
    map.tank = this;
    gl = _gl;
    gl.registerEntity(this);

    position = new PVector(0, 0);
    velocity = acceleration = new PVector(0,0);
  
    patrolState = new PatrolState(this);
    fleeState = new FleeState(this);
    currentState = new PatrolState(this);
  }
    
  public PVector getPosition(){
    return this.position;
  }
  public float getWidth(){
    return this.width;
  }
  public float getHeight(){
    return this.height;
  }

  void moveTo(PVector target){
    this.target = target;
  }

  void arrive() {
        PVector desired = PVector.sub(target, position);
        float d = desired.mag();
        desired.normalize();
        if(d < 1) {
          map.proceed();
        }
        else if (d < 10) {
          float m = map(d,0,100,0,topspeed);
          desired.setMag(m);
        } else {
          desired.setMag(topspeed);
        }
    
        PVector steer = PVector.sub(desired,velocity);
        steer.limit(1);
        acceleration.add(steer);
    } 

 
  
  void rotate(float rad) {
     
  }
  
  float evaluateUtility() {
    return 0.0;
  }
  
  void planAction() {
   // evaluate utility and plan action 
  }
  
  void setState(State state) {
   currentState = state; 
  }


  void update() {
    checkEdges();

    arrive();
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(topspeed);
    position.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
    currentState.Execute();

    display();

  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(position.x, position.y, 50, 50);
    line(position.x, position.y, position.x + 100, position.y);
  }

  void checkEdges() {

    if (position.x > width) {
     
    } 
    else if (position.x < 0) {
     
    }

    if (position.y > height) {
    
    } 
    else if (position.y < 0) {
     
    }
  }


}
