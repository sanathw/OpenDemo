void Setup_Simulation2()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  ParticleRadius = 5;
  ParticleMass = 5;
  
  SpringNaturalLength = 40;
  SpringConstant = 0.0005;
  SpringDamping = 0.05;
  
  Gravity = 0.02;
  ConnectLength = 30;
  BreakLength = 50;
  
  Rotation = 0.001;  //0.1
  ////////////////////////////////////////////
  
  
  // Boundries
  Boundry bLeft = new Boundry(new PVector(-100, -100, 0), new PVector(-100, 100, 0), new PVector(0, 0, 0)); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(new PVector(100, 100, 0), new PVector(100, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(100, -100, 0), new PVector(-100, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-100, 100, 0), new PVector(100, 100, 0), new PVector(0, 0, 0)); W.addBoundry(bBottom);

  // Particles
  //Particle p1 = new Particle(new PVector(-30, -80, 0)); p1.F = new PVector(0, 10, 0); W.addParticle(p1);
  //Particle p2 = new Particle(new PVector(0, 0, 0)); p2.F = new PVector(0, 0.5, 0); W.addParticle(p2);
  
  Particle p1 = new Particle(new PVector(0, -20, 0)); W.addParticle(p1);
  
  for (int i = 0; i < 100; i++)
  {
    Particle p = new Particle(new PVector(random(40)-20, random(40)-20, 0)); W.addParticle(p);
  }
  
  selectedP = p1;
}