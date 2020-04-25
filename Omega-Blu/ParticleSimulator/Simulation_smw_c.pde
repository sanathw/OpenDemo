void Setup_Simulation_smw_c()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 10;
  ParticleMass = 10;
  
  // Note that these spring values only apply if the ConnectionProbability hits
  SpringNaturalLength = 30;  // Ideally should be 2 x ParticleRadius. If this is 2 x ParticleRadius or greater then more viscous. If less there is more solid, but more force to fly off.
  SpringConstant = 0.5;       // Low values more viscous, High values more solid
  SpringDamping = 0.5;     // Low values more viscous, High values more solid
  ConnectLength = 40;       // Ideally around 2 x ParticleRadius. But should be >= SpringNaturalLength. The greater the value the more viscous
  MaxSprings = 8;           // Less springs the more viscous. More springs the more solid, but the demo will run slower
  
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
  modelOffset = new PVector(0, 0); // if '+' button in debug pressed then can use mouse to move
  gearRatio = 0; // model roation as a ration of Rotation above (-2 is a good value)  
  
  // Boundries
  Boundry bLeft = new Boundry(new PVector(-100*s, -100*s), new PVector(-100*s, 100*s)); W.addBoundry(bLeft);
  Boundry bRight = new Boundry(new PVector(100*s, 100*s), new PVector(100*s, -100*s)); W.addBoundry(bRight);
  Boundry bTop = new Boundry(new PVector(100*s, -100*s), new PVector(-100*s, -100*s)); W.addBoundry(bTop);
  Boundry bBottom = new Boundry(new PVector(-100*s, 100*s), new PVector(100*s, 100*s)); W.addBoundry(bBottom);
  
  // Particles
  Particle p1 = new Particle(new PVector(-30*s, -80*s)); W.addParticle(p1);
  Particle p2 = new Particle(new PVector(0*s, 0*s)); W.addParticle(p2);
  
  selectedP = p1;
  overrideMove = true;
}