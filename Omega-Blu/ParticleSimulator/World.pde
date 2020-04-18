double Gravity = 1;
var EnergyLoss =  0.2;
double StickProbability = 0;

class World
{
  ArrayList P = new ArrayList(); // list of particles
  ArrayList S = new ArrayList(); // list of springs
  ArrayList B = new ArrayList(); // list of boundries
  ArrayList Z = new ArrayList(); // excluded zones
  boolean showRedCOLLISIONLine = false;
  
  World() { }
  void addParticle(Particle p) { P.add(p); }
  void addBoundry(Boundry b) { B.add(b); }
  void addExcludedZone(var z) { Z.add(z); }
  void showCollision() {showRedCOLLISIONLine = true;}
  
  void update()
  {    
    // apply gravity and update the particles
    PVector g = new PVector(0, Gravity, 0); 
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      
      // note: f = m x a (i.e. f = m x gravity)
      var f = g.get();
      f.mult(p.m); 
      p.F.add(f);
      p.update();
    }
    
    
    // create a spring
    for (int i = 0; i < P.size()-1; i++)
    {
      var A = (Particle) P.get(i);
      int springCount = 0;
      
      for (int j = i+1; j < P.size(); j++)
      {
        var B = (Particle) P.get(j);
        
        var d = dist(A.l.x, A.l.y, B.l.x, B.l.y);
        
        if (d <= ConnectLength)
        {
          if (random() <= ConnectionProbability)
          {
            Spring s = new Spring(A, B);
            S.add(s);
            s.k = SpringConstant;
            s.update();
            
            springCount++;
            if (springCount == 3) break;
          }
        }
      }
    }
    
