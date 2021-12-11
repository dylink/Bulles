import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;

FloatRange xpos, ypos;
ToxiclibsSupport gfx;

Voronoi voronoi = new Voronoi();
PolygonClipper2D clip;

// switches
boolean doShowPoints = true;
boolean doShowDelaunay;
boolean doShowHelp=false;
boolean doClip;
boolean doSave;

float smallerRadius = 20;

float greaterRadius = 80;


boolean tt=false;

Polygon2D poly;
ArrayList<Bubble> bubblesArr = new ArrayList<Bubble>();

void setup() {
  size(600, 600);
  smooth();
  xpos=new BiasedFloatRange(0, width, width/2, 0.333f);
  ypos=new BiasedFloatRange(0, height, height, 0.5f);
  clip=new SutherlandHodgemanClipper(new Rect(width*0.125, height*0.125, width*0.75, height*0.75));
  gfx = new ToxiclibsSupport(this);
  textFont(createFont("SansSerif", 10));
  poly = new Polygon2D();

  //clip =
  /*  Bounding Box  */
  addBoundingBox();

  /*  Add Random bubble in center  */
  Bubble b = new Bubble(60, new PVector(200, 300), 60);
  Bubble c = new Bubble(20, new PVector(300, 300), 60);
  Bubble d = new Bubble(80, new PVector(240, 300), 60);
  Bubble e = new Bubble(50, new PVector(360, 400), 60);

  bubblesArr.add(b);
  bubblesArr.add(c);
  bubblesArr.add(d);
  bubblesArr.add(e);
  background(255);
}



void draw() {
  randomSeed(0);
  noFill();
  //bubblesArr.get(0).center=new PVector(mouseX, mouseY);
  voronoi = new Voronoi();

  addBoundingBox();
  for(int i=0; i<bubblesArr.size(); i++){
    //bubblesArr.get(i).move();

    stroke(0,255,0);
    voronoi.addPoint(new Vec2D(bubblesArr.get(i).center.x, bubblesArr.get(i).center.y));

    stroke(255,0,0);
    bubblesArr.get(i).drawCircle();
  }

  for(int i=0; i<bubblesArr.size(); i++){
    poly.add(new Vec2D(bubblesArr.get(i).center.x,bubblesArr.get(i).center.y));
  }


  // draw all voronoi polygons, clip them if needed...
/*for (Polygon2D pol : voronoi.getRegions()) {
    if (doClip) {
      //gfx.polygon2D(clip.clipPolygon(poly));
      gfx.polygon2D(clip.clipPolygon(poly));
    }
    else {
      gfx.polygon2D(pol);
    }
  }
  poly = new Polygon2D();*/

  // draw delaunay triangulation
  if (doShowDelaunay) {
    stroke(0, 0, 255, 50);
    beginShape(TRIANGLES);
    for (Triangle2D t : voronoi.getTriangles()) {
      gfx.triangle(t, false);
    }
    endShape();
  }
  // draw original points added to voronoi
  if (doShowPoints) {
    fill(255, 0, 255);
    noStroke();
    for (Vec2D c : voronoi.getSites()) {
      ellipse(c.x, c.y, 5, 5);
    }
  }



}

void keyPressed() {
  switch(key) {
  case ' ':
    doSave = true;
    break;
  case 't':
    doShowDelaunay = !doShowDelaunay;
    break;
  case 'x':
    voronoi = new Voronoi();
    break;
  case 'p':
    doShowPoints = !doShowPoints;
    break;
  case 'c':
    doClip=!doClip;
    break;
  case 'h':
    doShowHelp=!doShowHelp;
    break;
  case 'r':
    for (int i = 0; i < 10; i++) {
      voronoi.addPoint(new Vec2D(xpos.pickRandom(), ypos.pickRandom()));
    }
    break;
  }
}

void addBoundingBox(){
  for(int i=60; i<width; i+=60){
    voronoi.addPoint(new Vec2D(i, 40));
    voronoi.addPoint(new Vec2D(40, i));
    voronoi.addPoint(new Vec2D(width-40, i));
    voronoi.addPoint(new Vec2D(i, height-40));
  }
}

void mousePressed() {
  voronoi.addPoint(new Vec2D(mouseX, mouseY));
}
