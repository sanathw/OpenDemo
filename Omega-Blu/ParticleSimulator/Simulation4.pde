void Setup_Simulation4()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 2;
  ParticleMass = 10;
  
  // Note that these spring values only apply if the ConnectionProbability hits
  SpringNaturalLength = 6;  // Ideally should be 2 x ParticleRadius. If this is 2 x ParticleRadius or greater then more viscous.
  SpringConstant = 1;       // High values more viscous (towards solid)
  SpringDamping = 0.05;     // High values more viscous (towards solid), low values more water like.
  ConnectLength = 10;       // Ideally around 2 x ParticleRadius. But should be >= SpringNaturalLength. The greater the value the more viscous
  MaxSprings = 8;           // More springs the more viscous.
  
  if (simChange) { Rotation = 0.01; StickProbability = 0; ConnectionProbability = 0; }
  // StickProbability is the probability of sticking to a wall
  // ConnectionProbability is the probability of becoming a blob
  
  // Note that this is accelration (i.e. gravity is accelration and not a Force)
  Gravity = 0.05; 
  
  // 0 is lossless so full bounce, 1 is total loss so no bounce
  EnergyLoss =  0.5; 
  
  ////////////////////////////////////////////
  // MODEL CONFIG
  
  var numberOfParticles = 300;
  var s = 0.32; // scale  
  modelOffset = new PVector(0, 0); // if '+' button in debug pressed then can use mouse to move
  gearRatio = 0; // model roation as a ration of Rotation above (-2 is a good value)
  
  
  
  // BOX
  half_box_width = 300/2;
  half_box_height = 830/2;
  loadImageId = 4;
  loadBackImage(loadImageId); 
  
  
  var box_top_left    = new PVector(-half_box_width, -half_box_height);                 var box_top_right   = new PVector(half_box_width, -half_box_height);
  var box_bottom_left = new PVector(-half_box_width, half_box_height);                  var box_bottom_right = new PVector(half_box_width, half_box_height);
  
  
  // Indents
  var ss = 1.15;
  
  var h1 = 14 * ss;
  var h2 = 20 * ss;
  var h3 = 10 * ss;
  var w1 = 10 * ss;
  var w2 = 38 * ss;
  var indentStart = new PVector(w1, 0);
  var indentDiplayStart = null;
  var indentEnd = new PVector((box_bottom_left.x*s), (half_box_height*s));
  
  var I1 = [new PVector(w1, 0), new PVector(0, 0), new PVector(0, h1), new PVector(w1, h1)];
  var I2 = [new PVector(w1, 0), new PVector(w2, 0), new PVector(w2, h2), new PVector(w1, h2)];
  var I3 = [new PVector(w1, 0), new PVector(0, 0)];
  
  var o1 = 42 * ss;
  var o2 = 10 * ss;
  var o3 = 46 * ss;
  var Intends = [
                  {o1, I1}, 
                  {o1, I1}, 
                  {o1, I1}, 
                  {o1, I1},
                      {o2, I2},
                  {o2, I1}, 
                  {o1, I1}, 
                  {o1, I1},
                      {o2, I2},
                  {o2, I1}, 
                  {o1, I1}, 
                  {o1, I1},
                      {o2, I2},
                  {o2, I1}, 
                  {o1, I1},
                  {o3, I3}
                ];
  
  
  Boundry b;
  var z = [];
  
  var offset = 0;
  var indent;
  var lastPoint = indentStart.get();
  
  for (int j = 0; j < Intends.length; j++)
  {
    offset = Intends[j][0];
    indent = Intends[j][1];
    
    var OffsetPoint = lastPoint.get();
    
    z = [];
    var KeepPoint1 = null;
    var KeepPoint2 = null;
    
    for (int i = 0; i< indent.length; i++)
    {
      var currentPoint = indent[i].get();
      currentPoint.y += (OffsetPoint.y + offset); 
      
      var DisplaylastPoint = lastPoint.get();
      DisplaylastPoint.add(box_top_left); DisplaylastPoint.mult(s);
      
      var DisplayCurrentPoint = currentPoint.get();
      DisplayCurrentPoint.add(box_top_left); DisplayCurrentPoint.mult(s);
      
      if (i == 0 && j == 0) indentDiplayStart = DisplaylastPoint.get();
      
      b = new Boundry(DisplaylastPoint, DisplayCurrentPoint); 
      W.addBoundry(b);
      lastPoint = currentPoint.get();
      
      // Add right boundry
      b = new Boundry(new PVector(-DisplayCurrentPoint.x, DisplayCurrentPoint.y), new PVector(-DisplaylastPoint.x, DisplaylastPoint.y)); 
      W.addBoundry(b);
      
      if (i == 0)
      {
        z = [];
        z[0] = DisplaylastPoint.get();
        z[1] = DisplayCurrentPoint.get();
        z[2] = new PVector((-half_box_width)*s, DisplayCurrentPoint.y);
        z[3] = new PVector((-half_box_width)*s, DisplaylastPoint.y);
        W.addExcludedZone(z);
        
        // Add right zone
        z = [];
        z[0] = new PVector(-DisplaylastPoint.x, DisplaylastPoint.y);
        z[1] = new PVector(-DisplayCurrentPoint.x, DisplayCurrentPoint.y);
        z[2] = new PVector((half_box_width)*s, DisplayCurrentPoint.y);
        z[3] = new PVector((half_box_width)*s, DisplaylastPoint.y);
        W.addExcludedZone(z);
      }
      
      if (i == 1) KeepPoint1 = DisplayCurrentPoint.get();
      if (i == 2) KeepPoint2 = DisplayCurrentPoint.get();
    }
    
    if (KeepPoint1 != null && KeepPoint2 != null && KeepPoint1.x != ((-half_box_width)*s) && KeepPoint2.x != ((-half_box_width)*s))
    {
      z = [];
      z[0] = KeepPoint1.get();
      z[1] = KeepPoint2.get();
      z[2] = new PVector((-half_box_width)*s, KeepPoint2.y);
      z[3] = new PVector((-half_box_width)*s, KeepPoint1.y);
      W.addExcludedZone(z);
      
      // Add last right zone
      z = [];
      z[0] = new PVector(-KeepPoint1.x, KeepPoint1.y);
      z[1] = new PVector(-KeepPoint2.x, KeepPoint2.y);
      z[2] = new PVector((half_box_width)*s, KeepPoint2.y);
      z[3] = new PVector((half_box_width)*s, KeepPoint1.y);
      W.addExcludedZone(z);
    }
  }
  
  var DisplaylastPoint = lastPoint.get();
  DisplaylastPoint.add(box_top_left); DisplaylastPoint.mult(s);
  b = new Boundry(DisplaylastPoint, indentEnd);
  W.addBoundry(b);
  
  // add last right boundry
  b = new Boundry(new PVector(-indentEnd.x, indentEnd.y), new PVector(-DisplaylastPoint.x, DisplaylastPoint.y));
  W.addBoundry(b);
  
  
  //apply scale
  box_top_left.mult(s); box_top_right.mult(s);
  box_bottom_left.mult(s);   box_bottom_right.mult(s);
  

  // BOX Excluded Zones
  // outside left
  var z = [];
  z[0] = new PVector(-half_screenWidth, half_screenHeight);
  z[1] = box_bottom_left.get();
  z[2] = box_top_left.get();
  z[3] = new PVector(-half_screenWidth, -half_screenHeight);
  W.addExcludedZone(z);
  
  // outside right
  z = [];
  z[0] = new PVector(half_screenWidth, half_screenHeight);
  z[1] = box_bottom_right.get();
  z[2] = box_top_right.get();
  z[3] = new PVector(half_screenWidth, -half_screenHeight);
  W.addExcludedZone(z);
  
  // outside top
  z = [];
  z[0] = new PVector(-half_screenWidth, -half_screenHeight);
  z[1] = box_top_left.get();
  z[2] = box_top_right.get();
  z[3] = new PVector(half_screenWidth, -half_screenHeight);
  W.addExcludedZone(z);
  
  // outside bottom
  z = [];
  z[0] = new PVector(-half_screenWidth, half_screenHeight);
  z[1] = box_bottom_left.get();
  z[2] = box_bottom_right.get();
  z[3] = new PVector(half_screenWidth, half_screenHeight);
  W.addExcludedZone(z);
  
  // Top
  Boundry bTop = new Boundry(new PVector(-indentDiplayStart.x, indentDiplayStart.y), new PVector(indentDiplayStart.x, indentDiplayStart.y)); W.addBoundry(bTop);
  
  //Bottom
  Boundry bBottom = new Boundry(new PVector(indentEnd.x, indentEnd.y), new PVector(-indentEnd.x, indentEnd.y)); W.addBoundry(bBottom);
 
 
  half_box_width *= s;
  half_box_height *= s;
  
  
  
  // Particles
  for (int i = 0; i < numberOfParticles; i++)
  {
    PVector l = new PVector(random(40)-20, 40+random(40)-20);
    l.mult(s);
    Particle p = new Particle(l);W.addParticle(p);
  }
  
  selectedP = null;
}