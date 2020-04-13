boolean loop = true;
var selectedP = null;
double Rotation = 0.001;
boolean doRotation = false;
double Temperature = 0;
int simulation = 1;
boolean showTouch = false;
World W = new World();

PGraphics2D g;
double aa = 0;

//boolean sim = 10;

void setup()
{
  setupSimulation();
  //W.rotateZ(PI/3);
  
  /*var v1 = new PVector(9, 9);
  var v2 = [];
  v2[0] = new PVector(-10, -10);
  v2[1] = new PVector(10, -10);
  v2[2] = new PVector(10, 10);
  v2[3] = new PVector(-10, 10);
  //var v3 = Utils.isInsidePolygon(v1, v2);
  var v3 = Utils.pixelInPoly(v1, v2);
  println(v3); */
  
  setSize(300, 300, P2D, FIT_INSIDE, this);
}

void drawBackground(var g)
{
  var c = map (Temperature, 0, 0.4, 255, 0);
  g.background(255, c, c);
}

void createG()
{
  g = createGraphics(300, 300, P2D);
  g.strokeWeight(1);
  g.noFill();
  g.translate(300/2, 300/2);
  g.ellipseMode(RADIUS);
  g.fill(255,0,0); g.stroke(0), g.strokeWeight(0.001);
}

void draw()
{
  if (loop == false) return;
  
  
  
  updateDisplayInfo();
  initDraw();
  
  //sim--;
  //if (sim > 0) return;
  //sim =0;
  
  if (mousePressed && selectedP) {selectedP.l.set(mouseX, mouseY, 0); selectedP.v.set(0, 0, 0); selectedP.stuck = false;}
  
  if (doRotation) {W.rotateZ(Rotation); aa += Rotation}
  
  //for (int i = 0; i < 2; i++)
  W.update();
  
  W.draw();
  
  pushMatrix();
  rotate(aa);
  if (g == null) {createG();}
  if (g != null)
  {
    imageMode(CENTER);
    image(g, 0, 0);
  }
  popMatrix();
}

void setupSimulation()
{
  if (g != null ) g.background(0, 0);
  
  if (W != null)
  {
    W.P.clear();
    W.S.clear();
    W.B.clear();
    W.Z.clear();
  }
  else
  {
  
  
  W = new World();
  }
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
