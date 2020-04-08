float dw; //displayWidth
float dh; //displayHeight
float h_dw; //half_displayWidth
float h_dh; //half_displayHeight

float sw; //sketchWidth
float sh; //sketchHeight
float h_sw; //half_sketchWidth
float h_sh; //half_sketchHeight

float s; //scale

boolean isRotated = false;


final boolean SHOW_AS_HORIZONTAL = true;
final boolean SHOW_AS_VERTICAL = false;
final boolean SHOW_AT_TOP = true;
final boolean SHOW_AT_LEFT = true;
final boolean SHOW_AT_BOTTOM = false;
final boolean SHOW_AT_RIGHT = false;
final boolean START_OPENED = true;
final boolean START_CLOSED = false;

final boolean HORIZONTAL = true;
final boolean VERTICAL = false;



int mode; //P2D or P3D
boolean isFitInside;
final boolean FIT_INSIDE = true;
final boolean FIT_OUTSIDE = false;


void setSize(float i_sw, float i_sh, int i_mode, boolean i_isFitInside, var i_pjs)
{
  mode = i_mode;
  size(screen.width, screen.height, mode);
  sw = i_sw; sh = i_sh;
  h_sw = sw / 2; h_sh = sh / 2;
  isFitInside = i_isFitInside;
  noLoop();
  pjs = i_pjs;
  pjsCM.setContainer(null);
  pjsCM.sizeChanged();
}

void setKeyPressed(int i_key)
{
  key = i_key;
  keyPressed();
}

void setKeyReleased(int i_key)
{
  key = i_key;
  keyReleased();
}


void sizeChanged(float i_ox, float i_oy, boolean i_isRotated)
{
  isRotated = i_isRotated;

  if (isRotated == false)
  {
    dw = width - 2 * i_ox;
    dh = height - 2 * i_oy;
  }
  else
  {
    dh = width - 2 * i_ox;
    dw = height - 2 * i_oy;
  }
  
  s = 1;
  float sx = dw / sw;
  float sy = dh / sh;
  
  if (isFitInside == true) s = min(sx, sy); // Fit inside
  else s = max(sx, sy); // Fit outside
  
  dw = dw / s;
  dh = dh / s;
  
  h_dw = dw / 2;
  h_dh = dh / 2;
}


float lastMouseX = 0;
float lastMouseY = 0;
boolean isMainSketchActive = false;
void setMouse(float i_mouseX, float i_mouseY, float i_containerWidth, float i_containerHeight)
{
  mouseX = map(i_mouseX, 0, i_containerWidth, -h_dw, +h_dw);
  mouseY = map(i_mouseY, 0, i_containerHeight, -h_dh, +h_dh);
  lastMouseX = mouseX;
  lastMouseY = mouseY;
  isMainSketchActive = true;
}

void restoreLastMouse()
{
  mouseX = lastMouseX;
  mouseY = lastMouseY;
} 


float zoom = 1;
float tx = 0;
float ty = 0;

float d_zoom = 0;
float d_tx = 0;
float d_ty = 0;

float p_d_zoom = 0;
float p_d_tx = 0;
float p_d_ty = 0;

//PMatrix3D cam = new PMatrix3D();
//PMatrix3D T = new PMatrix3D();
PMatrix3D R = new PMatrix3D();
boolean doZoom = true;
boolean doTranslate = true;
boolean doRotate = true;


void setTransform(float i_d_zoom, float i_d_rx, float i_d_ry, float i_d_rz, float i_d_tx, float i_d_ty)
{
  d_zoom = i_d_zoom;
  d_rx = i_d_rx;
  d_ry = i_d_ry;
  d_rz = i_d_rz;
  d_tx = i_d_tx;
  d_ty = i_d_ty;
  
  if (doZoom == true) 
  {
    if (i_d_zoom == 1) zoom = zoom * 1.2;
    if (i_d_zoom == -1) zoom = zoom / 1.2
  }
  
  if (doRotate == true && mode == P3D)
  {
    PMatrix3D tempR = new PMatrix3D();
    tempR.rotateX(i_d_rx);
    tempR.rotateY(i_d_ry);
    tempR.rotateZ(i_d_rz);
    tempR.apply(R);
    R = tempR.get();
  }
  
  if (doTranslate == true)
  {
    tx = tx + i_d_tx/(zoom);
    ty = ty + i_d_ty/(zoom);
    //T.translate(tx, ty);
  }
  
  //isTransformChanged = true;
}

void initDraw()
{
  background(0, 0); //transparent
  translate(width/2, height/2);
  if (isRotated == true) rotate(-HALF_PI);
  scale(s, s);
  
  
  
  if (doZoom == true) 
  {
    scale(zoom);
    
    if (isMainSketchActive == true)
    {
      mouseX = mouseX / zoom;
      mouseY = mouseY / zoom;
    }
  }
  
  if (doTranslate == true) 
  {
    translate(tx, ty);
    
    if (isMainSketchActive == true)
    {
      mouseX = mouseX - tx;
      mouseY = mouseY - ty;
    }
  }
  
  
  if (mode == P3D)
  { 
    
    
    /*f = new float[16]; f = T.array();
    applyMatrix(
       f[0], f[1], f[2], f[3],
       f[4], f[5], f[6], f[7],
       f[8], f[9], f[10], f[11],
       f[12], f[13], f[14], f[15]);
       T.reset();*/
       
       /*if (doTranslate == true)
       {
         translate(tx, ty, 0);
         
         
         PVector vs = new PVector(-tx, -ty, 0);
         PVector vt = new PVector(0, 0, 0);
         R.mult(vs, vt);
         translate(-tx-vt.x, -ty-vt.y, 0);
       }*/
       
      /* if (doTranslate == true) 
      {
        translate(tx, ty);
        //mouseX = mouseX - tx;
        //mouseY = mouseY - ty;
        
        //PVector vs = new PVector(tx, ty, 0);
        //PVector vt = new PVector(0, 0, 0);
        //R.mult(vs, vt);
        //translate(vt.x, vt.y, vt.z);
      }*/
      
      // rotate inverse
      
      // translate
       
       // rotate back
       if (doRotate == true)
       {
        float[] f = new float[16]; f = R.array();
        applyMatrix(
           f[0], f[1], f[2], f[3],
           f[4], f[5], f[6], f[7],
           f[8], f[9], f[10], f[11],
           f[12], f[13], f[14], f[15]);
       }
       

      
    
  }
  /*else
  {
    if (doTranslate == true) 
    {
      translate(tx, ty);
      mouseX = mouseX - tx;
      mouseY = mouseY - ty;
    }
  }*/
  
  isMainSketchActive = false;
}

boolean pmousePressed = false;
void postDraw()
{
  //isTransformChanged = false;
  p_d_zoom = d_zoom;
  p_tx = d_tx;
  p_ty = d_ty;
  pmousePressed = mousePressed;
}
