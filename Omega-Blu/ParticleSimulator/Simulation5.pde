void Setup_Simulation5()
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
  
  Rotation = 0.01;

  ////////////////////////////////////////////
  
  // Boundries
  Boundry bLeft = new Boundry(new PVector(-100, -100), new PVector(-100, 100)); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(new PVector(100, 100), new PVector(100, -100)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(100, -100), new PVector(-100, -100)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-100, 100), new PVector(100, 100)); W.addBoundry(bBottom);

  
  // Excluded Zones
  // outside
  var z = [];
  z[0] = new PVector(-150, -150);
  z[1] = new PVector(-100, -150);
  z[2] = new PVector(-100, 150);
  z[3] = new PVector(-150, 150);
  W.addExcludedZone(z);
  
  z = [];
  z[0] = new PVector(150, -150);
  z[1] = new PVector(100, -150);
  z[2] = new PVector(100, 150);
  z[3] = new PVector(150, 150);
  W.addExcludedZone(z);
  
  z = [];
  z[0] = new PVector(-100, 100);
  z[1] = new PVector(100, 100);
  z[2] = new PVector(100, 150);
  z[3] = new PVector(-100, 150);
  W.addExcludedZone(z);
  
  z = [];
  z[0] = new PVector(-100, -100);
  z[1] = new PVector(100, -100);
  z[2] = new PVector(100, -150);
  z[3] = new PVector(-100, -150);
  W.addExcludedZone(z);
  
  
  
  // Particles
  for (int i = 0; i < 100; i++)
  {
    Particle p = new Particle(new PVector(random(40)-20, 40+random(40)-20, 0)); W.addParticle(p);
  }
  
  selectedP = null;
}