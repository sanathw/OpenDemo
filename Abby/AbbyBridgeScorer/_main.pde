
Controller c = new Controller(-180, -120);

void setup()
{
  //doZoom = false; doTranslate = false; doRotate = false;
  setSize(400, 300, P2D, FIT_INSIDE, this); // this has to be the last line in this function
}

void drawBackground(var g)
{
  //g.gradientBackground2(VERTICAL, color(0,133,123), color(198,224,0));//, 0.5, color(255, 0, 0));
  g.background(255);
}

void loadFile(files)
{ 
  var file = files[0]; if (!file) return; var fileReader = new FileReader;
  fileReader.onload = function()
  {// do stuff with file here var fileDataBuffer = this.result;
  }
  fileReader.readAsArrayBuffer(file);
}

void draw()
{
  initDraw();
  
  c.draw();
}