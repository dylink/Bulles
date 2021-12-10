class Vertices{
  PVector pos;
  PVector norm;
  PVector vit;
  boolean constrained;
  
  Vertices(PVector p, PVector n){
   pos = p;
   norm = n;
   vit = new PVector(0,0,0);
   constrained = false;
  }
  
  
}
