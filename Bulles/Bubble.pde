class Bubble {

  PVector center;
  float radius;
  float rad=1;
  PVector pos = new PVector(0,0);
  float nbVertices;
  PVector positionToGo = new PVector(0,0);
  ArrayList<Vertices> vertices;
  ArrayList<ArrayList<Vertices>> hideVertices;
  ArrayList<Vertices> fromVertices;
  float alive = 1;

  Bubble(float r, PVector c, float n) {
    radius = r;
    center = c;
    nbVertices = n;
    pos=c;
    positionToGo.x = xpos.pickRandom();
    positionToGo.y = ypos.pickRandom();
  }

  void move(){
    if(floor(center.x) == floor(positionToGo.x)){
      positionToGo.x = xpos.pickRandom();
      positionToGo.y = ypos.pickRandom();
    }else{
      center.x = center.x <= positionToGo.x? center.x+0.5 : center.x-0.5;
      center.y = center.y <= positionToGo.y? center.y+0.5 : center.y-0.5;
    }
  }

  int circleNom(PVector p, int r){
    int ret=0;
    int x0 =(int)pos.x, y0=(int)pos.y;
    int x, y, del, incH, incO;
    float t = 1/sqrt(2) * r + 1;
    del = 3 - (r << 1);
    incH = 6;
    incO = 10 - (r << 2);
    PVector n = new PVector(0,0);
      for(x = 0, y = r; x <= t; x++, incH += 4, incO += 4) {
        if(inScreen(x0 + x, y0 + y)) if(pxlIsWhite(x0 + x, y0 + y)) {point(x0 + x, y0 + y); ret=1;vertices.add(new Vertices(new PVector(x0 + x, y0 + y), n));}
        if(inScreen(x0 + x, y0 - y)) if(pxlIsWhite(x0 + x, y0 - y)) {point(x0 + x, y0 - y); ret=1;vertices.add(new Vertices(new PVector(x0 + x, y0 - y), n));}
        if(inScreen(x0 - x, y0 + y)) if(pxlIsWhite(x0 - x, y0 + y)) {point(x0 - x, y0 + y); ret=1;vertices.add(new Vertices(new PVector(x0 - x, y0 + y), n));}
        if(inScreen(x0 - x, y0 - y)) if(pxlIsWhite(x0 - x, y0 - y)) {point(x0 - x, y0 - y); ret=1;vertices.add(new Vertices(new PVector(x0 - x, y0 - y), n));}
        if(inScreen(x0 + y, y0 + x)) if(pxlIsWhite(x0 + y, y0 + x)) {point(x0 + y, y0 + x); ret=1;vertices.add(new Vertices(new PVector(x0 + y, y0 + x), n));}
        if(inScreen(x0 + y, y0 - x)) if(pxlIsWhite(x0 + y, y0 - x)) {point(x0 + y, y0 - x); ret=1;vertices.add(new Vertices(new PVector(x0 + y, y0 - x), n));}
        if(inScreen(x0 - y, y0 + x)) if(pxlIsWhite(x0 - y, y0 + x)) {point(x0 - y, y0 + x); ret=1;vertices.add(new Vertices(new PVector(x0 - y, y0 + x), n));}
        if(inScreen(x0 - y, y0 - x)) if(pxlIsWhite(x0 - y, y0 - x)) {point(x0 - y, y0 - x); ret=1;vertices.add(new Vertices(new PVector(x0 - y, y0 - x), n));}
        if(del < 0){ del += incH;}
      else{
          y--;
          if(inScreen(x0 + x, y0 + y)) if(pxlIsWhite(x0 + x, y0 + y)) {point(x0 + x, y0 + y); ret=1;vertices.add(new Vertices(new PVector(x0 + x, y0 + y), n));}
          if(inScreen(x0 + x, y0 - y)) if(pxlIsWhite(x0 + x, y0 - y)) {point(x0 + x, y0 - y); ret=1;vertices.add(new Vertices(new PVector(x0 + x, y0 - y), n));}
          if(inScreen(x0 - x, y0 + y)) if(pxlIsWhite(x0 - x, y0 + y)) {point(x0 - x, y0 + y); ret=1;vertices.add(new Vertices(new PVector(x0 - x, y0 + y), n));}
          if(inScreen(x0 - x, y0 - y)) if(pxlIsWhite(x0 - x, y0 - y)) {point(x0 - x, y0 - y); ret=1;vertices.add(new Vertices(new PVector(x0 - x, y0 - y), n));}
          if(inScreen(x0 + y, y0 + x)) if(pxlIsWhite(x0 + y, y0 + x)) {point(x0 + y, y0 + x); ret=1;vertices.add(new Vertices(new PVector(x0 + y, y0 + x), n));}
          if(inScreen(x0 + y, y0 - x)) if(pxlIsWhite(x0 + y, y0 - x)) {point(x0 + y, y0 - x); ret=1;vertices.add(new Vertices(new PVector(x0 + y, y0 - x), n));}
          if(inScreen(x0 - y, y0 + x)) if(pxlIsWhite(x0 - y, y0 + x)) {point(x0 - y, y0 + x); ret=1;vertices.add(new Vertices(new PVector(x0 - y, y0 + x), n));}
          if(inScreen(x0 - y, y0 - x)) if(pxlIsWhite(x0 - y, y0 - x)) {point(x0 - y, y0 - x); ret=1;vertices.add(new Vertices(new PVector(x0 - y, y0 - x), n));}
          incO += 4;
          del += incO;
        }
      }
    return ret;
  }

   boolean inScreen(int x, int y){
    if(0<=x && x<=width && 0<=y && y<=height){
      return true;
    }
    return false;
  }

  boolean pxlIsWhite(int x, int y){
    color white = color(255,255,255);
    color c = get(x,y);
    if( c == white){
      return true;
    }
    return false;
  }

  void drawCircle(){ //diagrow
    stroke(center.x/2,0,center.y/2);
    if(rad<=radius){
      vertices = new ArrayList<>();
      circleNom(pos, (int)rad);
      rad+= radius/greaterRadius;
      if(radius==50)
        System.out.println(rad);
    }else{
        alive = 0;
        System.out.println("end "+radius );
        strokeWeight(3);
         stroke(0,0,0);
        for(int i=0; i<vertices.size(); i++){
          point(vertices.get(i).pos.x,vertices.get(i).pos.y);
         //  line(vertices.get(i).pos.x, vertices.get(i).pos.y, vertices.get((i+1)%vertices.size()).pos.x, vertices.get((i+1)%vertices.size()).pos.y);

        }
        //circle(pos.x,pos.y,radius*2);
      }

  }


}
