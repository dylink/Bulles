
boolean normals = false;
ArrayList<Bubble> bubblesArr = new ArrayList<Bubble>();
ArrayList<Vertices> verticesArr = new ArrayList<>();
PVector clr = new PVector(0, 0, 0);
float t = 0.999;


void setup() {
  size(600, 600, P3D);
  randomSeed(second());
  Bubble b = new Bubble(120, new PVector(300, 300), 360);
  Bubble c = new Bubble(80, new PVector(300, 600), 360);
  Bubble d = new Bubble(60, new PVector(180, 300), 360);
  Bubble e = new Bubble(80, new PVector(360, 400), 60);

  bubblesArr.add(c);
  
  bubblesArr.add(b);
  
  bubblesArr.add(d);
  //bubblesArr.add(e);
  
}

PVector rotatePoint(PVector fp, PVector pt, float a) {
  float x = pt.x - fp.x;
  float y = pt.y - fp.y;
  float xRot = (float)(x * Math.cos(a) + y * Math.sin(a));
  float yRot = (float)(y * Math.cos(a) - x * Math.sin(a));
  return new PVector(fp.x+xRot, fp.y+yRot);
}

void coal() {
  
  for(var b : bubblesArr){
    b.undrawableVertices.clear();
  }
  for(int h = 0; h<bubblesArr.size(); h++){
    for(int i = 0; i<bubblesArr.get(h).vertices.size(); i++){
      bubblesArr.get(h).vertices.get(i).constrained = false;
    }
  }
  for (int h = 0; h < bubblesArr.size(); h++) {
    Bubble b1 = bubblesArr.get(h);
    for (int j = h+1; j < bubblesArr.size(); j++) {
      Bubble b2 = bubblesArr.get(j);
      System.out.println(b2.center);
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
      
      if (d < abs(b1.radius+b2.radius)) {
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
        float minDist1 = 10000;
        float minDist2 = 10000;
        float bminDist1 = 10000;
        float bminDist2 = 10000;
        for (int i = 0; i < b1.vertices.size(); i++) {
          if (minDist1 >= pt1.dist(b1.vertices.get(i).pos)) {
            minDist1 = pt1.dist(b1.vertices.get(i).pos);
            i1 = i;
          }
          if (minDist2 >= pt2.dist(b1.vertices.get(i).pos)) {
            minDist2 = pt2.dist(b1.vertices.get(i).pos);
            i2 = i;
          }
        }

        for (int i = 0; i < b2.vertices.size(); i++) {
          if (bminDist1 >= pt1.dist(b2.vertices.get(i).pos)) {
            bminDist1 = pt1.dist(b2.vertices.get(i).pos);
            j1 = i;
          }
          if (bminDist2 >= pt2.dist(b2.vertices.get(i).pos)) {
            bminDist2 = pt2.dist(b2.vertices.get(i).pos);
            j2 = i;
          }
        }
        
        int temp1 = i1;
        int temp2 = j1;
        i1 = abs(i1 - i2) > b1.vertices.size()/2 ? max(i1, i2) : min(i1, i2);
        i2 = abs(temp1 - i2) > b1.vertices.size()/2 ? min(temp1, i2) : max(temp1, i2);
        j1 = abs(j1 - j2) > b2.vertices.size()/2 ? max(j1, j2) : min(j1, j2);
        j2 = abs(temp2 - j2) > b2.vertices.size()/2 ? min(temp2, j2) : max(temp2, j2);
        b1.vertices.get(i1).constrained = true;
        b1.vertices.get(i2).constrained = true;
        b2.vertices.get(j1).constrained = true;
        b2.vertices.get(j2).constrained = true;
        strokeWeight(4);
        point(b2.vertices.get(j1).pos.x, b2.vertices.get(j1).pos.y);
        point(b2.vertices.get(j2).pos.x, b2.vertices.get(j2).pos.y);
        strokeWeight(1);
        int steps = 0;
        for (int i = i1; i%b1.vertices.size() != i2; i++) {
          steps++;
        }
        int aa = 0;
        for (int i = i1; i%b1.vertices.size() != i2; i++) {
          float t = aa / float(steps);
          float x1 = bezierPoint(b1.vertices.get(i1).pos.x, c.x+(n.x*pressure), c.x+(n.x*pressure), b1.vertices.get(i2).pos.x, t);
          float y1 = bezierPoint(b1.vertices.get(i1).pos.y, c.y+(n.y*pressure), c.y+(n.y*pressure), b1.vertices.get(i2).pos.y, t);
          b1.vertices.get(i%b1.vertices.size()).pos.x = x1;
          b1.vertices.get(i%b1.vertices.size()).pos.y = y1;
          strokeWeight(4);
          stroke(255,0,0);
          point(x1, y1);
          stroke(0);
          strokeWeight(1);
          aa++;
          b1.undrawableVertices.add(i%b2.vertices.size());
        }
        steps=0;
        for (int i = j1; i%b2.vertices.size() != j2; i++) {
          steps++;
        }
        aa = 0;
        for (int i = j1; i%b2.vertices.size() != j2; i++) {
          float t = aa / float(steps);
          float x1 = bezierPoint(b2.vertices.get(j1).pos.x, c.x+(n.x*pressure), c.x+(n.x*pressure), b2.vertices.get(j2).pos.x, t);
          float y1 = bezierPoint(b2.vertices.get(j1).pos.y, c.y+(n.y*pressure), c.y+(n.y*pressure), b2.vertices.get(j2).pos.y, t);
          b2.vertices.get(i%b2.vertices.size()).pos.x = x1;
          b2.vertices.get(i%b2.vertices.size()).pos.y = y1;
          aa++;
        }
      }
    }
  }
}

