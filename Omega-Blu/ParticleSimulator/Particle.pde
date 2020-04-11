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
  
  ArrayList S = new ArrayList();  // list of springs attached to this particel 
  
  var last_l = [];                // required for collision check
  boolean stuck = false;          // set if stuck to boundry
  
  Particle(PVector _l)
  {
    l = _l.get();
    v = new PVector(0, 0, 0);
    F = new PVector(0, 0, 0);
    //a will be calculated from F
    
    for (int i = 0; i < collisionPathMemory; i++) last_l[i] = l.get();
  }
  
  void update()
  {
    if (stuck == true) {F.set(0, 0, 0); v.set(0, 0, 0); return}
    
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
     if (random() < (Temperature * Temperature))
     {
        l.set(intersection.x, intersection.y, intersection.z);
        v.set(0, 0, 0);
        a.set(0, 0, 0);
        F.set(0, 0, 0);
        stuck = true;
        return;
     }
  
  
  
    var d = FTemp.dot(b.n); // how much of the force is in to the wall
    
    F = b.n.get();
    F.mult(-1 * d); // reaction force;
    //F.add(FTemp); 
    //println(FTemp); println(d); println(F); loop = false;
    //update();*/
    update();
    FTemp.set(0, 0, 0);
    
    
    //println(F); loop= false;
    
    var t = b.n.get();
    t.mult(-1);
    l = intersection.get();
    l.add(t);
    
    
    //l.set(v.x, v.y, v.z);
    //v.set(0, 0, 0);
    //a.set(0, 0, 0);
    //F.set(0, 0, 0);
    
    //for (int i = 0; i < collisionPathMemory-1; i++) last_l[i] = last_l[i+1].get();
    //last_l[collisionPathMemory-1] = l.get();
    for (int i = 0; i < collisionPathMemory; i++) last_l[i] = l.get();
    
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
    if (stuck)
    {
      Utils.rotateZ(l, angle);
    }
  }
}