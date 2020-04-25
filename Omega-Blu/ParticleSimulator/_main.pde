boolean loop = true;
boolean stopAfter = false;

int simulation = 1;

var selectedP = null;
double Rotation = 0;
double totalRotation = 0;
double modelRotation = 0;
double totalModelRotation = 0;
PVector modelOffset = new PVector();
PVector userModelOffset = new PVector();
double gearRatio = 0;
boolean doRotation = false;
boolean showTouch = false;
boolean simChange = true;
World W = new World();
PGraphics2D g;

int screenWidth = 300;
int screenHeight = 300;
double half_screenWidth = screenWidth/ 2;
double half_screenHeight = screenHeight/ 2;

boolean SHOW_DEBUG = false;
boolean AddSpecialParicles = false;
boolean showVelocity = false;
boolean showInfo = true;
boolean showModelOffset = false;
boolean moveParticle = false;
boolean overrideMove = false;

string debugMessage = "";
string debugHUDMessage1 = "";
string debugHUDMessage2 = "";
string debugHUDMessage3 = "";

void setup()
{
  setupSimulation();  
  setSize(screenWidth, screenHeight, P2D, FIT_INSIDE, this);
}

void drawBackground(var g)
{
  var c = 240;
  g.background(255, c, c);
}

void createG()
{
  g = createGraphics(screenWidth, screenHeight, P2D);
  g.translate(half_screenWidth, half_screenHeight);
  g.ellipseMode(RADIUS); g.fill(255,0,0); g.stroke(0), g.strokeWeight(0.001);
}

// On the desktop you can pause/play the simulation by pressing the spacebar
// and step a frame aa time by pressing the right arrow key
void keyPressed()
{
  if ((int)key == ' ') { loop = !loop; stopAfter = false; }
  
  if (key == CODED)
  {
    if (keyCode == RIGHT) {loop = true; stopAfter = true;}
  }
}

void setupSimulation()
{
  if (g != null ) {g.background(0, 0);}
  W = new World();

  selectedP = null;
  totalRotation = 0;
  totalModelRotation = 0;
  doRotation = false;
  AddSpecialParicles = false;
  debugMessage = "";
  debugHUDMessage1 = "";
  debugHUDMessage2 = "";
  debugHUDMessage3 = "";
  overrideMove = false;
  
  modelOffset = new PVector();
   
  switch (simulation)
  {
    case 1: Setup_Simulation1(); break;
    case 2: Setup_Simulation2(); break;
    case 3: Setup_Simulation3(); break;
    case 4: Setup_Simulation4(); break;
    case 5: Setup_Simulation_smw_a(); break;
    case 6: Setup_Simulation_smw_b(); break;
    case 7: Setup_Simulation_smw_c(); break;
    case 8: Setup_Simulation_smw_d(); break;
    case 9: Setup_Simulation_smw_e(); break;
  }
  
  if (!simChange) modelOffset = userModelOffset.get();
  else userModelOffset = modelOffset.get();
  
  W.moveByOffset(modelOffset.x, modelOffset.y);
  // particles
  for (int i = 0; i < W.P.size(); i++)
  {
    var p = W.P.get(i);
    p.l.x += modelOffset.x;
    p.l.y += modelOffset.y;
  }
}

void draw()
{
  updateDisplayInfo();
  initDraw();
  
  if (showModelOffset && mousePressed) 
  {
    if (pmousePressed)
    {
      var dx = (mouseX-pmouseX);
      var dy = (mouseY-pmouseY);
      
      modelOffset.x += dx; modelOffset.y += dy;
      userModelOffset = modelOffset.get();
      W.moveByOffset(dx, dy);
    }
  }
  
  if (mousePressed && !pmousePressed)
  {
    int selectedIndex = -1;
    for (int i = 0; i < W.P.size(); i++)
    {
      var p = W.P.get(i);
      var d = dist(p.l.x, p.l.y, mouseX, mouseY);
      if (d <= p.r) { selectedIndex = i; break; }
    }
    
    if (selectedIndex > -1)
    {
      var p = W.P.get(selectedIndex);
      if (showInfo)
      {
        // Show info
        selectedP = p;
      }
      else
      {
        // remove particle if clicked
        var p = W.P.get(selectedIndex);
        if (p == selectedP) selectedP = null;
        W.P.remove(selectedIndex);
      }
    }
    else
    {
      if (!overrideMove) selectedP = null;
    }
  }
  
  if ((overrideMove||moveParticle) && mousePressed && selectedP) {selectedP.l.set(mouseX, mouseY, 0); selectedP.v.set(0, 0, 0);}
  
  if (loop)
  {
    debugHUDMessage1 = "";
    debugHUDMessage2 = "";
    debugHUDMessage3 = "";
    
    if (doRotation && frameCount % 1 == 0) 
    {
      modelRotation = Rotation * gearRatio;
      
      W.rotateZ(Rotation); 
      totalRotation += Rotation; 
      totalModelRotation += modelRotation;
    }
      
    for (int i = 0; i < 1; i++) W.update();
    
    if (AddSpecialParicles)
    {
      if (W.P.size() < 300 && frameCount % 20 == 0)
      {
        Pvector l = new PVector(random(2)-1, 0);
        Particle p = new Particle(l); W.addParticle(p);
      }
    }
  }
    
  
  
  
  W.draw();
  
  // display touches
  if (g == null) {createG();}
  else
  {
    pushMatrix();
    translate(modelOffset.x, modelOffset.y);
    //rotate(totalRotation);// - 
    //rotate(modelRotation);
    rotate(totalRotation);
    //translate(modelOffset.x, modelOffset.y);
    
    rotate(totalModelRotation);
    imageMode(CENTER);
    image(g, 0, 0);
    popMatrix();
  }
  
  
  
  
  if (showModelOffset)
  {
    var d = modelOffset.mag();
    //stroke(0, 155, 0, 120);
    //stroke(0, 0, 155, 90); 
    stroke(0, 120); 
    strokeWeight(0.5); 
    noFill(); ellipse(0, 0, d, d);
    fill(255, 120); ellipse(0, 0, 8, 8);
    //fill(0, 155, 0, 120); 
    fill(0, 120); 
    //fill(55, 200, 100, 90); 
    ellipse(0, 0, 4, 4);
    
    pushMatrix();
    rotate(totalRotation);
    line (0, -10, 0, -20); line (0, 10, 0, 20);
    line (-10, 0, -20, 0); line (10, 0, 20, 0);
    popMatrix();
    
    
    stroke(0, 120, 0, 120); 
    //stroke(0, 0, 155, 90); 
    strokeWeight(0.5); 
    //noFill(); ellipse(modelOffset.x, modelOffset.y, d, d);
    fill(255, 120); ellipse(modelOffset.x, modelOffset.y, 6, 6);
    fill(0, 200, 0, 120);
    //fill(0, 90); 
    
    stroke(0, 190, 0, 120); 
    ellipse(modelOffset.x, modelOffset.y, 4, 4);
    
    stroke(0, 90, 0, 120); 
    pushMatrix();
    translate(modelOffset.x, modelOffset.y);
    rotate(totalRotation + totalModelRotation);
    line (0, -8, 0, -15); line (0, 8, 0, 15);
    line (-8, 0, -15, 0); line (8, 0, 15, 0);
    popMatrix();
  
    stroke(0, 90); strokeWeight(0.5);
    line(0, 0, modelOffset.x, modelOffset.y);
  }
  

  fill(0, 90);
  textAlign(CENTER, CENTER);
  text(debugMessage, 0, -130);

  
  if (stopAfter) loop = false;
}
