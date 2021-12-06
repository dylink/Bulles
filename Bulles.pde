
boolean normals = false;
ArrayList<Bubble> bubblesArr = new ArrayList<Bubble>();
ArrayList<Vertices> verticesArr = new ArrayList<>();
PVector clr = new PVector(0, 0, 0);
float t = 0.5;


void setup() {
  size(600, 600, P3D);
  randomSeed(second());
  Bubble b = new Bubble(60, new PVector(200, 300), 60);
  Bubble c = new Bubble(80, new PVector(300, 300), 60);
  Bubble d = new Bubble(60, new PVector(240, 300), 60);
  Bubble e = new Bubble(80, new PVector(360, 400), 60);

  bubblesArr.add(b);
  
  //bubblesArr.add(c);
  
  /*for(int i = 0; i < bubblesArr.get(1).vertices.size(); i++){
    Vertices v = bubblesArr.get(1).vertices.get(i);
    PVector p = PVector.mult(v.norm, random(-20, 20));
    if(verticesArr.size() > 0){
      float dis = verticesArr.get(i-1).pos.dist(bubblesArr.get(1).vertices.get(i-1).pos);
      //dis += 2;
      p = PVector.mult(v.norm, random(dis-2, dis+2));
    }
    verticesArr.add(new Vertices(PVector.add(p, v.pos), v.norm));
  }*/
  //bubblesArr.add(d);
  //bubblesArr.add(e);
  
}

PVector rotatePoint(PVector fp, PVector pt, float a) {
  float x = pt.x - fp.x;
  float y = pt.y - fp.y;
  float xRot = (float)(x * Math.cos(a) + y * Math.sin(a));
  float yRot = (float)(y * Math.cos(a) - x * Math.sin(a));
  return new PVector(fp.x+xRot, fp.y+yRot);
}

