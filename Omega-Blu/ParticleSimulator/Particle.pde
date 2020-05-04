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
  
  boolean isStuck = false;
  
  boolean isMiddleHit = false;
  boolean isCornerHit = false;
  PVector cornerHitPoint = null; 

  int springCount = 0;
  ArrayList S = new ArrayList();
  
  Particle(PVector _l)
  {
    l = _l.get();
    v = new PVector(0, 0, 0);
    F = new PVector(0, 0, 0);
    //a will be calculated from F
  }
  
  void update()
  {
    if (isStuck) {v = new PVector(0, 0, 0); F = new PVector(0, 0, 0); return;}
    
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
    stroke(80, 80, 255, 120); strokeWeight(0.5); 
    
    fill(200, 200, 255);
    if (SHOW_DEBUG) fill(100, 100, 255, 90);
    else fill(200, 200, 255);
    
    if (overrideParicleColor != null) fill(overrideParicleColor);
    
    if (isStuck) fill(255, 20, 220, 90); //fill(40, 40, 200);
    
    if (this == selectedP) 
    {
      debugHUDMessage1 = "location: [" + l.x + ", " + l.y + "]";
      debugHUDMessage2 = "velocity: [" + v.x + ", " + v.y + "]";
      debugHUDMessage3 = "springs: " + S.size();
      
      fill(0, 255, 0);
      if (isStuck) fill(0, 100, 0);
    }
    ellipse(l.x, l.y, r, r);
    //if (isNaN(l.x)) {println("NAN"); loop=false;}
    
    if (showVelocity)
    {
      //stroke(198, 28, 234);
      stroke(0);
      strokeWeight(0.5); line(l.x, l.y, l.x+v.x*r, l.y+v.y*r);
    }
  }
  
  void rotateZwithOffset(double angle)
  {
    if (isStuck) Utils.rotateZwithOffset(l, angle);
  }
}