double Gravity = 1;
double ConnectLength = 40;
double BreakLength = 60;

class World
{
  ArrayList P = new ArrayList(); // list of particles
  ArrayList S = new ArrayList(); // list of springs
  ArrayList B = new ArrayList(); // list of boundries
  
  World()
  {
  }
  
  void addParticle(Particle p)
  {
    P.add(p);
  }
  
  void addBoundry(Boundry b)
  {
    B.add(b);
  }
  
  void update()
  {
    // apply gravity
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      p.F = new PVector(0, Gravity, 0);
    }
    
    
    // update the springs
    for (int i = 0; i < S.size(); i++)
    {
      var s = S.get(i);
      s.update();
    }
    
    // update the particles
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      p.update();
    }
    
    
    // create or break springs
    for (int i = 0; i < P.size()-1; i++)
    {
      var A = (Particle) P.get(i);
      
      for (int j = i+1; j < P.size(); j++)
      {
        var B = (Particle) P.get(j);
        
        PVector seperationVector = B.l.get(); seperationVector.sub(A.l); //B.l - A.l
        var l = seperationVector.mag();
        
        var joiningSpring = A.getAttachedToOtherParticelSpring(B);
        
        // create a spring if two particels are close together
        // and the two particel are not already joined
        if(joiningSpring == null && l <= ConnectLength)
        {
          Spring s = new Spring(A, B);
          S.add(s);
        }
        // break the spring if it's too far apart
        else if(joiningSpring != null && l > BreakLength)
        {
          A.removeSpring(joiningSpring);
          B.removeSpring(joiningSpring);
          S.remove(S.indexOf(joiningSpring));
        }
      }
    }
    
    // check boundy collision
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      
      for (int j = 0; j < B.size(); j++)
      {
        var b = B.get(j);
        var minDist = 0;
        
        // see if the p line and the b line intersect
        PVector intersect = Utils.line_itersection(p.last_l, p.l, b.a, b.b);

        if (intersect != null) 
        {
          //loop = false;
          var distToBoundy = dist(p.last_l.x, p.last_l.y, p.last_l.z, intersect.x, intersect.y, intersect.z);
          
          // keep the closest boundary hit
          if ((p.stuck == false) || (distToBoundy < minDist))
          {
            p.stickToPoint(intersect);
            minDist = distToBoundy;
          }
        }
      }
    }
  }
  
  void draw()
  {
    // boundries
    for (int i = 0; i < B.size(); i++)
    {
      var b = B.get(i);
      b.draw();
    }
    
    // springs
    for (int i = 0; i < S.size(); i++)
    {
      var s = S.get(i);
      s.draw();
    }
    
    // particles
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      p.draw();
    }
  }
  
  void rotateZ(double angle)
  {
    // boundries
    for (int i = 0; i < B.size(); i++)
    {
      var b = B.get(i);
      b.rotateZ(angle);
    }
    
    // particles
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      p.rotateZ(angle);
    }
  }
}




// UTILS
static class Utils
{
   static PVector line_itersection(PVector l1a, PVector l1b, PVector l2a, PVector l2b) 
   {
      float x1 = l1a.x;
      float y1 = l1a.y;
      float x2 = l1b.x;
      float y2 = l1b.y;
      
      float x3 = l2a.x;
      float y3 = l2a.y;
      float x4 = l2b.x;
      float y4 = l2b.y;
      
      float bx = x2 - x1;
      float by = y2 - y1;
      float dx = x4 - x3;
      float dy = y4 - y3;
     
      float b_dot_d_perp = bx * dy - by * dx;
     
      if(b_dot_d_perp == 0) return null;
     
      float cx = x3 - x1;
      float cy = y3 - y1;
     
      float t = (cx * dy - cy * dx) / b_dot_d_perp;
      if(t < 0 || t > 1) return null;
     
      float u = (cx * by - cy * bx) / b_dot_d_perp;
      if(u < 0 || u > 1) return null;
     
      return new PVector(x1+t*bx, y1+t*by);
    }
    
    static void rotateZ(Pvector v, double angle)
    {
      PMatrix2D t = new PMatrix2D();
      t.rotate(angle);
      PVector t1 = new PVector(); t.mult(v,v);
      //var t = new PVector(v.x, v.y);
      //t.rotate(angle);
      //t.set(t.x, t.y, t.z);
      //t.sub(v);
      //v.add(t);
    }
  }