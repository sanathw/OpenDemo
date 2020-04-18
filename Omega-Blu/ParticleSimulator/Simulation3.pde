void Setup_Simulation3()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 3;
  ParticleMass = 10;
  
  // Note that these spring values only apply if the ConnectionProbability hits
  SpringNaturalLength = 1;
  SpringConstant = 1;
  SpringDamping = 0.05;
  ConnectLength = 10;
  
  if (simChange) { Rotation = 0.01; StickProbability = 0; ConnectionProbability = 0; }
  // StickProbability is the probability of sticking to a wall
  // ConnectionProbability is the probability of becoming a blob
  
  // Note that this is accelration (i.e. gravity is accelration and not a Force)
  Gravity = 0.05; 
  
  // 0 is lossless so full bounce, 1 is total loss so no bounce
  EnergyLoss =  0.2; 
  
  ////////////////////////////////////////////
  // MODEL CONFIG
  
  var numberOfParticles = 300;
  
  var s = 0.8; // scale  
  // BOX
  var box_top_left    = new PVector(-46.515*s, -140*s);                 var box_top_right   = new PVector(46.515*s, -140*s);
  var box_bottom_left = new PVector(-46.515*s, 140*s);                  var box_bottom_right = new PVector(46.515*s, 140*s);
  
  // LEFT INSET (starting at y zero)
  var inset_left_top_left    = new PVector(-46.515*s, 0*s);             var inset_left_top_right    = new PVector(-35.909*s, 0*s);
  var inset_left_bottom_left = new PVector(-46.515*s, 8.788*s);         var inset_left_bottom_right = new PVector(-35.909*s, 8.788*s);
  
  // inset left is repeated on the right and also duplicated at y offset intervals as below
  var inset_offsets_y = [-50*s, 16.666*s, 81.818*s];
  
  
  //_________________________________________________________________________________
  // Boundries
  
  Boundry b;
  var z = [];
  
  //Left
  var lastPoint = box_top_left.get();
  var offsety

  for (int i = 0; i< inset_offsets_y.length; i++)
  {
    offsety = inset_offsets_y[i];
    
    var i1 = new PVector(inset_left_top_left.x, inset_left_top_left.y + offsety);
    var i2 = new PVector(inset_left_top_right.x, inset_left_top_right.y + offsety);
    var i3 = new PVector(inset_left_bottom_right.x, inset_left_bottom_right.y + offsety);
    var i4 = new PVector(inset_left_bottom_left.x, inset_left_bottom_left.y + offsety);
    
    b = new Boundry(lastPoint, i1); W.addBoundry(b);
    b = new Boundry(i1, i2); W.addBoundry(b);
    b = new Boundry(i2, i3); W.addBoundry(b);
    b = new Boundry(i3, i4); W.addBoundry(b);
    lastPoint = i4.get();
    
    // Inset Exclude Zone
    z = [];
    z[0] = lastPoint.get();
    z[1] = i1.get();
    z[2] = i2.get();
    z[3] = i3.get();
    W.addExcludedZone(z);
  }
  
  b = new Boundry(lastPoint, box_bottom_left); W.addBoundry(b);
  
  //Right
  lastPoint = box_top_right.get();
  
  for (int i = 0; i< inset_offsets_y.length; i++)
  {
    offsety = inset_offsets_y[i];
    
    var i1 = new PVector(-inset_left_top_left.x, inset_left_top_left.y + offsety);
    var i2 = new PVector(-inset_left_top_right.x, inset_left_top_right.y + offsety);
    var i3 = new PVector(-inset_left_bottom_right.x, inset_left_bottom_right.y + offsety);
    var i4 = new PVector(-inset_left_bottom_left.x, inset_left_bottom_left.y + offsety);
    
    b = new Boundry(i1, lastPoint); W.addBoundry(b);
    b = new Boundry(i2, i1); W.addBoundry(b);
    b = new Boundry(i3, i2); W.addBoundry(b);
    b = new Boundry(i4, i3); W.addBoundry(b);
    lastPoint = i4.get();
    
    // Inset Exclude Zone
    z = [];
    z[0] = lastPoint.get();
    z[1] = i1.get();
    z[2] = i2.get();
    z[3] = i3.get();
    W.addExcludedZone(z);
  }
  
  b = new Boundry(box_bottom_right, lastPoint); W.addBoundry(b);
  
  // Top
  Boundry bTop = new Boundry(box_top_right, box_top_left); W.addBoundry(bTop);
  
  //Bottom
  Boundry bBottom = new Boundry(box_bottom_left, box_bottom_right); W.addBoundry(bBottom);
 
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
  
  // Particles
  for (int i = 0; i < numberOfParticles; i++)
  {
    Particle p = new Particle(new PVector(random(40*s)-20*s, 40*s+random(40*s)-20*s)); W.addParticle(p);
  }
  
  selectedP = null;
}