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
  float damp = 0.95;
  
  PVector n;
  int i1, i2;

  Bubble(float r, PVector c, float n) {
    isColliding = false;
    z = 0.3;
    z2 = z * 14;
    i1 = 0;
    i2 = 0;
    collideWith = new ArrayList<>();
    radius = r;
    center = c;
    area = PI * r*r;
    nbVertices = n;
    float angle = radians(360/nbVertices);
    PVector rad = new PVector(0, -radius);
    vertices = new ArrayList<>();
    
    edges = new ArrayList<>();
    undrawableVertices = new ArrayList<>();
    for (int i = 0; i<n; i++) {
      PVector pos = rad.copy();
      
      pos.x += center.x;
      pos.y += center.y;
      
      Vertices v = new Vertices(pos, rad.copy().normalize());
      vertices.add(v);
      rad.rotate(angle);
    }
    for(int i = 0; i < vertices.size()-1; i++){
      edges.add(new Edges(vertices.get(i), vertices.get((i+1)%vertices.size())));
    }
    backUp = copyVerticeList(vertices);
  }

  

  void draw(PVector col) {
    for (int i = 0; i < vertices.size(); i++) {
      if(!undrawableVertices.contains(i)) line(vertices.get(i).pos.x, vertices.get(i).pos.y, vertices.get((i+1)%vertices.size()).pos.x, vertices.get((i+1)%vertices.size()).pos.y);
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

  void waves(float t) {
    for (int i = 0; i<vertices.size(); i++) {
      if(!vertices.get(i).constrained){
        int index = i-1;
        if(i==0) index = vertices.size()-1;
        float d0 = (vertices.get(index).pos.dist(center) - radius);
        float d1 = (vertices.get(i).pos.dist(center) - radius);
        float d2 = (vertices.get((i+1)%vertices.size()).pos.dist(center) - radius);
        float da = ((d0+d2)/2)-d1;
        vertices.get(i).vit.add(PVector.mult(vertices.get(i).norm, da));
      }
    }
    for(int i = 0; i<vertices.size();i++){
      if(!vertices.get(i).constrained){
        vertices.get(i).pos.add(vertices.get(i).vit);
        Vertices v = vertices.get(i);
        Vertices v2 = backUp.get(i);
        PVector p = PVector.sub(v.pos, v2.pos);
        vertices.get(i).vit.sub(PVector.mult(p,0.01));
        vertices.get(i).vit.mult(damp);
      }
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
    PVector temp = center;
    center = m;
    for(int i = 0; i < vertices.size(); i++){
      backUp.get(i).pos.add(PVector.sub(center, temp));
      vertices.get(i).pos.add(PVector.sub(center, temp));
    }
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
