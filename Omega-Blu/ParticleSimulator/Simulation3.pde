void Setup_Simulation3()
{
  //
  ParticleRadius = 10;
  ParticleMass = 5;
  //
  SpringNaturalLength = 40;
  SpringConstant = 0.25;
  SpringDamping = 0.05;
  
  //
  Gravity = 0.2;
  ConnectLength = 40;
  BreakLength = 60;
  
  Rotation = 0;
  Temperature = 0;
  
  
  // Boundries
  Boundry b1 = new Boundry(new PVector(-50, 80), new PVector(70, 90)); W.addBoundry(b1);

  // Particles
  //Particle p1 = new Particle(new PVector(-30, -80, 0)); p1.F = new PVector(0, 10, 0); W.addParticle(p1);
  //Particle p2 = new Particle(new PVector(0, 0, 0)); p2.F = new PVector(0, 0.5, 0); W.addParticle(p2);
  
  Particle p1 = new Particle(new PVector(-30, -80, 0)); W.addParticle(p1);
  Particle p2 = new Particle(new PVector(0, 0, 0)); W.addParticle(p2);
  
  selectedP = p1;
}