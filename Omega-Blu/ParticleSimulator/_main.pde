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
   
  switch (simulation)
  {
    case 1: Setup_Simulation1(); break;
    case 2: Setup_Simulation2(); break;
    case 3: Setup_Simulation3(); break;
    case 4: Setup_Simulation4(); break;
    case 5: Setup_Simulation_smw_a(); break;
    case 6: Setup_Simulation_smw_b(); break;
    case 7: Setup_Simulation_smw_c(); break;
  }
}

void draw()
{
  updateDisplayInfo();
  initDraw();
  
  if (loop)
  {
    if (mousePressed && selectedP) {selectedP.l.set(mouseX, mouseY, 0); selectedP.v.set(0, 0, 0);}
    
    if (doRotation) {W.rotateZ(Rotation); totalRotation += Rotation}
    for (int i = 0; i < 1; i++) W.update();
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
  
  if (stopAfter) loop = false;
}
