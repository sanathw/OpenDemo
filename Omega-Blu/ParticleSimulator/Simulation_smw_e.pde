void Setup_Simulation_smw_e()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 3;
  ParticleMass = 10;
  
  // Note that these spring values only apply if the ConnectionProbability hits
  SpringNaturalLength = 20; // Ideally should be 2 x ParticleRadius. If this is 2 x ParticleRadius or greater then more viscous.
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
  EnergyLoss =  0.8; 

  ////////////////////////////////////////////
  // MODEL CONFIG
  
  var numberOfParticles = 0;
  var s = 1; // scale
  modelOffset = new PVector(0, 0); // if '+' button in debug pressed then can use mouse to move
  gearRatio = 0; // model roation as a ration of Rotation above (-2 is a good value)
  
  half_box_width = 100;
  half_box_height = 100;
  loadImageId = 10;
  loadBackImage(loadImageId);
  
  // BOX
  var box_top_left    = new PVector(-100, -100);                 var box_top_right   = new PVector(100, -100);
  var box_bottom_left = new PVector(-100, 100);                  var box_bottom_right = new PVector(100, 100);
  
  //Triangle
  var triangle_top    = new PVector(0, 40); 
  var triangle_left   = new PVector(-40, 60);
  var triangle_right = new PVector(40, 60);
  
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
  AddSpecialParicles = true;
  
  /*for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 10; j++)
    {
      Pvector l = new PVector(-20+i*6, 20+j*6);
      l.mult(s);
      Particle p = new Particle(l); W.addParticle(p);
    }
  }*/
  
  selectedP = null;
}