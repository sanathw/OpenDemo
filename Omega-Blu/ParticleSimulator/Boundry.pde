class Boundry
{
  PVector a; // point1
  PVector b; // point2
  PVector n; // normal direction
  
  Boundry(PVector _a, PVector _b)
  {
    a = _a.get();
    b = _b.get();
    calculateNormal();
  }
  
  void calculateNormal()
  {
    n = new PVector((a.y - b.y), (b.x - a.x));
    n.normalize();
  }
  
  void draw()
  {
    stroke(0); strokeWeight(1);
    line(a.x, a.y, b.x, b.y);
    
    calculateNormal();
    
    if (SHOW_DEBUG)
    {
      var cx = (a.x + b.x) / 2;
      var cy = (a.y + b.y) / 2;
      stroke(96, 215, 140);
      //stroke(198, 28, 234);
      line(cx, cy, cx+(n.x * 10), cy+(n.y *10));
    }
  }
  
  void rotateZ(double angle)
  {
    Utils.rotateZ(a, angle);
    Utils.rotateZ(b, angle);
  }
}