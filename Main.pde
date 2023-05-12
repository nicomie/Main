// Created by Nicholas Miettinen

import java.util.ArrayList;
import java.util.List;

Tank tank;
Game_map map;

PVector start1;
PVector start2;
PVector start3;
Base base1;

PVector start4;
PVector start5;
PVector start6;
Base base2;

Team team1, team2;
color team1_color = color(255, 0 , 0);
color team2_color = color(0, 0, 255);

public SoundManager sm = new SoundManager();

void setup() {
    frameRate(60);
    size(800, 800);
    start1 = new PVector(50, 50);
    start2 = new PVector(50, 150);
    start3 = new PVector(50, 250);
    
    start4 = new PVector(height - 50, width - 250);
    start5 = new PVector(height - 50, width - 150);
    start6 = new PVector(height - 50, width - 50);
    
    base1 = new Base(0, 0, 150, 350, color(255, 0 ,0, 50));
    base2 = new Base(width - 151, height - 351, 150, 350, color(0,0,255,50));
    
    
    map = new Game_map();
    team1 = new Team(new ArrayList<>(List.of(start1, start2, start3)), map, base1, team1_color, 0);
    team2 = new Team(new ArrayList<>(List.of(start4, start5, start6)), map, base2, team2_color, 0);
    
}

void draw() {    
    background(255);
    team1.render();
    team2.render();
    
}






