void Setup_Simulation1()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 3;
  ParticleMass = 10;
  
  SpringNaturalLength = 1;
  SpringConstant = 1;
  SpringDamping = 0.05;
  ConnectLength = 10;
  if (simChange) { StickProbability = 0; ConnectionProbability = 0; } // stick to wall and blob probability
                                                                      // if stick to wall then particle get used up
  
  // Note that this is accelration (i.e. gravity is accelration and not a Force)
  Gravity = 0.05; 
  
  // 0 is lossless so full bounce, 1 is total loss so no bounce
  EnergyLoss =  0.2; 
  
  Rotation = 0.015;
  
  ////////////////////////////////////////////
  // MODEL CONFIG
  
  var numberOfParticles = 100;
  
  // BOX
  var box_top_left    = new PVector(-60, -100);                 var box_top_right   = new PVector(60, -100);
  var box_bottom_left = new PVector(-60, 100);                  var box_bottom_right = new PVector(60, 100);
  
  // LEFT TIANGLE                                               // RIGHT TIANGLE
            var triangle_left_top    = new PVector(-30, -10);   var triangle_right_top    = new PVector(30, -10);
  var triangle_left_left   = new PVector(-50, 0);                      var triangle_right_right   = new PVector(50, 0);
            var triangle_left_bottom = new PVector(-30, 10);    var triangle_right_bottom = new PVector(30, 10);
  
  
  //_________________________________________________________________________________
  // Boundries
  
  //Box
  Boundry bLeft = new Boundry(box_top_left, box_bottom_left); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(box_bottom_right, box_top_right); W.addBoundry(bRight);
  Boundry bTop = new Boundry(box_top_right, box_top_left); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(box_bottom_left, box_bottom_right); W.addBoundry(bBottom);

  // Left triangle
  Boundry tL1 = new Boundry(triangle_left_left, triangle_left_top); W.addBoundry(tL1);
  Boundry tL2 = new Boundry(triangle_left_bottom, triangle_left_left); W.addBoundry(tL2);
  Boundry tL3 = new Boundry(triangle_left_top, triangle_left_bottom); W.addBoundry(tL3);
  
  // Right Triangle
  Boundry tR1 = new Boundry(triangle_right_top, triangle_right_right); W.addBoundry(tR1);
  Boundry tR2 = new Boundry(triangle_right_right,  triangle_right_bottom); W.addBoundry(tR2);
  Boundry tR3 = new Boundry(triangle_right_bottom, triangle_right_top); W.addBoundry(tR3);
  
  
  // Excluded Zones
  // outside left
  var z = [];
  z[0] = new PVector(-150, 150);
  z[1] = box_bottom_left.get();
  z[2] = box_top_left.get();
  z[3] = new PVector(-150, -150);
  W.addExcludedZone(z);
  
  // outside right
  z = [];
  z[0] = new PVector(150, 150);
  z[1] = box_bottom_right.get();
  z[2] = box_top_right.get();
  z[3] = new PVector(150, -150);
  W.addExcludedZone(z);
  
  // outside top
  z = [];
  z[0] = new PVector(-150, -150);
  z[1] = box_top_left.get();
  z[2] = box_top_right.get();
  z[3] = new PVector(150, -150);
  W.addExcludedZone(z);
  
  // outside bottom
  z = [];
  z[0] = new PVector(-150, 150);
  z[1] = box_bottom_left.get();
  z[2] = box_bottom_right.get();
  z[3] = new PVector(150, 150);
  W.addExcludedZone(z);
  
  // left triangle
  z = [];
  z[0] = triangle_left_left.get();
  z[1] = triangle_left_top.get();
  z[2] = triangle_left_bottom.get();
  W.addExcludedZone(z);
  
  // right triangle
  z = [];
  z[0] = triangle_right_right.get();
  z[1] = triangle_right_top.get();
  z[2] = triangle_right_bottom.get();
  W.addExcludedZone(z);
  
  // Particles
  for (int i = 0; i < numberOfParticles; i++)
  {
    Particle p = new Particle(new PVector(random(40)-20, 40+random(40)-20)); W.addParticle(p);
  }
  
  selectedP = null;
}