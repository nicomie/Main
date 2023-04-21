// Nicholas Miettinen nimi9384

Tank tank;
GameMap map;

void setup() {
    size(800, 800);
    map = new GameMap(20, 20, 40);
    tank = new Tank(map);
    map.register(tank);
    
}

void draw() {    
    background(255);
    map.display();
}

void keyPressed(){
    tank.resume();
}

  
    
 

