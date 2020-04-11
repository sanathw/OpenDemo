void Setup_Simulation5()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  ParticleRadius = 3;
  ParticleMass = 5;
  
  SpringNaturalLength = 20;
  SpringConstant = 0.05; // 0.05
  SpringDamping = 0.05; // 0.05
  
  Gravity = 0.2;
  ConnectLength = 30;
  BreakLength = 40;
  
  Rotation = 0;
  Temperature = 0;
  ////////////////////////////////////////////
  
  
  // Boundries
  Boundry bLeft = new Boundry(new PVector(-100, -100, 0), new PVector(-100, 100, 0), new PVector(0, 0, 0)); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(new PVector(100, 100, 0), new PVector(100, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(100, -100, 0), new PVector(-100, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-100, 100, 0), new PVector(100, 100, 0), new PVector(0, 0, 0)); W.addBoundry(bBottom);

  // Particles
  for (int i = 0; i < 100; i++)
  {
    Particle p = new Particle(new PVector(random(40)-20, 80+random(40)-20, 0)); W.addParticle(p);
  }
  
  selectedP = null;
}