void Setup_Simulation1()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  ParticleRadius = 3;
  ParticleMass = 5;
  
  SpringNaturalLength = 50;//20;
  SpringConstant = 0.05; // 0.05
  SpringDamping = 0.05; // 0.05
  
  Gravity = 0.2;
  ConnectLength = 30;
  BreakLength = 60;//40;
  
  Rotation = 0.04; // 0.04
  Temperature = 0.02; // 0.02
  ////////////////////////////////////////////
  
  
  // Boundries
  //Box
  Boundry bLeft = new Boundry(new PVector(-60, -100, 0), new PVector(-60, 100, 0), new PVector(0, 0, 0)); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(new PVector(60, 100, 0), new PVector(60, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(60, -100, 0), new PVector(-60, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-60, 100, 0), new PVector(60, 100, 0), new PVector(0, 0, 0)); W.addBoundry(bBottom);

  // Left triangle
  Boundry tL1 = new Boundry(new PVector(-50, 0, 0), new PVector(-30, -10, 0), new PVector(0, 0, 0)); W.addBoundry(tL1);
  Boundry tL2 = new Boundry(new PVector(-30, 10, 0), new PVector(-50, 0, 0),  new PVector(0, 0, 0)); W.addBoundry(tL2);
  Boundry tL3 = new Boundry(new PVector(-30, -10, 0), new PVector(-30, 10, 0),  new PVector(0, 0, 0)); W.addBoundry(tL3);
  
  // Right Triangle
  Boundry tR1 = new Boundry(new PVector(30, -10, 0), new PVector(50, 0, 0), new PVector(0, 0, 0)); W.addBoundry(tR1);
  Boundry tR2 = new Boundry(new PVector(50, 0, 0),  new PVector(30, 10, 0), new PVector(0, 0, 0)); W.addBoundry(tR2);
  Boundry tR3 = new Boundry(new PVector(30, 10, 0), new PVector(30, -10, 0),  new PVector(0, 0, 0)); W.addBoundry(tR3);
  
  
  // Excluded Zones
  // outside
  var z = [];
  z[0] = new PVector(-150, -150);
  z[1] = new PVector(-60, -150);
  z[2] = new PVector(-60, 150);
  z[3] = new PVector(-150, 150);
  W.addExcludedZone(z);
  
  z = [];
  z[0] = new PVector(150, -150);
  z[1] = new PVector(60, -150);
  z[2] = new PVector(60, 150);
  z[3] = new PVector(150, 150);
  W.addExcludedZone(z);
  
  z = [];
  z[0] = new PVector(-60, 100);
  z[1] = new PVector(60, 100);
  z[2] = new PVector(60, 150);
  z[3] = new PVector(-60, 150);
  W.addExcludedZone(z);
  
  z = [];
  z[0] = new PVector(-60, -100);
  z[1] = new PVector(60, -100);
  z[2] = new PVector(60, -150);
  z[3] = new PVector(-60, -150);
  W.addExcludedZone(z);
  
  // left triangle
  z = [];
  z[0] = new PVector(-50, 0);
  z[1] = new PVector(-30, -10);
  z[2] = new PVector(-30, 10);
  W.addExcludedZone(z);
  
  // right triangle
  z = [];
  z[0] = new PVector(50, 0);
  z[1] = new PVector(30, -10);
  z[2] = new PVector(30, 10);
  W.addExcludedZone(z);
  
  // Particles
  //*
  for (int i = 0; i < 100; i++)
  {
    Particle p = new Particle(new PVector(random(40)-20, 80+random(40)-20, 0)); W.addParticle(p);
  } //*/
  
  for (int i = 0; i < 20; i++)
  {
    Particle p = new Particle(new PVector(random(4)-2, -20+(i*1), 0)); W.addParticle(p);
  }
  
  Particle p = new Particle(new PVector(0, -40, 0)); W.addParticle(p);
  
  selectedP = null;
}