/*void forceCircle(float t){
    for(int i = 0; i < bubblesArr.get(0).vertices.size(); i++){
      PVector r = new PVector(0, -bubblesArr.get(0).radius);
      float angle = radians(360/bubblesArr.get(0).vertices.size());
      PVector r2 = r.copy().rotate(angle*i);
      r2.add(bubblesArr.get(0).center);
      Vertices v2 = bubblesArr.get(0).vertices.get(i);
      PVector p = PVector.sub(r2, v2.pos).normalize();
      
      if(r2.dist(v2.pos) > 1){
        v2.pos.add(PVector.mult(p, 3*t));
      }
      else{
        v2.pos = r2;
        v2.vit = new PVector(0,0);
      }
    }
}*/


void draw() {
  background(255);
  bubblesArr.get(0).move(new PVector(mouseX+80, mouseY+80));
  coal();

  for (int i = 0; i < bubblesArr.size(); i++) {
    //bubblesArr.get(i).update();
    bubblesArr.get(i).draw(clr);
    bubblesArr.get(i).waves(0);
    if (normals) bubblesArr.get(i).drawNormals();
  }
}


void mousePressed() {
  
  /*for(int i = 0; i<bubblesArr.get(0).vertices.size();i++){
    //System.out.println(mouseY-120);
    if(abs(bubblesArr.get(0).vertices.get(i).pos.x - mouseX) < 50){
      //((mouseY-(height/2))*((SIZE - abs(i - mouseX))/SIZE) - pos[i])*STRENGTH;
      float pos = round((bubblesArr.get(0).vertices.get(i).pos.dist(new PVector(bubblesArr.get(0).vertices.get(i).pos.y, 120))));
      float d0 = ((mouseY-120)* ((50 - abs(bubblesArr.get(0).vertices.get(i).pos.x - mouseX))/50) - pos) *0.05;
      PVector n = PVector.mult(bubblesArr.get(0).vertices.get(i).norm, d0);
      System.out.println(n);
      bubblesArr.get(0).vertices.get(i).vit.add(n);
    }
  }*/
  /*for(int i = 0; i<bubblesArr.size();i++){
    PVector mous = new PVector(mouseX, mouseY);
    if(bubblesArr.get(i).center.dist(mous) < bubblesArr.get(i).radius){
      System.out.println(bubblesArr.get(i).center + " && " + bubblesArr.get(i).center.dist(mous));
      bubblesArr.remove(i);
    }
  }*/
  /*for(int i = 0; i<bubblesArr.get(0).vertices.size(); i++){
    PVector m = new PVector(mouseX, mouseY);
    if(m.dist(bubblesArr.get(0).vertices.get(i).pos) < 50){
      //System.out.println("Oui");
      float d = ((50-m.dist(bubblesArr.get(0).vertices.get(i).pos))/50)*30;
      //System.out.println(i);
      bubblesArr.get(0).vertices.get(i).vit.add(PVector.mult(bubblesArr.get(0).vertices.get(i).norm, -d));
    }
  }*/
  /*if (mouseY < 30) return;
    for (int i = 0; i < width; i++) {
      if (abs(i - mouseX) < SIZE)
        vel[i] += ((mouseY-(height/2))*((SIZE - abs(i - mouseX))/SIZE) - pos[i])*STRENGTH; 
    }*/
    /*float strength = 100;
    PVector mous = new PVector(mouseX, mouseY);
    System.out.println("Oui");
    float minDist1 = 10000;
    int i1 = 0;
    for (int i = 0; i < bubblesArr.get(0).vertices.size(); i++) {
      if (minDist1 > bubblesArr.get(0).vertices.get(i).pos.dist(mous)) {
        minDist1 = bubblesArr.get(0).vertices.get(i).pos.dist(mous);
        i1 = i;
      }
    }
    
    if(mous.dist(bubblesArr.get(0).center) < 60) strength*=-1;
    bubblesArr.get(0).vertices.get(i1).vit.add(PVector.mult(bubblesArr.get(0).vertices.get(i1).norm, strength));*/
    /*for(int i = 40; i< 45; i++){
      bubblesArr.get(0).vertices.get(i).vit.add(PVector.mult(bubblesArr.get(0).vertices.get(i).norm, -20));
    }*/
    //bubblesArr.get(0).vertices.get(45).vit.add(new PVector(0,-10));
    /*bubblesArr.get(0).vertices.get(43).vit.add(new PVector(50,0));
    bubblesArr.get(0).vertices.get(44).vit.add(new PVector(50,0));
    bubblesArr.get(0).vertices.get(45).vit.add(new PVector(50,0));
    bubblesArr.get(0).vertices.get(46).vit.add(new PVector(50,0));
    bubblesArr.get(0).vertices.get(47).vit.add(new PVector(50,0));*/
}




void keyPressed() {
  if (key == '+') {
    bubblesArr.get(1).radius++;
    bubblesArr.get(1).update();
  }
  if (key == '-') {
    bubblesArr.get(1).radius--;
    bubblesArr.get(1).update();
  }
  if (key == 'n') normals = !normals;
}
