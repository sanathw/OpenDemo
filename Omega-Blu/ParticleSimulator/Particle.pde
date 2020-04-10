double ParticleRadius = 10;
double ParticleMass = 5;

class Particle
{
  double r = ParticleRadius; // radius
  double m = ParticleMass;  // mass
  PVector l;     // location
  PVector v;     // velocity
  PVector a;     // acceleration
  PVector F;     // the next instantaneous force to apply
  
  ArrayList S = new ArrayList();  // list of springs attached to this particel 
  
  PVector last_l;                 // required for collision check
  boolean stuck = false;          // set if stuck to boundry
  
  Particle(PVector _l)
  {
    l = _l.get();
    v = new PVector(0, 0, 0);
    F = new PVector(0, 0, 0);
    //a will be calculated from F
    
    last_l = l.get();
  }
  
  void update()
  {
    last_l = l.get();
    
    if (stuck == true) {F.set(0, 0, 0); v.set(0, 0, 0); return}
    
    // apply the force
    a = F.get(); a.div(m);   //a = F / m
    v.add(a);                //v = v + a
    l.add(v);                //l = l + v
    
    // reset the instantaneous force
    F.set(0, 0, 0);
  }
  
  void draw()
  {
    ellipseMode(RADIUS);
    stroke(80, 80, 255, 120); strokeWeight(0.5); fill(100, 100, 255, 90);
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
  
  void stickToPoint(PVector v)
  {
    l.set(v.x, v.y, v.z);
    v.set(0, 0, 0);
    F.set(0, 0, 0);
    stuck = true;
  }
  
  void rotateZ(double angle)
  {
    if (stuck)
    {
      Utils.rotateZ(l, angle);
    }
  }
}