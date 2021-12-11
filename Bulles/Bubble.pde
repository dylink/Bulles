class Bubble {

  PVector center;
  float radius;
  float rad=1;
  PVector pos = new PVector(0,0);
  float nbVertices;
  PVector positionToGo = new PVector(0,0);
  ArrayList<Vertices> vertices;

  ArrayList<Vertices> v1;
  ArrayList<Vertices> v2;
  ArrayList<Vertices> v3;
  ArrayList<Vertices> v4;
  ArrayList<Vertices> v5;
  ArrayList<Vertices> v6;
  ArrayList<Vertices> v7;
  ArrayList<Vertices> v8;

  ArrayList<ArrayList<Vertices>> hideVertices;
  ArrayList<Vertices> fromVertices;
  float alive = 1;
  color myColor;

  boolean over = false;

  Bubble(float r, PVector c, float n) {
    radius = r;
    center = c;
    nbVertices = n;
    myColor = color(center.x/2,0,center.y/2);
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

        if(inScreen(x0 + x, y0 + y)) if(pxlIsWhite(x0 + x, y0 + y)) {point(x0 + x, y0 + y); ret=1;v4.add(new Vertices(new PVector(x0 + x, y0 + y), n));}
        if(inScreen(x0 + x, y0 - y)) if(pxlIsWhite(x0 + x, y0 - y)) {point(x0 + x, y0 - y); ret=1;v1.add(new Vertices(new PVector(x0 + x, y0 - y), n));}
        if(inScreen(x0 - x, y0 + y)) if(pxlIsWhite(x0 - x, y0 + y)) {point(x0 - x, y0 + y); ret=1;v5.add(new Vertices(new PVector(x0 - x, y0 + y), n));}
        if(inScreen(x0 - x, y0 - y)) if(pxlIsWhite(x0 - x, y0 - y)) {point(x0 - x, y0 - y); ret=1;v8.add(new Vertices(new PVector(x0 - x, y0 - y), n));}
        if(inScreen(x0 + y, y0 + x)) if(pxlIsWhite(x0 + y, y0 + x)) {point(x0 + y, y0 + x); ret=1;v3.add(new Vertices(new PVector(x0 + y, y0 + x), n));}
        if(inScreen(x0 + y, y0 - x)) if(pxlIsWhite(x0 + y, y0 - x)) {point(x0 + y, y0 - x); ret=1;v2.add(new Vertices(new PVector(x0 + y, y0 - x), n));}
        if(inScreen(x0 - y, y0 + x)) if(pxlIsWhite(x0 - y, y0 + x)) {point(x0 - y, y0 + x); ret=1;v6.add(new Vertices(new PVector(x0 - y, y0 + x), n));}
        if(inScreen(x0 - y, y0 - x)) if(pxlIsWhite(x0 - y, y0 - x)) {point(x0 - y, y0 - x); ret=1;v7.add(new Vertices(new PVector(x0 - y, y0 - x), n));}
        if(del < 0){ del += incH;}
      else{
          y--;
          if(inScreen(x0 + x, y0 + y)) if(pxlIsWhite(x0 + x, y0 + y)) {point(x0 + x, y0 + y); ret=1;v4.add(new Vertices(new PVector(x0 + x, y0 + y), n));}
          if(inScreen(x0 + x, y0 - y)) if(pxlIsWhite(x0 + x, y0 - y)) {point(x0 + x, y0 - y); ret=1;v1.add(new Vertices(new PVector(x0 + x, y0 - y), n));}
          if(inScreen(x0 - x, y0 + y)) if(pxlIsWhite(x0 - x, y0 + y)) {point(x0 - x, y0 + y); ret=1;v5.add(new Vertices(new PVector(x0 - x, y0 + y), n));}
          if(inScreen(x0 - x, y0 - y)) if(pxlIsWhite(x0 - x, y0 - y)) {point(x0 - x, y0 - y); ret=1;v8.add(new Vertices(new PVector(x0 - x, y0 - y), n));}
          if(inScreen(x0 + y, y0 + x)) if(pxlIsWhite(x0 + y, y0 + x)) {point(x0 + y, y0 + x); ret=1;v3.add(new Vertices(new PVector(x0 + y, y0 + x), n));}
          if(inScreen(x0 + y, y0 - x)) if(pxlIsWhite(x0 + y, y0 - x)) {point(x0 + y, y0 - x); ret=1;v2.add(new Vertices(new PVector(x0 + y, y0 - x), n));}
          if(inScreen(x0 - y, y0 + x)) if(pxlIsWhite(x0 - y, y0 + x)) {point(x0 - y, y0 + x); ret=1;v6.add(new Vertices(new PVector(x0 - y, y0 + x), n));}
          if(inScreen(x0 - y, y0 - x)) if(pxlIsWhite(x0 - y, y0 - x)) {point(x0 - y, y0 - x); ret=1;v7.add(new Vertices(new PVector(x0 - y, y0 - x), n));}
          incO += 4;
          del += incO;
        }
      }
    return ret;
  }

   boolean inScreen(float x, float y){
    if(0<=x && x<=width && 0<=y && y<=height){
      return true;
    }
    return false;
  }

  boolean pxlIsWhite(float x, float y){
    color white = color(255,255,255);
    color c = get((int)x,(int)y);
    if( radius==50)
    System.out.println(hex(c));
    if( c == white || c == myColor){
      return true;
    }
    return false;
  }

  void drawCircle(){ //diagrow
    stroke(center.x/2,0,center.y/2);
    if(rad<=radius-1){
      v1 = new ArrayList<>();
      v2 = new ArrayList<>();
      v3 = new ArrayList<>();
      v4 = new ArrayList<>();
      v5 = new ArrayList<>();
      v6 = new ArrayList<>();
      v7 = new ArrayList<>();
      v8 = new ArrayList<>();
     circleNom(pos, (int)rad);

     Collections.reverse(v2);
     Collections.reverse(v4);
     Collections.reverse(v6);
     Collections.reverse(v8);

     v1.addAll(v2);
     v1.addAll(v3);
     v1.addAll(v4);
     v1.addAll(v5);
     v1.addAll(v6);
     v1.addAll(v7);
     v1.addAll(v8);
     rad++;

    }else{
        stroke(0,0,0);
        alive = 0;
        for(int i=0; i<v1.size(); i++){
         //point(vertices.get(i).pos.x,vertices.get(i).pos.y);
           line(v1.get(i).pos.x, v1.get(i).pos.y, v1.get((i+1)%v1.size()).pos.x, v1.get((i+1)%v1.size()).pos.y);
        }
        over = true;
        //circle(pos.x,pos.y,radius*2);
      }

  }


}
