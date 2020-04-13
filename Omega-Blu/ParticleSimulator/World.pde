double Gravity = 1;
double ConnectLength = 40;
double BreakLength = 60;
int collisionPathMemory = 100;

class World
{
  ArrayList P = new ArrayList(); // list of particles
  ArrayList S = new ArrayList(); // list of springs
  ArrayList B = new ArrayList(); // list of boundries
  ArrayList Z = new ArrayList(); // excluded zones
  
  var stickIntersect = null;
  var stickBoundry = null;
  var minDist = 0;
  
  boolean showRedCOLLISIONLine = false;
  
  World() { }
  void addParticle(Particle p) { P.add(p); }
  void addBoundry(Boundry b) { B.add(b); }
  void addExcludedZone(var z) { Z.add(z); }
  
  void showCollision() {showRedCOLLISIONLine = true;}
  
  void removeSrping(var s)
  {
    s.A.removeSpring(s);
    s.B.removeSpring(s);
    S.remove(S.indexOf(s));
  }
  
  void update()
  {
    var SpringConstantTemp = SpringConstant / (1+Temperature * 10000);
    var ConnectLengthTemp = ConnectLength;// / (1+Temperature * 10);
    var BreakLengthTemp = BreakLength;// / (1+Temperature * 10);
  
    // apply gravity
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      PVector g = new PVector(0, Gravity, 0); 
      p.F.add(g);
    }
    
    // update the springs
    for (int i = 0; i < S.size(); i++)
    {
      var s = S.get(i);
      s.k = SpringConstantTemp;
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
        if(joiningSpring == null && l <= ConnectLengthTemp && (!A.stuck && !B.stuck))
        {
          //if (A.S.size() < 10 && B.S.size() < 10) // limit the number of spring...because it ake it slow
          {
            Spring s = new Spring(A, B);
            S.add(s);
          }
        }
        // break the spring if it's too far apart
        else if(joiningSpring != null && (l > BreakLengthTemp || (A.stuck || B.stuck)))
        {
          A.removeSpring(joiningSpring);
          B.removeSpring(joiningSpring);
          S.remove(S.indexOf(joiningSpring));
        }
      }
    }
    
    // remove springs that go across boundry
    /*for (int i =  S.size()-1; i >= 0; i--)
    {
      var s = S.get(i);
     
      boolean inExcludeZoneA = false;
      boolean inExcludeZoneB = false;
      for (int e = 0; e < Z.size(); e++)
      {
        var z = Z.get(e);
        inExcludeZoneA = Utils.pixelInPoly(s.A.l, z);
        inExcludeZoneB = Utils.pixelInPoly(s.B.l, z);
        if (inExcludeZoneA && inExcludeZoneB) break;
      }
      
      //if (s.A.onEdge == false && s.B.onEdge == false)
      //if ((!inExcludeZoneA && !inExcludeZoneB) && (s.A.onEdge == false && s.B.onEdge == false))
      {
        var sa = s.A.l.get();
        var sb = s.B.l.get();
        stroke(255, 0, 0); strokeWeight(2);
        line(sa.x, sa.y, sb.x, sb.y);
        
        for (int j = 0; j < B.size(); j++)
        {
          var b = B.get(j);
          PVector intersect = Utils.line_itersection(sa, sb, b.a, b.b);
          if (intersect != null)
          { println("A");
            //s.A.removeSpring(s);
            //s.B.removeSpring(s);
            //S.remove(S.indexOf(s));
          }
        }
      }
    }*/
    
    
    // check boundy collision
    for (int i = 0; i < P.size(); i++)
    {
      var p = P.get(i);
      
      if (p.stuck) continue;
      
      //var maxDist = 0;
      //var minDist = 0;
      var l = p.l;
      
      stickIntersect = null;
      stickBoundry = null;
      
 //*     
      // first see if the particle path crosses a boundry.
      // keep the furthest away intersection
      lookBack(p);
      
      if (stickIntersect != null)
      {
        p.stickToPoint(stickIntersect, stickBoundry);
        continue;
      }
   //*/   
 
//* 
      // otherwise check if it's in an exclude zone
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
        lookAround(p, 10, 0.2);
        
        if (stickIntersect != null)
        {
          p.stickToPoint(stickIntersect, stickBoundry);
          continue;
        }
        
        // if still didn't find, then extend the radius and look around
        minDist = 0;
        for (int r = 0.2; r < 3; r+= 0.2)
        {
          lookAround(p, 30, r);
        }
        
        if (stickIntersect != null)
        {
          p.stickToPoint(stickIntersect, stickBoundry);
          //continue;
        }
       
      }
 //*/ 
      
      
      
      
      
      
      
 /////////////////////////////////////////
