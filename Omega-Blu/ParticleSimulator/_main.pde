boolean loop = true;
var selectedP;
double Rotation = 0.001;

World W = new World();

void setup()
{
  Setup_Simulation2();
  setSize(300, 300, P2D, FIT_INSIDE, this);
}

void drawBackground(var g)
{
  g.background(255);
}


void draw()
{ 
  if (loop == false) return;
  initDraw();
  
  if (mousePressed) {selectedP.l.set(mouseX, mouseY, 0); selectedP.v.set(0, 0, 0); selectedP.stuck = false;}
  
  W.rotateZ(Rotation);
  
  W.update();
  W.draw();
  
  
}
