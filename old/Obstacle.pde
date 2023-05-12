class Obstacle implements GameObject{
    int width, height;
    PVector position;

    Obstacle(int width, int height, PVector position) {
        this.width = width;
        this.height = height;
        this.position = position;
    }
    
    void render() {
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