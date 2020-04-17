void Setup_Simulation3()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 10;
  ParticleMass = 5;
  
  // Note that these spring values only apply if the ConnectionProbability hits
  SpringNaturalLength = 1;
  SpringConstant = 1;
  SpringDamping = 0.05;
  ConnectLength = 10;
  
  if (simChange) { Rotation = 0; StickProbability = 0; ConnectionProbability = 0; }
  // StickProbability is the probability of sticking to a wall
  // ConnectionProbability is the probability of becoming a blob
  
  // Note that this is accelration (i.e. gravity is accelration and not a Force)
  Gravity = 0.2;
  
  // 0 is lossless so full bounce, 1 is total loss so no bounce
  EnergyLoss =  0.2;
  
  ////////////////////////////////////////////
  
  // Boundries
  Boundry b1 = new Boundry(new PVector(-50, 80), new PVector(70, 90)); W.addBoundry(b1);

  // Particles
  Particle p1 = new Particle(new PVector(-30, -80, 0)); W.addParticle(p1);
  Particle p2 = new Particle(new PVector(0, 0, 0)); W.addParticle(p2);
  
  selectedP = p1;
}