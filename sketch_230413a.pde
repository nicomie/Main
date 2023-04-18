
Tank tank;
Grid grid;
GameLogic gl;

void setup() {
   size(800, 800);

   gl = new GameLogic(grid);

   grid = new Grid(20, 20, 40);
   tank = new Tank(grid, gl);

   grid.runDfs();
   
}

void draw() {

  draw_map();

  tank.update();
  grid.display();


}

void draw_map() {
   background(255);
  
   fill(255, 0, 0);
   rect(0, 0, 150, 350);
 
   fill(0, 0, 255);
   rect(width-151, height-351, 150, 350);
}
