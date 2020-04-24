boolean loop = true;
boolean stopAfter = false;

int simulation = 1;

var selectedP = null;
double Rotation = 0;
double totalRotation = 0;
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
  doRotation = false;
  AddSpecialParicles = false;
  debugMessage = "";
  debugHUDMessage1 = "";
  debugHUDMessage2 = "";
  debugHUDMessage3 = "";
  overrideMove = false;
   
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
}

void draw()
{
  updateDisplayInfo();
  initDraw();
  
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
    
    if (doRotation && frameCount % 1 == 0) {W.rotateZ(Rotation); totalRotation += Rotation}
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
    rotate(totalRotation);
    imageMode(CENTER);
    image(g, 0, 0);
    popMatrix();
  }
  
  
  //if (SHOW_DEBUG)
  //{
    fill(0, 90);
    textAlign(CENTER, CENTER);
    text(debugMessage, 0, -130);
  //}
  
  if (stopAfter) loop = false;
}
