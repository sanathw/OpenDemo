void Setup_Simulation_smw_a()
{
  ////////////////////////////////////////////
  // SETUP CONSTANTS
  
  //density
  ParticleRadius = 10;
  ParticleMass = 5;
  
  // Note that these spring values only apply if the ConnectionProbability hits
  SpringNaturalLength = 6;  // Ideally should be 2 x ParticleRadius. If this is 2 x ParticleRadius or greater then more viscous. If less there is more solid, but more force to fly off.
  SpringConstant = 1;       // Low values more viscous, High values more solid
  SpringDamping = 0.05;     // Low values more viscous, High values more solid
  ConnectLength = 10;       // Ideally around 2 x ParticleRadius. But should be >= SpringNaturalLength. The greater the value the more viscous
  MaxSprings = 8;           // Less springs the more viscous. More springs the more solid, but the demo will run slower
  
  if (simChange) { Rotation = 0; StickProbability = 0; ConnectionProbability = 0; }
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
  Boundry b1 = new Boundry(new PVector(-50*s, 80*s), new PVector(70*s, 90*s)); W.addBoundry(b1);

  // Particles
  Particle p1 = new Particle(new PVector(-30*s, -80*s)); W.addParticle(p1);
  Particle p2 = new Particle(new PVector(0*s, 0*s)); W.addParticle(p2);
  
  selectedP = p1;
}