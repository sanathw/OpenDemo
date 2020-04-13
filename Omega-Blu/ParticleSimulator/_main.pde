boolean loop = true;
var selectedP = null;
double Rotation = 0.001;
boolean doRotation = false;
double Temperature = 0;
int simulation = 1;
World W = new World();


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

void draw()
{
  if (loop == false) return;
  
  updateDisplayInfo();
  initDraw();
  
  if (mousePressed && selectedP) {selectedP.l.set(mouseX, mouseY, 0); selectedP.v.set(0, 0, 0); selectedP.stuck = false;}
  
  if (doRotation) W.rotateZ(Rotation);
  
  for (int i = 0; i < 2; i++)
  W.update();
  
  W.draw();
}
