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


void setup()
{
  setupSimulation();  
  setSize(300, 300, P2D, FIT_INSIDE, this);
}

void drawBackground(var g)
{
  var c = 240;
  g.background(255, c, c);
}

void createG()
{
  g = createGraphics(sw, sh, P2D);
  g.translate(sw/2, sh/2);
  g.ellipseMode(RADIUS); g.fill(255,0,0); g.stroke(0), g.strokeWeight(0.001);
}

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
  Rotation = 0;
  totalRotation = 0;
  doRotation = false;
   
  switch (simulation)
  {
    case 1: Setup_Simulation1(); break;
    case 2: Setup_Simulation2(); break;
    case 3: Setup_Simulation3(); break;
    case 4: Setup_Simulation4(); break;
    case 5: Setup_Simulation5(); break;
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
    W.update();
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
