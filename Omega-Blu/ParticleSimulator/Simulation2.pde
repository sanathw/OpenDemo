void Setup_Simulation2()
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
  
  Rotation = 0.02;
  Temperature = 0.02;
  ////////////////////////////////////////////
  
  
  // Boundries
  Boundry b;
  //Left
  b = new Boundry(new PVector(-60, -100, 0), new PVector(-60, -10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(-60, -10, 0), new PVector(-30, -10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(-30, -10, 0), new PVector(-30, 10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(-30, 10, 0), new PVector(-60, 10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(-60, 10, 0), new PVector(-60, 100, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  
  //Right
  b = new Boundry(new PVector(60, -10, 0), new PVector(60, -100, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(30, -10, 0), new PVector(60, -10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(30, 10, 0), new PVector(30, -10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(60, 10, 0), new PVector(30, 10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  b = new Boundry(new PVector(60, 100, 0), new PVector(60, 10, 0), new PVector(0, 0, 0)); W.addBoundry(b);
  
  //Boundry bRight = new Boundry(new PVector(100, 100, 0), new PVector(100, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(60, -100, 0), new PVector(-60, -100, 0), new PVector(0, 0, 0)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-60, 100, 0), new PVector(60, 100, 0), new PVector(0, 0, 0)); W.addBoundry(bBottom);

  
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
  
  //left notch
  z = [];
  z[0] = new PVector(-60, 10);
  z[1] = new PVector(-30, 10);
  z[2] = new PVector(-30, -10);
  z[3] = new PVector(-60, -10);
  W.addExcludedZone(z);
  
  z = [];
  z[0] = new PVector(60, 10);
  z[1] = new PVector(30, 10);
  z[2] = new PVector(30, -10);
  z[3] = new PVector(60, -10);
  W.addExcludedZone(z);
  
  
  // Particles
  for (int i = 0; i < 100; i++)
  {
    Particle p = new Particle(new PVector(random(40)-20, 80+random(40)-20, 0)); W.addParticle(p);
  }
  
  selectedP = null;
}