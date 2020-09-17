PFont fontNormal;
PFont font1;
PImage imgBack = [];
imgBackId = 0;

PImage imgClubs; pImage imgHearts; PImage imgDiamonds; PImage imgSpades;
//PImage imgBlur;

Controller c = new Controller(-175, -118);
var testMode = false;
PImage imgCoin;
var doSound = true;
var doCoins = true;

void setup()
{
  fontNormal = createFont("Lucida Sans", 12); textAlign(CENTER, CENTER);
  font1 = createFont("Arial Bold", 14); textAlign(CENTER, CENTER);
  
  imgBack[0] = loadImage("./_resources/back_small_navy.png");
  imgBack[1] = loadImage("./_resources/back_small.png");
  imgBack[2] = loadImage("./_resources/back2_small.png");
  imgBack[3] = loadImage("./_resources/back2a_small.png");
  imgBack[4] = loadImage("./_resources/back3_small.png");
  imgBack[5] = loadImage("./_resources/back4_small.png");
  imgBack[6] = loadImage("./_resources/back4a_small.png");
  imgBack[7] = loadImage("./_resources/back5_small.jpg");
  imgBack[8] = loadImage("./_resources/back6_small.png");
  imgBack[9] = loadImage("./_resources/Untitled_small.png");
  
  imgClubs = loadImage("./_resources/Clubs_small.png");
  imgHearts = loadImage("./_resources/Hearts_small.png");
  imgDiamonds = loadImage("./_resources/Diamonds_small.png"); 
  imgSpades = loadImage("./_resources/Spades_small.png");
  
  //imgBlur = loadImage("./_resources/Blur.png");
  imgCoin = loadImage("./_resources/Coin.png");
  
  doZoom = false; doTranslate = false; doRotate = false;
  setSize(400, 300, P2D, FIT_INSIDE, this); // this has to be the last line in this function
}

void drawBackground(var g)
{
  //g.gradientBackground2(VERTICAL, color(0,133,123), color(198,224,0));//, 0.5, color(255, 0, 0));
  g.background(255);
  //g.imageMode(CENTER);
  //g.image(imgBack);
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
  
  pushMatrix();
  imageMode(CENTER);
  scale(1, 1);
  image(imgBack[imgBackId], 0, 0, 400, 300);
  popMatrix();
  
  c.draw();
}

void Calculate()
{
  c.Calculate();
}