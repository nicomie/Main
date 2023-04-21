import java.util.Collections;
import java.util.Stack;
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

    void generateObstacles(int amount){
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
    
    void register(GameObject o) {
        entities.add(o);
    }
      
    void init() {
        for (int i = 0; i < cols; i++) {
            for (int j = 0; j < rows; j++) {
                nodes[i][j] = new Node(i, j, grid_size);
            }
        }
    }
    
    void display() {
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
                ellipse(nodes[i][j].pos.x, nodes[i][j].pos.y, 5.0, 5.0);
            }
        }
    }
    
    public PVector lookup(PVector vec) {
        return new PVector(int(vec.x / grid_size), int(vec.y / grid_size) );
    }

    public PVector gridToMap(PVector vec){

        println(vec); 
        return new PVector(vec.x*grid_size+20, vec.y*grid_size+20);
    }

    void setVisited(PVector vec){
        PVector raw = lookup(vec);



        if(raw.x > 19){
            raw.x = 19;
        }
        if(raw.y > 19){
            raw.y = 19;
        }
       

     
        
        nodes[int(raw.x)][int(raw.y)].visited = true;
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
    void rememberDanger(PVector pos){
        PVector raw = lookup(pos);

        int x = int(raw.x);
        int y = int(raw.y);

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
