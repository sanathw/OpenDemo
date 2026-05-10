// http://localhost:5050/0_Sandbox/TestTemplate/main.html
//.......................................................................


//https://thesmarthappyproject.com/fibonacci-in-a-sunflower/

// mousePressed, mouseX, mouseY
// debug by println();

PGraphics2D g;
var n = 0; // current dot number
var c = 5; // scaling factor (adjust for density)...Increasing this will space the dots further apart

var angleChange = 137.508; //goldern angle
//var goldenAngle = radians(angleChange);//137.508); // convert goldern angle to radians
var maxN = 500;
var doAnimate = false;
var doGrow = true;
var doColorState = 0;

var a = 0;
var r = 0;
var x = 0;
var y = 0;

void setup()
{
  //doZoom = false; doTranslate = false; doRotate = false;
  setSize(400, 400, P2D, FIT_INSIDE, this); // this has to be the last line in this function
  
  ellipseMode(RADIUS);
}

void drawBackground(var g)
{
  //g.gradientBackground2(VERTICAL, color(0,133,123), color(198,224,0));//, 0.5, color(255, 0, 0));
  
  //g.background(255, 255, 0);
  
  switch (doColorState)
  {
    case 0:
      g.background(255, 255, 0);
    break;
    
    case 1:
      g.background(90, 255, 90);
    break;
    
    case 2:
      g.background(255, 90, 10);
    break;
    
    case 3:
      g.background(90, 200, 255);
    break;
    
    case 4:
      g.background(255, 90, 200);
    break;
    
    case 5:
      g.background(0, 0, 0);
    break;
  }
}

void createG()
{
 int s = max(sw, sh);
 g = createGraphics(s, s, P2D);
 g.strokeWeight(1);
 g.translate(200, 200);
 g.ellipseMode(RADIUS);
}


void draw()
{
  initDraw();
  
  
  if (g == null) {createG();}
  if (g != null)
  { 

    if (doGrow)
    {
      if (n < maxN)
      {
        doProcess();
        n++;
      }
      else doGrow = false;
    }
    else
    {
      if (doAnimate) 
      {
        angleChange += 0.004;
        if (angleChange > 360) angleChange = 0;
      }
      
      n = 0;
      g.background(0, 0);
      for (int i = 0; i < maxN; i++)
      {
        doProcess();
        n++;
      }
    }
    
    
    noStroke();
    fill(200, 200, 0, 120);
    ellipse(0, 0, r*1.5, r*1.5);
    fill(120, 120, 90, 120);
    ellipse(0, 0, r*1.3, r*1.3);
    fill(20, 10, 0);
    ellipse(0, 0, r*1, r*1);
    
    imageMode(CENTER);
    image(g, 0, 0);
  }
}

void  doProcess()
{
  var goldenAngle = radians(angleChange);
  
  a = n * goldenAngle;
  r = c * sqrt(n);   // Fermat's spiral formula. This specific sqrt(n) relationship is what differenciates a Fermat spiral from a standard spiral, ensuring even distribution across the circle. 
  
  x = r * cos(a);
  y = r * sin(a);
  
  var dotSize = map(n, 0, 500, 2, 7);
  
  g.stroke(0, 90); 
  
  switch (doColorState)
  {
    case 0:
      g.fill(255, 255, 0);
    break;
    
    case 1:
      g.fill(random(255), 255, 0);
    break;
    
    case 2:
      g.fill(255, random(255), 0);
    break;
    
    case 3:
      g.fill(0, 255, random(255));
    break;
    
    case 4:
      g.fill(255, 0, random(255));
    break;
    
    case 5:
      g.fill(random(255), random(255), random(255));
    break;
  }
  
  
  g.ellipse(x, y, dotSize, dotSize);
}