void handleCollisions() {
  
  for(var b : bubblesArr){
    b.undrawableVertices.clear();
  }
  for (int h = 0; h < bubblesArr.size(); h++) {
    Bubble b1 = bubblesArr.get(h);
    b1.vertices = copyVerticeList(b1.backUp);
    //copyVerticesList(b1.vertices, b1.backUp);
    int h1 = b1.hashCode();
    for (int j = h+1; j < bubblesArr.size(); j++) {
      Bubble b2 = bubblesArr.get(j);
      int h2 = b2.hashCode();
      PVector pt1, pt2;
      int i1 = 0;
      int i2 = 0;
      int j1 = 0;
      int j2 = 0;
      float r, R, d, dx, dy, cx, cy, Cx, Cy;
      if (b1.radius < b2.radius) {
        r  = b1.radius;
        R = b2.radius;
        cx = b1.center.x;
        cy = b1.center.y;
        Cx = b2.center.x;
        Cy = b2.center.y;
      } else {
        r  = b2.radius;
        R  = b1.radius;
        Cx = b1.center.x;
        Cy = b1.center.y;
        cx = b2.center.x;
        cy = b2.center.y;
      }

      d = PVector.sub(b1.center, b2.center).mag();
      PVector s = PVector.sub(b1.center, b2.center);
      s.div(3);
      
      PVector s1 = PVector.add(b2.center, s);
      
      strokeWeight(3);
      //point(s1.x, s1.y);
      strokeWeight(1);
      //System.out.println(b1.center.dist(b2.center));
      if (d < abs(b1.radius+b2.radius)) {
        /*if(b1.center.dist(b2.center) <= R){
          t = 0;
          b2.radius += b2.radius - b1.radius;
          bubblesArr.remove(0);
          b2.move(s1);
        }*/
        if(!b1.collideWith.contains(h2) && !b2.collideWith.contains(h1)){
          b1.collideWith.add(h2);
          b2.collideWith.add(h1);
        }
        //System.out.println("Oui && " + h + " && " + j);
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
        PVector n = PVector.sub(c, b2.center).normalize();
        float pressure = (b1.radius - b2.radius)*r*0.01;
        /*if(b1.collideWith.size() < 3)*/ 
        //line(pt1.x, pt1.y, pt2.x, pt2.y);
        float minDist1 = 10000;
        float minDist2 = 10000;
        float bminDist1 = 10000;
        float bminDist2 = 10000;
        for (int i = 0; i < b1.vertices.size(); i++) {
          if (minDist1 > pt1.dist(b1.vertices.get(i).pos)) {
            minDist1 = pt1.dist(b1.vertices.get(i).pos);
            i1 = i;
          }
          if (minDist2 > pt2.dist(b1.vertices.get(i).pos)) {
            minDist2 = pt2.dist(b1.vertices.get(i).pos);
            i2 = i;
          }
        }

        for (int i = 0; i < b2.vertices.size(); i++) {
          if (bminDist1 > pt1.dist(b2.vertices.get(i).pos)) {
            bminDist1 = pt1.dist(b2.vertices.get(i).pos);
            j1 = i;
          }
          if (bminDist2 > pt2.dist(b2.vertices.get(i).pos)) {
            bminDist2 = pt2.dist(b2.vertices.get(i).pos);
            j2 = i;
          }
        }

        int temp1 = i1;
        int temp2 = j1;
        i1 = abs(i1 - i2) > b1.vertices.size()/2 ? max(i1, i2) : min(i1, i2);
        i2 = abs(temp1 - i2) > b1.vertices.size()/2 ? min(temp1, i2) : max(temp1, i2);
        j1 = abs(j1 - j2) > b1.vertices.size()/2 ? max(j1, j2) : min(j1, j2);
        j2 = abs(temp2 - j2) > b1.vertices.size()/2 ? min(temp2, j2) : max(temp2, j2);

        /*if(abs(i1 - i2) > b1.vertices.size()/2){
          int temp = i1;
          i1 = max(i1, i2);
          i2 = min(i2, temp);    
        }
        else{
          int temp = i1;
          i1 = min(i1, i2);
          i2 = max(i2, temp);    
        }*/
        int steps = 0;
        //System.out.println(i1 + " && " + i2);
        for (int i = i1; i%b1.vertices.size() != i2; i++) {
          steps++;
          //System.out.println(i);
          //vert.add(i%b1.vertices.size());
          //b1.undrawableVertices.add(i%b1.vertices.size());
        }
        int aa = 0;
        for (int i = i1; i%b1.vertices.size() != i2; i++) {
          //System.out.println(i);
          float t = aa / float(steps);
          float x1 = bezierPoint(pt2.x, c.x+(n.x*pressure), c.x+(n.x*pressure), pt1.x, t);
          float y1 = bezierPoint(pt2.y, c.y+(n.y*pressure), c.y+(n.y*pressure), pt1.y, t);
          b1.vertices.get(i%b1.vertices.size()).pos.x = x1;
          b1.vertices.get(i%b1.vertices.size()).pos.y = y1;
          aa++;
        }
        for (int i = j1; i%b2.vertices.size() != j2; i++) {
          b2.undrawableVertices.add(i%b2.vertices.size());
        }
        
        //System.out.println(b.i1 + " && " + b.i2);
        /*if (b.center.y <= b1.center.y + 60) b1.z = 0;
        else b1.z = z2;*/
        //bezier(pt1.x, pt1.y, c.x+(n.x*pressure), c.y+(n.y*pressure), c.x+(n.x*pressure), c.y+(n.y*pressure), pt2.x, pt2.y);
        /*int steps = b1.undrawableVertices.size();
        for (int i = 0; i <= steps; i++) {
          float t = i / float(steps);
          float x1 = bezierPoint(pt1.x, c.x+(n.x*pressure), c.x+(n.x*pressure), pt2.x, t);
          float y1 = bezierPoint(pt1.y, c.y+(n.y*pressure), c.y+(n.y*pressure), pt2.y, t);
          strokeWeight(3);
          stroke(255,0,0);
          b1.vertices.get(i).pos.x = x1;
          b1.vertices.get(i).pos.y = y1;
          point(x1, y1);
          strokeWeight(1);
          //ellipse(x1, y1, 10, 10);
        }*/
      }
      else{
        if(b1.collideWith.contains(h2) && b2.collideWith.contains(h1)){
          b1.collideWith.remove(new Integer(h2));
          b2.collideWith.remove(new Integer(h1));
        }
      }
    }
    //b1.undrawableVertices = vert;
  }
}

