double SpringNaturalLength = 40;
double SpringConstant = 0.25;
double SpringDamping = 0.05;
double showSprings = false;

class Spring
{
  double l = SpringNaturalLength;  // natural length of the spring 
  double k = SpringConstant;       // spring constant
  double c = SpringDamping;        // spring damping
  
  Particle A;
  Particle B;
  double cur_l = l; // current length of the spring
  
  Spring(Particle _A, Particle _B) 
  { 
    A = _A;
    B = _B;
    
    PVector seperationVector = B.l.get(); seperationVector.sub(A.l); //B.l - A.l
    cur_l = seperationVector.mag();
    //l = cur_l; // start of with the natural length being the current length
    
    A.S.add(this);
    B.S.add(this);
  }
  
  void update() 
  {
    float last_l = cur_l;
    
    PVector seperationVector = B.l.get(); seperationVector.sub(A.l); //B.l - A.l
    
    cur_l = seperationVector.mag();          // current length of the spring
    
    seperationVector.normalize();            // get the direction that the spring force should be applied to
    
    // given a length calculate the force (Hook's Law)
    PVector f = seperationVector.get();      // force needs to point towards the two particles
    f.mult(  (cur_l - l) * k );              // Hook's Law: f = (cur_l - l) * k
    
    // damping
    float vl = last_l - cur_l;               // velocity of length change
    seperationVector.mult( (c * vl * -1 ) ); // apply proprtional to velocity in opposite direction
    f.add(seperationVector);
    
    // apply the force to the two particels
    A.F.add(f); //A.F += f
    B.F.sub(f); //B.F -= f
  }
  
  void draw()
  {
    if (showSprings)
    {
      stroke(0, 0, 255, 90); strokeWeight(0.5);
      line(A.l.x, A.l.y, B.l.x, B.l.y);
    }
  }
}