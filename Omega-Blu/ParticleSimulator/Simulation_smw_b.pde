void Setup_Simulation_smw_b()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 10;
  ParticleMass = 10;
  
  // Note that these spring values only apply if the ConnectionProbability hits
  SpringNaturalLength = 20;
  SpringConstant = 1;
  SpringDamping = 0.05;
  ConnectLength = 40;
  
  if (simChange) { Rotation = 0; StickProbability = 0; ConnectionProbability = 1; }
  // StickProbability is the probability of sticking to a wall
  // ConnectionProbability is the probability of becoming a blob
  
  // Note that this is accelration (i.e. gravity is accelration and not a Force)
  Gravity = 0.2;
  
  // 0 is lossless so full bounce, 1 is total loss so no bounce
  EnergyLoss =  0.2;
  
  ////////////////////////////////////////////
  // MODEL CONFIG
  
  var s = 1; // scale  
  
  // Boundries
  Boundry bLeft = new Boundry(new PVector(-100*s, -100*s), new PVector(-100*s, 100*s)); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(new PVector(100*s, 100*s), new PVector(100*s, -100*s)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(100*s, -100*s), new PVector(-100*s, -100*s)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-100*s, 100*s), new PVector(100*s, 100*s)); W.addBoundry(bBottom);
  
  // Particles
  Particle p1 = new Particle(new PVector(-30*s, -80*s)); W.addParticle(p1);
  Particle p2 = new Particle(new PVector(0*s, 0*s)); W.addParticle(p2);
  
  selectedP = p1;
}