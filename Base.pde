// Created by Nicholas Miettinen

class Base{
    int x;
    int y;
    int w;
    int h;
    color c;
    
    Base(int x, int y, int w, int h, color c) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.c = c;
    }
    
    void render() {
        fill(c);
        rect(x, y, w, h);
    }
    
}