/* 
      boolean inExcludeZone = false;
      // excluded zones
      for (int i = 0; i < Z.size(); i++)
      {
        var z = Z.get(i);
        inExcludeZone = Utils.pixelInPoly(p.l, z);
        if (inExcludeZone) break;
      }
      
      if (inExcludeZone)
      {  


        /*var l = p.l.get();
        
        var t = p.v.get();
        t.normalize();
        t.mult(-1);
        
        for (int i = 1; i < 100; i++)
        {
            var last_l = l.get();
            var tt = t.get();
            tt.mult(i);
            last_l.add(tt);
            
            stroke(255, 0, 0); strokeWeight(2); line(l.x, l.y, last_l.x, last_l.y); 
            
            for (int j = 0; j < B.size(); j++)
            {
              var b = B.get(j);
              PVector intersect = Utils.line_itersection(last_l, l, b.a, b.b);
              if (intersect != null) 
              {
                p.stickToPoint(intersect, b);
                break;
              }
            }
        }* /

      
        //println("HELLO");
      
        // see which boundry hit it
      
        
          
        //var d = p.l.get();
        //d.sub(p.last_l[collisionPathMemory-2]);
        //var m = mag(d.x, d.y, d.z);// < 0.2) 
        //println(p.l);
        
        //for (int k = 1; k < collisionPathMemory; k++)
        for (int k = collisionPathMemory-1; k > 0; k--)
        {
          var last_l = p.last_l[k-1];
          var l = p.last_l[k];
          
          stroke(255, 0, 0); strokeWeight(2); line(l.x, l.y, last_l.x, last_l.y);          
            
          for (int j = 0; j < B.size(); j++)
          {
            var b = B.get(j);
            //var minDist = 0;
            
           /* //  SMW
            var l = p.l.get();
            var t = p.v.get();// p.v.get();
            t.normalize();
            t.mult(-1 * 10);
            
            var last_l = l.get();
            last_l.add(t);
            
            
            var last_lttt = p.ttt.get();
            //Utils.rotateZ(last_l, Rotation);
            
            
            
            //t.mult(-1);
            //l.add(t);
            
             //var l = p.last_l[collisionPathMemory-1];
             //var last_l = p.last_l[collisionPathMemory-2];
            // Utils.rotateZ(last_l, Rotation);* /
            
            //var cc = map(k, 0, collisionPathMemory, 0, 40);
            
            
            
            // see if the p line and the b line intersect
            PVector intersect = Utils.line_itersection(last_l, l, b.a, b.b);
            
            
            
            //p.ttt = last_l.get();
            
            //var intersetCirlceLine = Utils.circleLineIntersect(b.a.x, b.a.y, b.b.x, b.b.y, p.l.x, p.l.y, 1);
            //PVector intersect = null;
            
            //if (intersetCirlceLine)
            //{
            //  println("A");
            //}

            if (intersect != null) 
            {
              p.stickToPoint(intersect, b);
              break;
              //loop = false;
              //var distToBoundy = dist(l.x, l.y, l.z, intersect.x, intersect.y, intersect.z);
              
              // keep the closest boundary hit
              //if ((p.stuck == false) || (distToBoundy < minDist))
              //{
              //  stickIntersect = intersect;
              //  stickBoundry = b;
              //}
            }
          } //SMW
          
        }//
      }
      
      
      
      //if (stickIntersect != null)
      //{
      //  p.stickToPoint(stickIntersect, stickBoundry);
      //}
*/      
///////////////////////////////////////////
    }
    
    
  }
  
  
  void lookBack(var p)
  {
    var l = p.l;
    var maxDist = 0;
    var last_l = p.last_l[collisionPathMemory-2];
    
    if (showRedCOLLISIONLine) {stroke(255, 0, 0); strokeWeight(2); line(l.x, l.y, last_l.x, last_l.y);}
    for (int j = 0; j < B.size(); j++)
    {
      var b = B.get(j);
      PVector intersect = Utils.line_itersection(last_l, l, b.a, b.b);
      
      if (intersect != null) 
      {
        var distToBoundy = dist(l.x, l.y, l.z, intersect.x, intersect.y, intersect.z);
        
        // keep the furtherest boundary hit
        if (distToBoundy >= maxDist)
        {
          stickIntersect = intersect;
          stickBoundry = b;
          maxDist = distToBoundy;
        }
      }
    }
  }
  
  void lookAround(var p, var length, var angle)
  {
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
    
    
    //https://forum.processing.org/one/topic/how-do-i-find-if-a-point-is-inside-a-complex-polygon.html
    static boolean isInsidePolygon(PVector pos, PVector[] vertices) 
    {
      int i;
      int j=vertices.length-1;
      int sides = vertices.length;
      boolean oddNodes = false;
      for (i=0; i<sides; i++) 
      {
        if ((vertices[i].y < pos.y && vertices[j].y >= pos.y || vertices[j].y < pos.y && vertices[i].y >= pos.y) && (vertices[i].x <= pos.x || vertices[j].x <= pos.x)) 
        {
              oddNodes^=(vertices[i].x + (pos.y-vertices[i].y)/(vertices[j].y - vertices[i].y)*(vertices[j].x-vertices[i].x)<pos.x);
        }
        j=i;
      }
      return oddNodes;
    }
    
    static boolean pixelInPoly(PVector pos, PVector[] verts) 
    {
      int i;
      int j;
      boolean c = false;
      int sides = verts.length;
    
      for (i=0,j=sides-1;i<sides;j=i++) 
      {
        if (( ((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
            (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) 
        {
          c = !c;
        }
      }
      return c;
    }
    
    static boolean circleLineIntersect(float x1, float y1, float x2, float y2, float cx, float cy, float cr ) 
    {
      float dx = x2 - x1;
      float dy = y2 - y1;
      float a = dx * dx + dy * dy;
      float b = 2 * (dx * (x1 - cx) + dy * (y1 - cy));
      float c = cx * cx + cy * cy;
      c += x1 * x1 + y1 * y1;
      c -= 2 * (cx * x1 + cy * y1);
      c -= cr * cr;
      float bb4ac = b * b - 4 * a * c;
      return (bb4ac>=0);
    }
    
  /*  boolean circleLineIntersect(float x1, float y1, float x2, float y2, float cx, float cy, float cr ) 
    {
      float dx = x2 - x1;
      float dy = y2 - y1;
      float a = dx * dx + dy * dy;
      float b = 2 * (dx * (x1 - cx) + dy * (y1 - cy));
      float c = cx * cx + cy * cy;
      c += x1 * x1 + y1 * y1;
      c -= 2 * (cx * x1 + cy * y1);
      c -= cr * cr;
      float bb4ac = b * b - 4 * a * c;

      //println(bb4ac);

      if (bb4ac < 0) {  // Not intersecting
        return false;
      } 
    else {
      
      float mu = (-b + sqrt( b*b - 4*a*c )) / (2*a);
      float ix1 = x1 + mu*(dx);
      float iy1 = y1 + mu*(dy);
      mu = (-b - sqrt(b*b - 4*a*c )) / (2*a);
      float ix2 = x1 + mu*(dx);
      float iy2 = y1 + mu*(dy);

      // The intersection points
      //ellipse(ix1, iy1, 10, 10);
      //ellipse(ix2, iy2, 10, 10);
      
      float testX;
      float testY;
      // Figure out which point is closer to the circle
      if (dist(x1, y1, cx, cy) < dist(x2, y2, cx, cy)) {
        testX = x2;
        testY = y2; 
      } else {
        testX = x1;
        testY = y1; 
      }
      
      if (dist(testX, testY, ix1, iy1) < dist(x1, y1, x2, y2) || dist(testX, testY, ix2, iy2) < dist(x1, y1, x2, y2)) {
        return true;
      } else {
        return false;
      }
    }
}*/
    
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