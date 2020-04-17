void Setup_Simulation4()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  ParticleRadius = 10;
  ParticleMass = 10;
  
  SpringNaturalLength = 20;
  SpringConstant = 1;
  SpringDamping = 0.05;
  ConnectLength = 40;
  if (simChange) { ConnectionProbability = 1; StickProbability = 0; }
  
  Gravity = 0.2;
  EnergyLoss =  0.2;
  
  Rotation = 0;
  Temperature = 0;
  ////////////////////////////////////////////
  
  
  // Boundries
  Boundry bLeft = new Boundry(new PVector(-100, -100), new PVector(-100, 100)); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(new PVector(100, 100), new PVector(100, -100)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(100, -100), new PVector(-100, -100)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-100, 100), new PVector(100, 100)); W.addBoundry(bBottom);

  // Particles
  Particle p1 = new Particle(new PVector(-30, -80, 0)); W.addParticle(p1);
  Particle p2 = new Particle(new PVector(0, 0, 0)); W.addParticle(p2);
  
  selectedP = p1;
}