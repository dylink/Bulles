ArrayList<Vertices> copyVerticeList(ArrayList<Vertices> b){
  
  ArrayList<Vertices> a = new ArrayList<>();
  for(var v : b){
    Vertices v1 = new Vertices(v.pos.copy(), v.norm.copy());
    a.add(v1);
  }
  
  return a;
}

class Bubble {
  ArrayList<Vertices> vertices;
  ArrayList<Vertices> backUp;
  ArrayList<Edges> edges;
  ArrayList<Integer> undrawableVertices;
  ArrayList<Integer> collideWith;
  float radius;
  float perim;
  float area;
  float nbVertices;
  PVector center;
  float z;
  float z2;
  boolean isColliding;
  
  PVector n;
  int i1, i2;

  Bubble(float r, PVector c, float n) {
    isColliding = false;
    
    z = 0.3;
    z2 = z * 14;
    i1 = 0;
    i2 = 0;
    //n = rad.copy().normalize();
    collideWith = new ArrayList<>();
    radius = r;
    center = c;
    area = PI * r*r;
    nbVertices = n;
    float angle = radians(360/nbVertices);
    PVector rad = new PVector(0, -radius);
    vertices = new ArrayList<>();
    float freq = 10;
    float amp = 5;
    //backUp.addAll(vertices);
    
    edges = new ArrayList<>();
    undrawableVertices = new ArrayList<>();
    for (int i = 0; i<n; i++) {
      float ang = i * angle;
      PVector pos1 = new PVector(center.x+(r+amp*sin(freq*ang))*cos(ang), center.y+(r+amp*sin(freq*ang))*sin(ang));
      PVector pos = rad.copy();
      
      pos.x += center.x;
      pos.y += center.y;
      Vertices v = new Vertices(pos1, rad.copy().normalize());
      vertices.add(v);
      //System.out.println(v.pos + " && " + v.norm);
      rad.rotate(angle);
    }
    for(int i = 0; i < vertices.size(); i++){
      edges.add(new Edges(vertices.get(i), vertices.get((i+1)%vertices.size())));
    }
    backUp = copyVerticeList(vertices);
    /*backUp = new ArrayList<>();
    for(var v : vertices){
      Vertices v1 = new Vertices(v.pos.copy(), v.norm.copy());
      backUp.add(v1);
    }*/
    System.out.println(vertices.size());
  }

  

  void draw(PVector col) {
    //drawableVertices = new ArrayList<>(vertices);
    /*undrawableVertices = new ArrayList<>();
    //System.out.println(i1 + " && " + i2);
    for(int i = i1; i%vertices.size() != i2; i++){
      //System.out.println(i);
      undrawableVertices.add(i%vertices.size());
    }*/
    //System.out.println(undrawableVertices);
    stroke(col.x, col.y, col.z);
    /*int m1 = min(i1, i2);
    int m2 = max(i1, i2);*/
    //drawableVertices.subList(m1, m2).clear();
    //System.out.println(undrawableVertices);
    for (int i = 0; i < vertices.size(); i++) {
      /*Edges e = edges.get(i);
      line(e.v1.pos.x, e.v1.pos.y, e.v2.pos.x, e.v2.pos.y);*/
      //if(i > 10)
      //System.out.println(i + " " + (i+1)%vertices.size());
      if(!undrawableVertices.contains(i)) line(vertices.get(i).pos.x, vertices.get(i).pos.y, vertices.get((i+1)%vertices.size()).pos.x, vertices.get((i+1)%vertices.size()).pos.y);
      /*if((i%vertices.size() >= i1 && i%vertices.size() < i2)){
        //System.out.println(i + " && " + i1 + " && " + i2);
        line(vertices.get(i).pos.x, vertices.get(i).pos.y, vertices.get((i+1)%vertices.size()).pos.x, vertices.get((i+1)%vertices.size()).pos.y);
      }*/
      /*if ((i >= m1 && i < m2) ^ (m2 - m1 > vertices.size()/2)) {
        continue;
      } 
      else {
        line(vertices.get(i).pos.x, vertices.get(i).pos.y, vertices.get((i+1)%vertices.size()).pos.x, vertices.get((i+1)%vertices.size()).pos.y);
      }*/
    }
    strokeWeight(4);
    point(center.x, center.y);
    strokeWeight(1);
  }

  void drawNormals() {
    for (int i = 0; i < vertices.size(); i++) {
      stroke(255, 0, 0);
      line(vertices.get(i).pos.x, vertices.get(i).pos.y, vertices.get(i).pos.x+vertices.get(i).norm.x*10, vertices.get(i).pos.y+vertices.get(i).norm.y*10);
      stroke(0);
    }
  }

  boolean betweenNumber(float a, float b, float value) {
    if (a>b) {
      float temp = a;
      a = b;
      b = temp;
    }
    if (a<=value && value<=b)
      return true;
    return false;
  }

