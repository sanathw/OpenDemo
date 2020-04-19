void Setup_Simulation_smw_c()
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
  
  var numberOfParticles = 100;
  var s = 1; // scale
  
  // BOX
  var box_top_left    = new PVector(-100, -100);                 var box_top_right   = new PVector(100, -100);
  var box_bottom_left = new PVector(-100, 100);                  var box_bottom_right = new PVector(100, 100);
  
  //_________________________________________________________________________________
  //apply scale
  box_top_left.mult(s);  box_top_right.mult(s);
  box_bottom_left.mult(s);  box_bottom_right.mult(s);
  
  // Boundries
  //Box
  Boundry bLeft = new Boundry(box_top_left, box_bottom_left); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(box_bottom_right, box_top_right); W.addBoundry(bRight);
  Boundry bTop = new Boundry(box_top_right, box_top_left); W.addBoundry(bTop);
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
  
  // Particles
  for (int i = 0; i < numberOfParticles; i++)
  {
    Pvector l = new PVector(random(40)-20, 40+random(40)-20);
    l.mult(s);
    Particle p = new Particle(l); W.addParticle(p);
  }
  
  selectedP = null;
}