class Boundry
{
  PVector a; // point1
  PVector b; // point2
  PVector c; // point3
  
  PVector n; // normal direction
  
  Boundry(PVector _a, PVector _b, PVector _c)
  {
    a = _a.get();
    b = _b.get();
    c = _c.get();
  }
  
  void draw()
  {
    stroke(0); strokeWeight(1);
    line(a.x, a.y, b.x, b.y);
    

    stroke(0, 255, 0);
    var cx = (a.x + b.x) / 2;
    var cy = (a.y + b.y) / 2;
    
    n = new PVector((a.y - b.y), (b.x - a.x), 0);
    n.normalize();
    n.mult(10);
    line(cx, cy, cx+n.x, cy+n.y);
  }
  
  void rotateZ(double angle)
  {
    Utils.rotateZ(a, angle);
    Utils.rotateZ(b, angle);
    Utils.rotateZ(c, angle);
  }
}