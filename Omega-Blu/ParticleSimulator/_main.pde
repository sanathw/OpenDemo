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
  setSize(300, 300, P2D, FIT_INSIDE, this);
}

void drawBackground(var g)
{
  g.background(255, 255 *(1-(Temperature/2)), 255 *(1-(Temperature/2)));
}


void draw()
{ 
  if (loop == false) return;
  updateDisplayInfo();
  initDraw();
  
  if (mousePressed && selectedP) {selectedP.l.set(mouseX, mouseY, 0); selectedP.v.set(0, 0, 0); selectedP.stuck = false;}
  
  if (doRotation) W.rotateZ(Rotation);
  
  W.update();
  W.draw();
  
  
}