void forceCircle(float t){
  
    /*float radius = 60;
    PVector center = new PVector(300,300);
    int nbVertices = 30;
    float angle = radians(360/nbVertices);
    PVector rad = new PVector(0, -radius);
    ArrayList<Vertices> vertices = new ArrayList<>();
    ArrayList<Edges> edges = new ArrayList<>();
    for (int i = 0; i<30; i++) {
      PVector pos = rad.copy();
      pos.x += center.x;
      pos.y += center.y;
      Vertices v = new Vertices(pos, rad.copy().normalize());
      vertices.add(v);
      //System.out.println(v.pos + " && " + v.norm);
      rad.rotate(angle);
    }*/
    for(int i = 0; i < verticesArr.size(); i++){
      Vertices v = verticesArr.get(i);
      Vertices v2 = bubblesArr.get(1).vertices.get(i);
      PVector p = PVector.sub(v2.pos, v.pos).normalize();
      
      if(v.pos.dist(v2.pos) > 1){
        v.pos.add(PVector.mult(p, 3*t));
        //System.out.println(v.pos);
      }
      else{
        v.pos = v2.pos;
      }
    }
}

void draw() {
  background(255);
  circle(200, 300, 120);
  for(var v : bubblesArr.get(0).vertices){
    strokeWeight(3);
    point(v.pos.x, v.pos.y);
    strokeWeight(1);
  }
  /*System.out.println((6)%4);
  for(int i = 0; i<verticesArr.size(); i++){
    Vertices v1 = verticesArr.get(i);
    Vertices v2 = verticesArr.get((i+1)%verticesArr.size());
    line(v1.pos.x, v1.pos.y, v2.pos.x, v2.pos.y);
  }*/
  //bubblesArr.get(0).center = new PVector(mouseX, mouseY);
  //bubblesArr.get(0).move(new PVector(mouseX, mouseY));
  //bubblesArr.get(0).move(new PVector(bubblesArr.get(0).center.x, bubblesArr.get(0).center.y-t));
  //System.out.println(bubblesArr.get(1).collideWith.size()); //bubblesArr.get(1).center.y -= bubblesArr.get(1).z;

  //forceCircle(0.08);
  /*Check CoLlision*/
  /*for (int i = 0; i < bubblesArr.size()-1; i++)
    for (int j = i+1; j < bubblesArr.size(); j++)
      bubblesArr.get(i).detectCollision(bubblesArr.get(j*/
  handleCollisions();

  for (int i = 0; i < bubblesArr.size(); i++) {
    //bubblesArr.get(i).update();
    bubblesArr.get(i).draw(clr);
    if (normals) bubblesArr.get(i).drawNormals();
  }

  // bubblesArr.get(0).waves();
  //bubblesArr.get(0).draw(clr);
}







void keyPressed() {
  if (key == '+') {
    /*for(Bubble b : bubblesArr){
     b.radius += 1; b.update();
     }*/
    bubblesArr.get(1).radius++;
    bubblesArr.get(1).update();
  }
  if (key == '-') {
    /*for(Bubble b : bubblesArr){
     b.nbVertices -= 1; b.update();
     }*/
    bubblesArr.get(1).radius--;
    bubblesArr.get(1).update();
  }
  if (key == 'n') normals = !normals;
}
