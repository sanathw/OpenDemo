double ParticleRadius = 10;
double ParticleMass = 5;
ParticleStickeynessProbability = 0;

class Particle
{
  double r = ParticleRadius; // radius
  double m = ParticleMass;  // mass
  PVector l;     // location
  PVector v;     // velocity
  PVector a;     // acceleration
  PVector F;     // the next instantaneous force to apply
  
  PVector FTemp;
  Boundry stickBoundry = null;
  PVector ttt;
  
  ArrayList S = new ArrayList();  // list of springs attached to this particel 
  
  var last_l = [];                // required for collision check
  boolean stuck = false;          // set if stuck to boundry
  boolean onEdge = false;
  
  Particle(PVector _l)
  {
    l = _l.get();
    v = new PVector(0, 0, 0);
    F = new PVector(0, 0, 0);
    //a will be calculated from F
    
    ttt = l.get();
    
    for (int i = 0; i < collisionPathMemory; i++) last_l[i] = l.get();
  }
  
  void update()
  {
    if (stuck == true) {F.set(0, 0, 0); v.set(0, 0, 0); onEdge = true; return;}
    onEdge = false;
    
    //if (stickBoundry != null)
    //{
    //}
    //stickBoundry = null;
    
    // apply the force
    a = F.get(); a.div(m);   //a = F / m
    v.add(a);                //v = v + a
    l.add(v);                //l = l + v
    
    // reset the instantaneous force
    FTemp = F.get();
    F.set(0, 0, 0);
    
    for (int i = 0; i < collisionPathMemory-1; i++) last_l[i] = last_l[i+1].get();
    last_l[collisionPathMemory-1] = l.get();
  }
  
  void draw()
  {
    ellipseMode(RADIUS);
    stroke(80, 80, 255, 120); strokeWeight(0.5); fill(100, 100, 255, 90);
    if (stuck) fill(0,0,190);
    ellipse(l.x, l.y, r, r);
    
    //stroke(0, 255, 0); strokeWeight(1); line (0, 0, l.x, l.y);
  }
  
  Spring getAttachedToOtherParticelSpring(Particel p)
  {
    for (int i = 0; i < S.size(); i++)
    {
      var s = S.get(i);
      if (s.A == p || s.B == p) return s;
    }
    
    return null;
  }
  
  void removeSpring(Spring _s)
  {
    S.remove(S.indexOf(_s));
  }
  
  void stickToPoint(PVector intersection, Boundry b)
  {
    onEdge = true;
    
    if (!showTouch)
    {
       if (random() < (Temperature * Temperature))
       {
          l.set(intersection.x, intersection.y, intersection.z);
          v.set(0, 0, 0);
          a.set(0, 0, 0);
          F.set(0, 0, 0);
          stuck = true;
          return;
       }
     }
     else
     {
        var t = intersection.get();
        Utils.rotateZ(t, -aa);
        //W.addTouch(t);
        g.ellipse(t.x, t.y, 1, 1)
     }
  
    //l = intersection.get();
    //stickBoundry = b;
    //return;
  
  
  
  
  
    var d = v.dot(b.n); // how much of the force is in to the wall
    
    var t = b.n.get();
    t.mult(-1 * d);
    v.add(t);
    
    
    /*var vv = b.b.get();//v.cross(b.n);
    vv.sub(b.a);
    vv.normalize();
    //println(vv); loop = false;
    d = v.dot(vv);
    var t1 = vv.get();
    t1.mult(0.05 * d);
    
    v.add(t);
    v.add(t1);*/
    
    l = intersection.get();
    t = b.n.get();
    t.mult(-1 * 1);
    l.add(t);
    //l.add(v);
    
    //println(v);
    //println(t);
    
    //F = b.n.get();
    //F.mult(10 * d); // reaction force;
    
    //v.sub(d);
    
    for (int i = 0; i < collisionPathMemory; i++) last_l[i] = l.get();
    
    return;
    l = intersection.get(); // particle can't go through wall so, put it back on the wall
    //for (int i = 0; i < collisionPathMemory; i++) last_l[i] = l.get();
    
    var t = b.n.get();
    t.mult(-1 * 1);
    l.add(t);
    
    
    // velocity in the direction of wall is 0;
    FTemp.add(F);
    FTemp.normalize();
    FTemp.mult(0.25)
    v = FTemp.get();
    FTemp.set(0, 0, 0);
    
    var tt = v.get();
    tt.mult(-1);
    l.add(tt);
    //last_l[collisionPathMemory-1] = l.get();
    
    
    //for (int i = 0; i < collisionPathMemory-1; i++) last_l[i] = last_l[i+1].get();
    //last_l[collisionPathMemory-1] = l.get();
    
    for (int i = 0; i < collisionPathMemory; i++) last_l[i] = l.get();
    
    //update();
    return;
    
    
    
    println(FTemp);
    println(F); //loop = false;
    
    //F.add(FTemp); 
    //println(FTemp); println(d); println(F); loop = false;
    //update();*/
    //update();
    FTemp.set(0, 0, 0);
    
    
    //println(F); loop= false;
    
    var t = b.n.get();
    t.mult(-1);
    //l = intersection.get();
    //l.add(t);
    
    
    //l.set(v.x, v.y, v.z);
    //v.set(0, 0, 0);
    //a.set(0, 0, 0);
    //F.set(0, 0, 0);
    
    //for (int i = 0; i < collisionPathMemory-1; i++) last_l[i] = last_l[i+1].get();
    //last_l[collisionPathMemory-1] = l.get();
    //for (int i = 0; i < collisionPathMemory; i++) last_l[i] = l.get();
    
    /*
    //FTemp.mult(-1);
    //F = FTemp.get();
    
    //var d = FTemp.dot(b.n); 
    var d = b.n.dot(FTemp); 
    //println(d);
    var Reaction = b.n.get();
    Reaction.mult(-1 * d);
    F = Reaction.get();
    
    //stuck = true;*/
  }
  
  void rotateZ(double angle)
  { 
    //for (int i = 0; i < collisionPathMemory; i++) Utils.rotateZ(last_l[i], angle);
    
    if (stuck)
    {
      Utils.rotateZ(l, angle);
    }
  }
}