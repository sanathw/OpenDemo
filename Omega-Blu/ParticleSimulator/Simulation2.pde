void Setup_Simulation2()
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
  
  var s = 1; // scale  
  // BOX
  var box_top_left    = new PVector(-60*s, -100*s);                 var box_top_right   = new PVector(60*s, -100*s);
  var box_bottom_left = new PVector(-60*s, 100*s);                  var box_bottom_right = new PVector(60*s, 100*s);
  
  // LEFT INSET
  var inset_left_top_left    = new PVector(-60*s, -10*s);           var inset_left_top_right    = new PVector(-30*s, -10*s);
  var inset_left_bottom_left = new PVector(-60*s, 10*s);            var inset_left_bottom_right = new PVector(-30*s, 10*s);
  
  // RIGHT INSET
  var inset_right_top_left    = new PVector(30*s, -10*s);           var inset_right_top_right    = new PVector(60*s, -10*s);
  var inset_right_bottom_left = new PVector(30*s, 10*s);            var inset_right_bottom_right = new PVector(60*s, 10*s);
  
  
  //_________________________________________________________________________________
  // Boundries
  
  Boundry b;
  
  //Left
  b = new Boundry(box_top_left, inset_left_top_left); W.addBoundry(b);
  b = new Boundry(inset_left_top_left, inset_left_top_right); W.addBoundry(b);
  b = new Boundry(inset_left_top_right, inset_left_bottom_right); W.addBoundry(b);
  b = new Boundry(inset_left_bottom_right, inset_left_bottom_left); W.addBoundry(b);
  b = new Boundry(inset_left_bottom_left, box_bottom_left); W.addBoundry(b);
  
  //Right
  b = new Boundry(inset_right_top_right, box_top_right); W.addBoundry(b);
  b = new Boundry(inset_right_top_left, inset_right_top_right); W.addBoundry(b);
  b = new Boundry(inset_right_bottom_left, inset_right_top_left); W.addBoundry(b);
  b = new Boundry(inset_right_bottom_right, inset_right_bottom_left); W.addBoundry(b);
  b = new Boundry(box_bottom_right, inset_right_bottom_right); W.addBoundry(b);
  
  // Top
  Boundry bTop = new Boundry(box_top_right, box_top_left); W.addBoundry(bTop);
  
  //Bottom
  Boundry bBottom = new Boundry(box_bottom_left, box_bottom_right); W.addBoundry(bBottom);
  
  // Excluded Zones
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
  
  //left inset
  z = [];
  z[0] = inset_left_top_left.get();
  z[1] = inset_left_top_right.get();
  z[2] = inset_left_bottom_right.get();
  z[3] = inset_left_bottom_left.get();
  W.addExcludedZone(z);
  
  //right inset
  z = [];
  z[0] = inset_right_top_right.get();
  z[1] = inset_right_top_left.get();
  z[2] = inset_right_bottom_left.get();
  z[3] = inset_right_bottom_right.get();
  W.addExcludedZone(z);
  
  // Particles
  for (int i = 0; i < numberOfParticles; i++)
  {
    Particle p = new Particle(new PVector(random(40*s)-20*s, 40*s+random(40*s)-20*s)); W.addParticle(p);
  }
  
  selectedP = null;
}