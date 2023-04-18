import java.util.Collections;
import java.util.Stack;
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
 
 void init() {
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
 
 void display() {
    for (int i = 0; i < cols; i++){
      for(int j = 0; j < rows; j++) {
        stroke(153, 50);
        fill(153, 50);
        rect(nodes[i][j].pos.x-20, nodes[i][j].pos.y-20, grid_size, grid_size);
        noStroke();
        fill(0, 255, 0, 80);
        ellipse(nodes[i][j].pos.x, nodes[i][j].pos.y, 5.0, 5.0);
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
 