    // check collisions
    checkBoundryCollision(EnergyLoss);
    checkParticleParticleCollision(EnergyLoss);
    checkExcludeZoneCollision(EnergyLoss);
  }
  
  
  void checkBoundryCollision(double EnergyLoss)
  {
    for (int j = 0; j < B.size(); j++)
    {
      var b = B.get(j);
      
      // normalise boundry by moving it to zero, zero corrodinates
      // and then rotating the boarder to x-axis
      // so that the problem becomes a simple circle hitting the floor problem
      // i.e. radius below 0 line
      var ba = b.a.get();
      var bb = b.b.get();
      var center = ba.get();
      center.add(bb);
      center.div(-2); // translation to zero, zero offset
      ba.x += center.x; ba.y += center.y;
      bb.x += center.x; bb.y += center.y;
      double angle = -1*atan2(bb.y, bb.x); // rotation to x-axis offset
      Utils.rotateZ(ba, angle);
      Utils.rotateZ(bb, angle);
    
      //ellipse(center.x, center.y, 10, 10); // center of border
      //line(ba.x, ba.y, bb.x, bb.y); // normalised border to zero, zero and rotated to x-axis

      // now apply the same transform to the particles and see if it goes below zero
      for (int i = 0; i < P.size(); i++)
      {
        var p = P.get(i);
        if (p.isStuck) continue;
        
        // normalise point to normalised boundry
        var pl = p.l.get(); 
        pl.x += center.x; pl.y += center.y;
        Utils.rotateZ(pl, angle);
        
        //fill(255, 0,0); ellipse(pl.x, pl.y, p.r, p.r); // paricle on normalised boundy
        
        // collision
        // see if the ball goes through the boundry line
        // 1) The circle y must first be below 0 and
        // 2) if the line ends are on either side of zero then collision at normal line  (i.e. center of circle)
        // 3) if both ends of the line are on one side, then collison if one point is less than radius (edge)
        
        // 1): circle below zero
        if ((pl.y >= -p.r && pl.y <= p.r))
        {
          var reaction = null;
          
          // 2): either side of center of ball
          if ((ba.x <= pl.x && bb.x >= pl.x) || (ba.x >= pl.x && bb.x <= pl.x))
          {
            // move it back
            pl.y = -p.r;
            Utils.rotateZ(pl, -angle);
            pl.x -= center.x; pl.y -= center.y;
            p.l.x = pl.x; p.l.y = pl.y;         
            
            // reation is straight back
            reaction = new PVector(0, -1);
            var t = b.n.get(); t.mult(p.r); t.add(p.l);
            
            doTouch(t, p);
          }
          
          // 3): edge collision
          if ((ba.x <= pl.x && bb.x <= pl.x) || (ba.x >= pl.x && bb.x >= pl.x))
          {
            var d1 = dist(ba.x, 0, pl.x, pl.y);
            var d2 = dist(bb.x, 0, pl.x, pl.y);
            
            if (d1 <= p.r || d2 <= p.r)
            {
              var dx;
              var dy;
              
              // right edge (b)
              if (pl.x >= bb.x)
              {
                // move it to the edge
                var dd = p.r / min(d1, d2);
                dx = bb.x + ((pl.x - bb.x) * dd);  
                dx = dx - pl.x; 
                dy = (pl.y) * dd;
                dy = dy - pl.y;
                
                // reaction is from edge to center of ball
                reaction = new PVector(pl.x - bb.x, pl.y);
                
                var t = b.b.get();
                doTouch(t, p);
              }
              
              // left edge (a)
              else if (pl.x <= ba.x)
              {
                // move it to the edge
                var dd = p.r / min(d1, d2);
                dx = ba.x + ((pl.x - ba.x) * dd);
                dx = dx - pl.x;
                dy = (pl.y) * dd;
                dy = dy - pl.y;
                
                // reaction is from edge to center of ball
                reaction = new PVector(pl.x - ba.x, pl.y);
                
                var t = b.a.get();
                doTouch(t, p);
              }

              // move it back to the edge
              pl.x += dx;
              pl.y += dy;
              Utils.rotateZ(pl, -angle);
              pl.x -= center.x; pl.y -= center.y;
              p.l.x = pl.x; p.l.y = pl.y;
            }
          }
          
          if (reaction != null)
          {
            // apply force
            reaction.normalize();
            Utils.rotateZ(reaction, -angle);
            var d = p.v.dot(reaction);
            reaction.mult(-(1+(1-EnergyLoss))*d);
            p.v.add(reaction);
          }
        }
      }
    }
  }
  
  void checkExcludeZoneCollision(double EnergyLoss)
  {
    // check exclude zones
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      if (p.isStuck) continue;
      
      boolean inExcludeZone = false;
      for (int e = 0; e < Z.size(); e++)
      {
        var z = Z.get(e);
        inExcludeZone = Utils.pixelInPoly(p.l, z);
        if (inExcludeZone) break;
      }
      
      if (inExcludeZone)
      {
        // definately in exclude zone, so must interset with some boundry;
        // so extend the hot radius and look around and keep the closest boundry
        var stickIntersect = null; var stickBoundry = null; var minDist = 0;
        
        for (int r = 0.2; r < 3; r+= 0.2)
        {
          var retVal = lookAround(p, 30, r, stickIntersect, stickBoundry, minDist);
          stickIntersect = retVal[0]; stickBoundry = retVal[1]; minDist = retVal[2];
        }
        
        if (stickIntersect != null)
        {
          // move back to boundry
          var sb = stickBoundry.n.get();
          sb.mult(-1 * p.r);
          sb.add(stickIntersect);
          p.l.x = sb.x;
          p.l.y = sb.y;
          
          // reaction
          var v = stickBoundry.n.get();
          var d = abs(p.v.dot(v));
          v.mult(-(1+(1-EnergyLoss))*d);
          p.v.x = v.x;
          p.v.y = v.y;
          
          doTouch(stickIntersect, p);
        }
      }
    }
  }
  
  void doTouch(var l, var p)
  {
    if (showTouch)
    {
      var t = new PVector(l.x, l.y);
      Utils.rotateZ(t, -totalRotation);
      g.ellipse(t.x, t.y, 1, 1);
    }
    
    if (random() <= (StickProbability*StickProbability)) p.isStuck = true;
  }
  
  void checkParticleParticleCollision(double EnergyLoss)
  {
    for (int i = 0; i < P.size()-1; i++) 
    {
      var p1 = P.get(i);
   
      for (int j = i + 1; j < P.size(); j++) 
      {
        var p2 = P.get(j);
        
        float dx = p2.l.x - p1.l.x;
        float dy = p2.l.y - p1.l.y;
        float dist = sqrt(dx * dx + dy * dy);
        
        // we need this in case two points overlap exactly and so dist is 0 and divide by zero error 
        if (dist == 0) return;
        
        if (dist < (p2.r + p1.r)) 
        {
          // particles have contact so push back...
          float normalX = dx / dist;
          float normalY = dy / dist;
          float midpointX = (p1.l.x + p2.l.x) / 2;
          float midpointY = (p1.l.y + p2.l.y) / 2;
          
          if (!p1.isStuck)
          {
            p1.l.x = midpointX - normalX * p1.r;
            p1.l.y = midpointY - normalY * p1.r;
          }
          
          if (!p2.isStuck)
          {
            p2.l.x = midpointX + normalX * p2.r;
            p2.l.y = midpointY + normalY * p2.r;
          }
          
          float dVector = (p1.v.x - p2.v.x) * normalX;
          dVector += (p1.v.y - p2.v.y) * normalY;
          float dvx = dVector * normalX * (1-EnergyLoss);
          float dvy = dVector * normalY * (1-EnergyLoss);
          
          p1.v.x -= dvx;
          p1.v.y -= dvy;
          p2.v.x += dvx;
          p2.v.y += dvy;
        }
      }
    }
  }
  
  var lookAround(var p, var length, var angle, var _stickIntersect, var _stickBoundry, var _minDist)
  {
    var stickIntersect = _stickIntersect;
    var stickBoundry = _stickBoundry;
    var minDist = _minDist;
    
    var l = p.l;
    
    var tc = p.v.get();
    tc.normalize();
    tc.mult(-1 * length);
    
    var tl = tc.get();
    Utils.rotateZ(tl, angle);
    
    var tr = tc.get();
    Utils.rotateZ(tr, -angle);
    
    var last_ltc = l.get();
    last_ltc.add(tc);
    
    var last_ltl = l.get();
    last_ltl.add(tl);
    
    var last_ltr = l.get();
    last_ltr.add(tr);
    
    if (showRedCOLLISIONLine)
    {
      stroke(255, 0, 0); strokeWeight(2); line(l.x, l.y, last_ltc.x, last_ltc.y);
      stroke(255, 0, 0); strokeWeight(2); line(l.x, l.y, last_ltl.x, last_ltl.y);
      stroke(255, 0, 0); strokeWeight(2); line(l.x, l.y, last_ltr.x, last_ltr.y);
    }
    
    for (int j = 0; j < B.size(); j++)
    {
      var b = B.get(j);
      PVector intersect = Utils.line_itersection(last_ltc, l, b.a, b.b);
      if (intersect == null) intersect = Utils.line_itersection(last_ltl, l, b.a, b.b);
      if (intersect == null) intersect = Utils.line_itersection(last_ltr, l, b.a, b.b);
      
      
      if (intersect != null)
      {
        var distToBoundy = dist(l.x, l.y, l.z, intersect.x, intersect.y, intersect.z);
        
        // keep the closest boundary hit
        if (stickIntersect ==  null || distToBoundy <= minDist)
        {
          stickIntersect = intersect;
          stickBoundry = b;
          minDist = distToBoundy;
        }
      }
    }
    
    return [stickIntersect, stickBoundry, minDist];
  }
  
  void draw()
  {
    // excluded zones
    for (int i = 0; i < Z.size(); i++)
    {
      var z = Z.get(i);
      
      stroke(0); strokeWeight(0.001); fill(0, 90);
      beginShape();
      for (int j = 0; j < z.length; j ++)
      {
        vertex(z[j].x, z[j].y);
      }
      endShape();
    }
    
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
    S.clear();
    
    // particles
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      p.draw();
    }
  }
  
  void rotateZ(double angle)
  {
    // excluded zones
    for (int i = 0; i < Z.size(); i++)
    {
      var z = Z.get(i);
      for (int j = 0; j < z.length; j ++)
      {
        Utils.rotateZ(z[j], angle);
      }
    }
    
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
    
    static boolean pixelInPoly(PVector pos, PVector[] verts) 
    {
      int i;
      int j;
      boolean c = false;
      int sides = verts.length;
    
      for (i = 0,j = sides-1; i < sides; j=i++) 
      {
        if (( ((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
            (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) 
        {
          c = !c;
        }
      }
      return c;
    }
    
    static void rotateZ(Pvector v, double angle)
    {
      // PVector.rotate (v.rotate(angle);) doesn't work
      // so:
      PMatrix2D t = new PMatrix2D();
      t.rotate(angle);
      PVector t1 = new PVector(); t.mult(v,v);
    }
  }