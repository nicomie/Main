/* autogenerated by Processing revision 1292 on 2023-04-18 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.Collections;
import java.util.Stack;

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
Grid grid;
GameLogic gl;

public void setup() {
   /* size commented out by preprocessor */;

   gl = new GameLogic(grid);

   grid = new Grid(20, 20, 40);
   tank = new Tank(grid, gl);

   grid.runDfs();
   
}

public void draw() {

  draw_map();

  tank.update();
  grid.display();


}

public void draw_map() {
   background(255);
  
   fill(255, 0, 0);
   rect(0, 0, 150, 350);
 
   fill(0, 0, 255);
   rect(width-151, height-351, 150, 350);
}
class FleeState extends State {
 Tank agent;
 
 FleeState(Tank tank) {
  agent = tank; 
 }
 
 public void Execute() {

 }
 
}
class GameLogic {
    Grid map;
    ArrayList<GameObject> entities = new ArrayList<>();;

    GameLogic(Grid _map) {
        map = _map;
    }

    public void registerEntity(GameObject o){
        entities.add(o);
    }


  
} 
public interface GameObject {
  public PVector getPosition();
  public float getWidth();
  public float getHeight();
}


class Grid {
int cols, rows, grid_size;
Node[][] nodes;
Node[][] visited;
Tank tank;
boolean pause = false;
Stack<Node> stack = new Stack<>();

 Grid(int c, int r, int size) {
  cols = c;
  rows = r;
  grid_size = size;
  this.tank = tank;
  
  nodes = new Node[cols][rows];

  init();
  
 }

  public void proceed(){

    while (!stack.isEmpty()) {
        Node currentNode = stack.peek();
      
        ArrayList<Node> neighbors = getNeighbors(currentNode);
        boolean foundUnvisitedNeighbor = false;
        for (Node neighbor : neighbors) {
            if (!neighbor.visited) {
                neighbor.visited = true;
                stack.push(neighbor);
                foundUnvisitedNeighbor = true;
                tank.moveTo(currentNode.getMapPosition());
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
    if (x > 0 && !nodes[x-1][y].visited) {
        neighbors.add(nodes[x-1][y]);
    }
    if (y > 0 && !nodes[x][y-1].visited) {
        neighbors.add(nodes[x][y-1]);
    }
    if (x < cols-1 && !nodes[x+1][y].visited) {
        neighbors.add(nodes[x+1][y]);
    }
    if (y < rows-1 && !nodes[x][y+1].visited) {
        neighbors.add(nodes[x][y+1]);
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
 
 public void init() {
   for (int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++) {
     nodes[i][j] = new Node(i, j, grid_size);
    }
   }
 }

 
 // Get center position of closest grid-node
 public PVector adjust(PVector vec) {
  return new PVector(); 
 }
 
 public void display() {
    for (int i = 0; i < cols; i++){
      for(int j = 0; j < rows; j++) {
        stroke(153, 50);
        fill(153, 50);
        rect(nodes[i][j].pos.x-20, nodes[i][j].pos.y-20, grid_size, grid_size);
        noStroke();
        fill(0, 255, 0, 80);
        ellipse(nodes[i][j].pos.x, nodes[i][j].pos.y, 5.0f, 5.0f);
      }
   }
 }

}

 
 class Node {
   int x, y, size;
   PVector pos;
   boolean visited = false;
   
   Node(int _x, int _y, int size) {
     x = _x;
     y = _y;
     pos = new PVector(x*size+(size/2), y*size+(size/2));
   }

   public PVector getMapPosition(){
    return pos;
   }

 }
 
class PatrolState extends State {
 
  Tank agent;
  
  PatrolState(Tank tank) {
   agent = tank; 
  }
  
  public void Execute() {
    

  }
  
}
public abstract class State {
 public abstract void Execute(); 
}
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

  public void moveTo(PVector target){
    this.target = target;
  }

  public void arrive() {
        PVector desired = PVector.sub(target, position);
        float d = desired.mag();
        desired.normalize();
        if(d < 0) {
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

 
  
  public void rotate(float rad) {
     
  }
  
  public float evaluateUtility() {
    return 0.0f;
  }
  
  public void planAction() {
   // evaluate utility and plan action 
  }
  
  public void setState(State state) {
   currentState = state; 
  }


  public void update() {
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

  public void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(position.x, position.y, 50, 50);
    line(position.x, position.y, position.x + 100, position.y);
  }

  public void checkEdges() {

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
