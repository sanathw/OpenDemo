void Setup_Simulation3()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 10;
  ParticleMass = 5;
  
  SpringNaturalLength = 1;
  SpringConstant = 1;
  SpringDamping = 0.05;
  ConnectLength = 10;
  if (simChange) { StickProbability = 0; ConnectionProbability = 0; } // stick to wall and blob probability
                                                                      // if stick to wall then particle get used up
  
  // Note that this is accelration (i.e. gravity is accelration and not a Force)
  Gravity = 0.2;
  
  // 0 is lossless so full bounce, 1 is total loss so no bounce
  EnergyLoss =  0.2;
  
  Rotation = 0;
    
  ////////////////////////////////////////////
  
  // Boundries
  Boundry b1 = new Boundry(new PVector(-50, 80), new PVector(70, 90)); W.addBoundry(b1);

  // Particles
  //Particle p1 = new Particle(new PVector(-30, -80, 0)); p1.F = new PVector(0, 10, 0); W.addParticle(p1);
  //Particle p2 = new Particle(new PVector(0, 0, 0)); p2.F = new PVector(0, 0.5, 0); W.addParticle(p2);
  
  Particle p1 = new Particle(new PVector(-30, -80, 0)); W.addParticle(p1);
  Particle p2 = new Particle(new PVector(0, 0, 0)); W.addParticle(p2);
  
  selectedP = p1;
}