  void waves() {

    float x = random(-10, 10);
    for (int i = 0; i<vertices.size()-1; i++) {

      //vertices.get(i).vit = vertices.get(i).norm.copy().mult(x);
      //vertices.get(i).pos.add(vertices.get(i).vit);
      //vertices.get(i).pos.x *= cos(i);
      //vertices.get(i).pos.y *= sin(i);
    }
  }

  void detectCollision(Bubble b) {
    undrawableVertices = new ArrayList<>();
    //System.out.println(i1 + " && " + i2);
    
    PVector pt1, pt2;
    i1 = 0;
    i2 = 0;
    b.i1 = 0;
    b.i2 = 0;
    float r, R, d, dx, dy, cx, cy, Cx, Cy;
    if (radius < b.radius) {
      r  = radius;
      R = b.radius;
      cx = center.x;
      cy = center.y;
      Cx = b.center.x;
      Cy = b.center.y;
    } else {
      r  = b.radius;
      R  = radius;
      Cx = center.x;
      Cy = center.y;
      cx = b.center.x;
      cy = b.center.y;
    }

    d = PVector.sub(center, b.center).mag();

    if (d < abs(radius+b.radius)) {
      isColliding = true;
      dx = cx - Cx;
      dy = cy - Cy;
      float x = (dx / d) * R + Cx;
      float y = (dy / d) * R + Cy;
      PVector P = new PVector(x, y);
      PVector C = new PVector(Cx, Cy);
      float angle = acos((r*r-d*d-R*R)/(-2.0*d*R));
      pt1 = rotatePoint(C, P, +angle);
      pt2 = rotatePoint(C, P, -angle);
      PVector c = PVector.sub(pt2, pt1);
      c.div(2);
      c.add(pt1);
      PVector n = PVector.sub(c, b.center).normalize();
      float pressure = (radius - b.radius)*0.6;
      //bezier(pt1.x, pt1.y, c.x+(n.x*pressure), c.y+(n.y*pressure), c.x+(n.x*pressure), c.y+(n.y*pressure), pt2.x, pt2.y);
      //line(pt1.x, pt1.y, pt2.x, pt2.y);
      float minDist1 = 10000;
      float minDist2 = 10000;
      float bminDist1 = 10000;
      float bminDist2 = 10000;
      for (int i = 0; i < vertices.size(); i++) {
        if (minDist1 > pt1.dist(vertices.get(i).pos)) {
          minDist1 = pt1.dist(vertices.get(i).pos);
          i1 = i;
        }
        if (minDist2 > pt2.dist(vertices.get(i).pos)) {
          minDist2 = pt2.dist(vertices.get(i).pos);
          i2 = i;
        }
      }
      
      for (int i = 0; i < b.vertices.size(); i++) {
        if (bminDist1 > pt2.dist(b.vertices.get(i).pos)) {
          bminDist1 = pt2.dist(b.vertices.get(i).pos);
          b.i1 = i;
        }
        if (bminDist2 > pt1.dist(b.vertices.get(i).pos)) {
          bminDist2 = pt1.dist(b.vertices.get(i).pos);
          b.i2 = i;
        }
      }
      
      for(int i = i1; i%vertices.size() != i2; i++){
        //System.out.println(i);
        undrawableVertices.add(i%vertices.size());
      }
      for(int i = b.i1; i%b.vertices.size() != b.i2; i++){
        undrawableVertices.add(i%b.vertices.size());
      }
      //System.out.println(b.i1 + " && " + b.i2);
      if(b.center.y <= center.y + 60) b.z = 0;
      else b.z = z2;
    }
    else{
      isColliding = false;
    }
  }

  PVector rotatePoint(PVector fp, PVector pt, float a) {
    float x = pt.x - fp.x;
    float y = pt.y - fp.y;
    float xRot = (float)(x * Math.cos(a) + y * Math.sin(a));
    float yRot = (float)(y * Math.cos(a) - x * Math.sin(a));
    return new PVector(fp.x+xRot, fp.y+yRot);
  }

  void move(PVector m){
    //System.out.println(backUp.size());
    PVector temp = center;
    center = m;
    for(int i = 0; i < vertices.size(); i++){
      //vertices.get(i).pos = PVector.add(PVector.sub(center, temp),backUp.get(i).pos);
      backUp.get(i).pos.add(PVector.sub(center, temp));
      vertices.get(i).pos.add(PVector.sub(center, temp));
    }
    System.out.println(vertices.get(5).pos + "  " + backUp.get(5).pos);
  }
  
  void merge(){
    
  }
  
  void update() {
    vertices.clear();
    float angle = radians(360/nbVertices);
    PVector rad = new PVector(0, radius);
    vertices = new ArrayList<>();
    for (int i = 0; i<nbVertices; i++) {
      PVector pos = rad.copy();
      pos.x += center.x;
      pos.y += center.y;
      Vertices v = new Vertices(pos, rad.copy().normalize());
      vertices.add(v);
      rad.rotate(angle);
    }
  }
}
