/* autogenerated by Processing revision 1292 on 2023-04-21 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.Collections;
import java.util.Stack;
import java.util.Map;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class sketch_230413a extends PApplet {


Tank tank;
GameMap map;
Obstacle o1,o2,o3;

public void setup() {
    /* size commented out by preprocessor */;
   
    map = new GameMap(20, 20, 40);
    tank = new Tank(map);
    map.register(tank);
    
}

public void draw() {
    
    background(255);
    map.display();
    
    
}

public void keyPressed(){
    tank.resume();
}

  
    
 



class GameMap {
    int cols, rows, grid_size;
    Node[][] nodes;
    Node[][] visited;
    Tank tank;
    boolean pause = false;
    Stack<Node> stack = new Stack<>();
    
    ArrayList<GameObject> entities = new ArrayList<>();
    
    GameMap(int c, int r, int size) {
        cols = c;
        rows = r;
        grid_size = size;
       // this.tank = tank;
  
        nodes = new Node[cols][rows];
        init();
        generateObstacles(15);
        
    }

    public void generateObstacles(int amount){
        for(int i = 0; i < amount; i++){

            PVector raw = new PVector((int)random(rows), (int)random(cols));
            int x = (int)raw.x;
            int y = (int)raw.y;
            PVector absolute = gridToMap(raw);
            Obstacle o = new Obstacle(40, 40, absolute);

            nodes[x][y].danger = true;

            register(o);
        }

    }
    
    public void register(GameObject o) {
        entities.add(o);
    }
      
    public void init() {
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                nodes[i][j] = new Node(i, j, grid_size);
            }
        }
    }
    
    public void display() {
        for(GameObject e : entities){
            e.render();
        }

        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                stroke(153, 50);
                if(nodes[i][j].visited){
                    fill(255, 0, 0, 50);
                } else {
                    fill(153, 50);
                }
             
                rect(nodes[i][j].pos.x - 20, nodes[i][j].pos.y - 20, grid_size, grid_size);
                noStroke();
                fill(0, 255, 0, 80);
                ellipse(nodes[i][j].pos.x, nodes[i][j].pos.y, 5.0f, 5.0f);
            }
        }
    }
    
    public PVector lookup(PVector vec) {
        return new PVector(PApplet.parseInt(vec.x / grid_size), PApplet.parseInt(vec.y / grid_size) );
    }

    public PVector gridToMap(PVector vec){

        println(vec); 
        return new PVector(vec.x*grid_size+20, vec.y*grid_size+20);
    }

    public void setVisited(PVector vec){
        PVector raw = lookup(vec);



        if(raw.x > 19){
            raw.x = 19;
        }
        if(raw.y > 19){
            raw.y = 19;
        }
       

     
        
        nodes[PApplet.parseInt(raw.x)][PApplet.parseInt(raw.y)].visited = true;
    }
    
    public void proceed() {
        
        if (!stack.isEmpty()) {
            Node currentNode = stack.peek();
            
            ArrayList<Node> neighbors = getNeighbors(currentNode);
            boolean foundUnvisitedNeighbor = false;
            for (Node neighbor : neighbors) {
                if (!neighbor.visited) {
                    neighbor.visited = true;
                    stack.push(neighbor);
                    foundUnvisitedNeighbor = true;
                    tank.moveTo(neighbor.getMapPosition());
                    break;
                }
            }
            if (!foundUnvisitedNeighbor) {
                stack.pop();
            }
        }
    }
    
    public ArrayList<Node> getNeighbors(Node node) {
        ArrayList<Node> neighbors = new ArrayList<>();
        int x = node.x;
        int y = node.y;
        if (x > 0 && nodes[x - 1][y].visited) {
            neighbors.add(nodes[x - 1][y]);
        }
        if (y > 0 && nodes[x][y - 1].visited) {
            neighbors.add(nodes[x][y - 1]);
        }
        if (x < cols - 1 && !nodes[x + 1][y].visited) {
            neighbors.add(nodes[x + 1][y]);
        }
        if (y < rows - 1 && !nodes[x][y + 1].visited) {
            neighbors.add(nodes[x][y + 1]);
        }
        Collections.shuffle(neighbors);
        return neighbors;
    }
    
    public void runDfs() {
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                nodes[i][j].visited = false;
            }
        }
        Node startNode = nodes[0][0];
        stack.push(startNode);
        proceed();
    }

    // add danger zone!!! if player encountered enemy
    public void rememberDanger(PVector pos){
        PVector raw = lookup(pos);

        int x = PApplet.parseInt(raw.x);
        int y = PApplet.parseInt(raw.y);

        for(int i = x-2; i < x+2; i++){
            for(int j = y-2; j < y+2; j++){
                if(i >= 0 && i < cols && j >= 0 && j < map.rows) {
                    nodes[i][j].visited = true;
                }
            }
            
        }

    }
    
}




class Node {
    int x, y, size;
    PVector pos;
    boolean visited = false;
    boolean occupied = false;
    boolean danger = false;
    
    Node(int _x, int _y, int size) {
        x = _x;
        y = _y;
        pos = new PVector(x * size + (size / 2), y * size + (size / 2));
    }
    
    public PVector getMapPosition() {
        return pos;
    }
    
}
public interface GameObject {
  public PVector getPosition();
  public float getWidth();
  public float getHeight();
  public void render();
}
class Obstacle implements GameObject{
    int width, height;
    PVector position;

    Obstacle(int width, int height, PVector position) {
        this.width = width;
        this.height = height;
        this.position = position;
    }
    
    public void render() {
        stroke(0);
        strokeWeight(2);
        fill(127);
        ellipse(position.x, position.y, width, height);
    }
    
    public PVector getPosition(){
        return position;
    }
    public float getWidth(){
        return width;
    }
    public float getHeight(){
        return height;
    }
    
}


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
    
    public HashMap<PVector, Integer> percept() {
        return sensor.sense(position);
    }
    
    public void executeAction() {
        float prob = 0.01f;
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

    public void rotateTo(PVector to){
        PVector rotate = PVector.sub(to, position);
        heading = rotate.heading();
    }
    
    public PVector getNextPosition() {
        PVector raw = map.lookup(position);
        int stepx = PApplet.parseInt(random(3)) - 1;
        int stepy = PApplet.parseInt(random(3)) - 1;

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
    
    public void moveTo(PVector target) {
        this.target = target;
    }
    
    public void arrive() {

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
    
    public void resume(){
        paused = false;
    }
    
    
    
    public void render() {
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
    
    public void display() {
        stroke(0);
        strokeWeight(2);
        fill(127);
        ellipse(position.x, position.y, 50, 50);
        line(position.x, position.y, position.x + (50*cos(heading)), position.y + (50*sin(heading)));

    }
    
}


  public void settings() { size(800, 800); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_230413a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}