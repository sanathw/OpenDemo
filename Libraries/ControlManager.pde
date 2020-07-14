// http://localhost:5050/0_Sandbox/TestTemplate/main.html
//.......................................................................
//   * @pjs globalKeyEvents="true"; */

var cvs;


float sx; // scale x
float sy; // scale y
float ox; // offset x
float oy; // offset y
boolean isRotated = true;
int charSize = 40;
float charScale = 1;


ControlManager cm = new ControlManager();// cm = null;
boolean isUISet = false;

void setup()
{
  //cvs = document.getElementById("mySketch");
  sizeChanged();
  ctx = externals.context;
  pjsCM = this;
  
  //cm.setParameters(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM, 0.25, START_OPENED);
  textSize(charSize);
  
  removeLoadingImage();
}

void sizeChanged() 
{
  cvs = document.getElementById("mySketch");
  size(document.body.clientWidth, document.body.clientHeight, P2D);
  
  if (cm != null) cm.calculateSize();

  if (pjs != null)
  {
    float aspectPjs = pjs.width / pjs.height;
    float aspect = width / height;
    
    isRotated = false;
    if ((aspectPjs > 1 && aspect < 1) || (aspectPjs < 1 && aspect > 1)) isRotated = true;
    
    ox = 0;
    oy = 0;
      
    if (isRotated == false)
    {
      // Normal
      sx = width / pjs.width;
      sy = height / pjs.height;
     
      if (sx > sy) oy = ((pjs.height * sx) - height) / sx;
      else if (sy > sx) ox = ((pjs.width * sy) - width) / sy;
    }
    else
    {
      // Rotated
      sx = height / pjs.width;
      sy = width / pjs.height;
     
      if (sx > sy) oy = ((pjs.height * sx) - width) / sx;
      else if (sy > sx) ox = ((pjs.width * sy) - height) / sy;
    }
    
    oy = oy / 2;
    ox = ox / 2;
    pjs.sizeChanged(ox, oy, isRotated);
  }
}

float d_rx = 0;
float d_ry = 0;
float d_rz = 0;
float d_tx = 0;
float d_ty = 0;

// Touch.........................................
int fingers = 0;
float pdist;
float cdist;
float tx1; float ty1;
float tx2; float ty2;
float px1; float py1;
float px2; float py2;

void touchStart(TouchEvent touchEvent) 
{
  isMainSketchActive = true;
  //println(touchEvent.touches[0].offsetX);
  
  mouseX = touchEvent.touches[0].offsetX;
  mouseY = touchEvent.touches[0].offsetY;
  pmouseX = mouseX;
  pmouseY = mouseY;
  mousePressed = true;
  
  tx1 = mouseX; 
  ty1 = mouseY;
  px1 = tx1;
  py1 = ty1;
  
  if (touchEvent.touches.length > 1)
  {
    tx2 = touchEvent.touches[1].offsetX; 
    ty2 = touchEvent.touches[1].offsetY;
    px2 = tx2;
    py2 = ty2;
    cdist = abs(dist(tx1, ty1, tx2, ty2));
    pdist = cdist;
    //isZoomTranslateRotate = true;
  }
  
  fingers = touchEvent.touches.length;
  
  //println(pjs);
  //if (pjs.DoMousePressed) pjs.DoMousePressed();
}

void touchMove(TouchEvent touchEvent) 
{
  isMainSketchActive = true;
  
  //println(touchEvent.touches[0]);
  mouseX = touchEvent.touches[0].offsetX;
  mouseY = touchEvent.touches[0].offsetY;
  mousePressed = true;
  
  
  
  tx1 = mouseX; 
  ty1 = mouseY;
  if (touchEvent.touches.length > 1)
  {
    //isZoomTranslateRotate = true;
    tx2 = touchEvent.touches[1].offsetX; 
    ty2 = touchEvent.touches[1].offsetY;
    
    int dx1 = 0;
    if ((tx1 - px1) > 0 ) dx1 = 1;
    else if ((tx1 - px1) < 0 ) dx1 = -1;
    
    int dy1 = 0;
    if ((ty1 - py1) > 0 ) dy1 = 1;
    else if ((ty1 - py1) < 0 ) dy1 = -1;
    
    int dx2 = 0;
    if ((tx2 - px2) > 0 ) dx2 = 1;
    else if ((tx2 - px2) < 0 ) dx2 = -1;
    
    int dy2 = 0;
    if ((ty2 - py2) > 0 ) dy2 = 1;
    else if ((ty2 - py2) < 0 ) dy2 = -1;
    
    cdist = abs(dist(tx1, ty1, tx2, ty2));
    
    if (dx1 == dx2 && dy1 == dy2 && ((dx1 != 0 && dx2 != 0) || (dy1 != 0 && dy2 != 0)))
    {
      //tx = tx + (tx2 - px2) / zoom;
      //ty = ty + (ty2 - py2) / zoom;
      d_tx = tx2 - px2;
      d_ty = ty2 - py2;
    }
    else if (abs(cdist - pdist) > (0.02 * pdist)) //if ((dx1 != dx2) ||(dy1 != dy2))
    {
      mouseScroll = cdist - pdist;
      mouseScrolled();
    }
    
    /*
    //if (cdist != pdist)
    if (abs(cdist - pdist) > (0.02 * pdist))
    {
      mouseScroll = cdist - pdist;
      mouseScrolled();
    }
    else
    {
      tx = tx + tx2 - px2;
      ty = ty + ty2 - py2;
    }*/
    
    pdist = cdist;
    
    px2 = tx2;
    py2 = ty2;
  }
  
  px1 = tx1;
  py1 = ty1;
  
  // empty the canvas
  //noStroke();
  //fill(255);
  //rect(0, 0, 400, 300);
 
  // draw circles at where fingers touch
  //fill(180, 180, 100);
  //for (int i = 0; i < touchEvent.touches.length; i++) {
  //  int x = touchEvent.touches[i].offsetX;
  //  int y = touchEvent.touches[i].offsetY;
  //  
  //  ellipse(x, y, 50, 50);
  //}
  
  //if (pjs.DoMouseDragged) pjs.DoMouseDragged();
}

void touchEnd(TouchEvent touchEvent) 
{
  isMainSketchActive = false;
  mousePressed = false;
  fingers = 0;
  
  //if (pjs.DoMouseReleased) pjs.DoMouseReleased();
}

void touchCancel(TouchEvent touchEvent)
{
  isMainSketchActive = false;
  mousePressed = false;
   fingers = 0;
   
   //if (pjs.DoMouseReleased) pjs.DoMouseReleased();
}
// .............................................

// Keyboard.........................................
void doBackspace()
{
  if (selectedTextBox != null) selectedTextBox.backspace();
}

void keyPressed()
{
  //alert(selectedTextBox);
  if (selectedTextBox != null)
  {
    if (key == CODED) 
    {
      if (keyCode == LEFT) selectedTextBox.moveLeft();
      if (keyCode == RIGHT) selectedTextBox.moveRight();
    }
    else
    {
      if (key == 127) 
      {
        selectedTextBox.delete();
      }
      else
      {
        String s = new String(key);
        selectedTextBox.add(s);
      }
    }
  }
  
  if (pjs != null) {pjs.setKeyCode(keyCode); pjs.setKeyPressed(key);}
}

void keyReleased()
{
  if (pjs != null) {pjs.setKeyCode(keyCode); pjs.setKeyReleased(key, keyCode);}
}
// .............................................

// Scroll.........................................
float d_zoom = 0;//1;
void mouseScrolled()
{
  if (isDisplay == false) return;
  if (mouseScroll > 0) { d_zoom = 1;}//1.2;}//zoom * 1.2; }
  else if (mouseScroll < 0) { d_zoom = -1;}//1/1.2;}// zoom / 1.2; }
}
// .............................................


boolean isMainSketchActive = true;
void mousePressed()
{
  isMainSketchActive = true;
  //if (pjs.DoMousePressed) pjs.DoMousePressed();
}

void mouseMoved()
{
  isMainSketchActive = true;
  //if (pjs.DoMouseMoved) pjs.DoMouseMoved();
}

void mouseDragged()
{
  isMainSketchActive = true;
  //if (pjs.DoMouseDragged) pjs.DoMouseDragged();
}

void mouseReleased()
{
  //isMainSketchActive = true;
  mouseButton = LEFT;
  //if (pjs.DoMouseReleased) pjs.DoMouseReleased();
}

void resetMouse()
{
  mousePressed = false;
  pmousePressed = false;
}

void resetControlManager()
{
  cm = new ControlManager();
  isUISet = false;
}

boolean pmousePressed = false;
void draw()
{
  if (doFirstMouseDown == true) {mousePressed = true; mouseButton = LEFT; mouseX = firstMouseX; mouseY = firstMouseY; pmouseX = mouseX; pmouseY = mouseY; doFirstMouseDown = false; document.removeEventListener('touchstart', onTouchStart);}
  
  if (isUISet == false && pjs != null) {pjs.setupUI(); isUISet = true;}
  
  if (cm != null) cm.update();
  
  if (pjs != null)
  {
    if (cm != null) pjs.processUI();
    
    if ((cm == null) || (cm != null && cm.isControlDown == false))
    {
        if (cm.pointerMode == 0 && fingers < 2 && mouseButton != RIGHT)
        {
          pjs.mousePressed = mousePressed;
          pjs.mouseButton = mouseButton;
            
          if (isMainSketchActive == true)
          {
            pjs.setMouse(mouseX, mouseY, width, height);
          }
        }
      
      //ismouseActive = false;
      
      // rotation ...............................
      if 
      (
        (fingers == 0 && mousePressed == true && pmousePressed == true && mouseButton == LEFT)
        ||
        (fingers < 2 && mousePressed == true && pmousePressed == true && mouseButton != RIGHT && cm.pointerMode == 0)
      )
      {
        d_ry = d_ry + ((float)(mouseX-pmouseX) * map(abs(mouseY-height/2), 0, height/2, 1, 0) /100f) ;
        d_rx = d_rx + ((float)(mouseY-pmouseY) * map(abs(mouseX-width/2), 0, width/2, 1, 0)/-100f);
        d_rz = d_rz + ((float)(mouseY-pmouseY) * map(mouseX, 0, width, -1, 1)/100f);
        d_rz = d_rz + ((float)(mouseX-pmouseX) * map(mouseY, 0, height, -1, 1) /-100f) ;
      }
      
      // translation ...............................
      if 
      (
        (fingers == 0 && mousePressed == true && pmousePressed == true && mouseButton == RIGHT)
        ||
        (fingers < 2 && mousePressed == true && pmousePressed == true && mouseButton != RIGHT && cm.pointerMode == 1)
      )
      {
        //tx = tx + (mouseX - pmouseX)/zoom;
        //ty = ty + (mouseY - pmouseY)/zoom;
        d_tx = mouseX - pmouseX;
        d_ty = mouseY - pmouseY;
      }
      
      // zoom ....................................
      if (fingers < 2 && mousePressed == true && pmousePressed == true && mouseButton != RIGHT && cm.pointerMode == 2)
      {
        float d1 = abs(dist(width/2, height/2, pmouseX, pmouseY));
        float d2 = abs(dist(width/2, height/2, mouseX, mouseY));
        mouseScroll = d2 - d1;
        mouseScrolled();
      }
      
    }
    else
    {
      pjs.mousePressed = false;
      //pjs.restoreLastMouse();
      //if (fingers > 0) isUsingFingerOnCM = true;
      isMainSketchActive = false;
    }
    
    //isMainSketchActive = false;
    
    pjs.setTransform(d_zoom, d_rx, d_ry, d_rz, d_tx, d_ty);
    d_rx = 0; d_ry = 0; d_rz = 0; d_tx = 0; d_ty = 0; d_zoom = 0;
    
    //background(190); //<<<<SANATH
    pushMatrix();
    pjs.drawBackground(this);
    popMatrix();
    
    pjs.redraw(); //<<<<SANATH
    
    ctx.save();
    
    
    /*var my_gradient=ctx.createLinearGradient(0,0,0,height);
    my_gradient.addColorStop(0,'rgba(0,133,123,1)');
    //my_gradient.addColorStop(0.5,'#ff0000');
    //my_gradient.addColorStop(0.75,'green');
    my_gradient.addColorStop(1,'rgba(198,224,0,1)');
    ctx.fillStyle=my_gradient;
    ctx.fillRect(0,0,width, height);*/
    
    
    
    
    float x;  float y;
    float x1; float y1;
    float x2; float y2;
    
    float cx1; float cy1;
    float cx2; float cy2;
    
    if (isRotated == false)
    {
      // Normal
      /*
      x = (width/2)-(pjs.width/2);
      y = (height/2)-(pjs.height/2);
      x1 = x + ox;
      y1 = y + oy;
      x2 = x + pjs.width - ox;
      y2 = y + pjs.height - oy;
      
      ctx.drawImage(cvs, x, y);
      
      stroke(0); strokeWeight(1);
      
      // horzontal
      line(x, y1, x + pjs.width, y1);
      line(x, y2, x + pjs.width, y2);
      
      // verical
      line(x1, y, x1, y + pjs.height);
      line(x2, y, x2, y + pjs.height);
      */
      
      // expand
      cx1 = ox; 
      cy1 = oy;
      cx2 = pjs.width - ox;
      cy2 = pjs.height - oy;
      ctx.drawImage(cvs, cx1, cy1, (cx2-cx1), (cy2-cy1), 0, 0, width, height); //<<<<SANATH
    }
    else
    {
      // Rotated
      /*
      x = (height/2)-(pjs.width/2);
      y = -(width/2)-(pjs.height/2);
      x1 = x + ox;
      y1 = y + oy;
      x2 = x + pjs.width - ox;
      y2 = y + pjs.height - oy;
      
      ctx.rotate(HALF_PI);
      ctx.drawImage(cvs, x, y);
      
      stroke(0); strokeWeight(1);
      
      // horizontal
      line(x1, y + pjs.height, x1, y);
      line(x2, y + pjs.height, x2, y);
      
      // vertical
      line(x, y2, x + pjs.width, y2);
      line(x, y1, x + pjs.width, y1);
      */
      
      
      // expand
      cx1 = ox; 
      cy1 = oy;
      cx2 = pjs.width - ox;
      cy2 = pjs.height - oy;
      ctx.rotate(HALF_PI);
      ctx.drawImage(cvs, cx1, cy1, (cx2-cx1), (cy2-cy1), 0, -width, height, width); //<<<<<SANATH
    }
    ctx.restore();
    
    pushMatrix();
    pjs.drawHUD(this);
    pjs.postDraw();
    popMatrix();
  }
  
  // Draw here in this Control Manager
  //fill(255); stroke(0); strokeWeight(3); rectMode(CENTER); rect(100, 100, 30, 20);
  //if (mousePressed == true) 
  //line(0, 0, mouseX, mouseY);
  
  if (cm != null) 
  {
    cm.draw();
    //if (pjs.maualDraw != null) pjs.maualDraw(this);
  }
  
  pmousePressed = mousePressed;
}

void drawText(String i_txt, i_x, i_y, i_s)
{
  float sx = width /  (charSize * 20);
  float sy = height / (charSize * 20);
  float s = min(sx, sy);
  
  pushMatrix();
  translate(i_x, i_y);
  scale(s);
  scale(i_s);
  text(i_txt, 0, 0);
  popMatrix();
  
}



//##################################################################################################

void setupCM(boolean i_showAsHorizontal, boolean i_showAtTop, float i_expandFactor, boolean i_startOpened) 
{
  //cm.setParameters(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM, 0.25, START_OPENED);
  cm.showMenuControl = true;
  //cm = new ControlManager();
  cm.setParameters(i_showAsHorizontal, i_showAtTop, i_expandFactor, i_startOpened);
}

void setCMGradient(color c1, color c2)
{
  cm.setGradient(c1, c2);
}

void HideControlBar()
{
  cm.showPercent = 0; 
  cm.isOpened = false
}

void ShowControlBar()
{
  cm.showPercent = 1; 
  cm.isOpened = true
}

void showLocation(boolean i_showAsHorizontal, boolean i_showAtTop) 
{
  cm.showLocation(i_showAsHorizontal, i_showAtTop);
}

Container currentContainer = null;

void setContainer(Container i_currentContainer)
{
  currentContainer = i_currentContainer;
}

void ResetUpdate()
{
  cm.ResetUpdate();
}

Container addContainer(float i_px1, float i_py1, float i_pw, float i_ph)
{
  Container c = new Container(i_px1, i_py1, i_pw, i_ph);
  if (currentContainer == null) cm.add(c);
  else currentContainer.add(c);
  return c;
}

Button addButton(float i_px1, float i_py1, float i_pw, float i_ph, String t)
{
  //println("addButton Start");
  Button b = new Button(i_px1, i_py1, i_pw, i_ph, t);
  if (currentContainer == null) cm.add(b);
  else currentContainer.add(b);
  //println("addButton End");
  return b;
}

ScrollBar addScrollBar(float i_px1, float i_py1, float i_pw, float i_ph, float i_minV, float i_maxV, float i_curV)
{
  ScrollBar sb = new ScrollBar(i_px1, i_py1, i_pw, i_ph, i_minV, i_maxV, i_curV);
  if (currentContainer == null) cm.add(sb);
  else currentContainer.add(sb);
  return sb;
}

TextBox addTextBox(float i_px1, float i_py1, float i_pw, float i_ph, String t)
{
  TextBox t = new TextBox(i_px1, i_py1, i_pw, i_ph, t);
  if (currentContainer == null) cm.add(t);
  else currentContainer.add(t);
  return t;
}

LabelBox addLabelBox(float i_px1, float i_py1, float i_pw, float i_ph, String t)
{
  LabelBox l = new LabelBox(i_px1, i_py1, i_pw, i_ph, t);
  if (currentContainer == null) cm.add(l);
  else currentContainer.add(l);
  return l;
}

KeyboardContainer addKeyboardContainer(float i_px1, float i_py1, float i_pw, float i_ph)
{
  KeyboardContainer kbContainer = new KeyboardContainer(i_px1, i_py1, i_pw, i_ph);
  if (currentContainer == null) cm.add(kbContainer);
  else currentContainer.add(kbContainer);
  return kbContainer;
}

KeyboardCtrl addKeyboardCtrl(float i_px1, float i_py1, float i_pw, float i_ph, TextBox i_txtBox)
{
  KeyboardCtrl kbctrl = new KeyboardCtrl(i_px1, i_py1, i_pw, i_ph, i_txtBox);
  return kbctrl;
}

float getCharScale()
{
  return charScale;
}

float getCharSize()
{
  return charSize;
}

final boolean HORIZONTAL = true;
final boolean VERTICAL = false;

void gradientBackground2(boolean i_direction, color c1, color c2)
{
  //background(99, 178, 61);
  //println((green(c1)+green(c2)/2));
  color b = color((red(c1)+red(c2))/2, (green(c1)+green(c2))/2, (blue(c1)+blue(c2))/2, (alpha(c1)+alpha(c2))/2); //blendColor(c1, c2, OVERLAY);
  background(b);
  //println(green(b));
  
  //g.background(255, 0, 0);
  
  // Gradient
  var my_gradient;
  
  if (i_direction == HORIZONTAL) my_gradient=ctx.createLinearGradient(0,0,width, 0); // pjsCM.width
  else my_gradient=ctx.createLinearGradient(0,0,0,height);
  
  
  //my_gradient.addColorStop(0,'rgba(0,133,123,1)');
  my_gradient.addColorStop(0,color.toString(c1));
  
  //my_gradient.addColorStop(0.5,'#ff0000');
  //my_gradient.addColorStop(0.75,'green');
  //my_gradient.addColorStop(1,'rgba(198,224,0,1)');
  my_gradient.addColorStop(1,color.toString(c2));
  ctx.fillStyle=my_gradient;
  ctx.fillRect(0,0,width, height);
}

void gradientBackground3(boolean i_direction, color c1, color c3, float pct, color c2)
{
  //background(99, 178, 61);
  color b = color((red(c1)+red(c3))/2, (green(c1)+green(c3))/2, (blue(c1)+blue(c3))/2, (alpha(c1)+alpha(c3))/2); //blendColor(c1, c2, OVERLAY);
  background(b);
  //g.background(255, 0, 0);
  
  // Gradient
  var my_gradient;
  
  if (i_direction == HORIZONTAL) my_gradient=ctx.createLinearGradient(0,0,width, 0); // pjsCM.width
  else my_gradient=ctx.createLinearGradient(0,0,0,height);
  
  
  //my_gradient.addColorStop(0,'rgba(0,133,123,1)');
  my_gradient.addColorStop(0,color.toString(c1));
  
  //my_gradient.addColorStop(0.5,'#ff0000');
  //my_gradient.addColorStop(0.75,'green');
  //my_gradient.addColorStop(1,'rgba(198,224,0,1)');
  my_gradient.addColorStop(pct,color.toString(c2));
  
  my_gradient.addColorStop(1,color.toString(c3));
  ctx.fillStyle=my_gradient;
  ctx.fillRect(0,0,width, height);
}

void beginText(float px, float py, color c, int i_hAlign, i_vAlign)
{
  fill(c);
  textAlign(i_hAlign, i_vAlign);
  pushMatrix();
  translate(width*px, height*py);
  scale(getCharScale()); 
}

void endText()
{ 
  popMatrix();
}

//________________________________________________________________________
// CONTROL MANAGER
//########################################################################
boolean isBackgroundDown = false;
Control focusControl = null;
TextBox selectedTextBox = null;

final boolean SHOW_AS_HORIZONTAL = true;
final boolean SHOW_AS_VERTICAL = false;
final boolean SHOW_AT_TOP = true;
final boolean SHOW_AT_LEFT = true;
final boolean SHOW_AT_BOTTOM = false;
final boolean SHOW_AT_RIGHT = false;
final boolean START_OPENED = true;
final boolean START_CLOSED = false;


class ControlManager
{
  ArrayList controls = new ArrayList();
  float showPercent;
  float showChange = 0;
  final float showChangeStep = 0.15;// 0.075;
  boolean showAsHorizontal;
  boolean showAtTop; 
  float expandFactor;
  float expandSize;
  boolean isOpened;
  float minScreenSize;
  float ctrSize;
  boolean isControlDown = false;
  float x1; float y1;
  float x2; float y2;
  
  color gradient_c1;
  color gradient_c2;
  boolean showGradient = false;
  
  void setParameters(boolean i_showAsHorizontal, boolean i_showAtTop, float i_expandFactor, boolean i_startOpened) 
  { 
    expandFactor = i_expandFactor; if (i_startOpened == true) {showPercent = 1; isOpened = true;} else {showPercent = 0; isOpened = false}
    
    showLocation(i_showAsHorizontal, i_showAtTop);
  }
  
  void setGradient(color c1, color c2)
  {
    showGradient = true;
    gradient_c1 = c1;
    gradient_c2 = c2;
  }
  
  void showLocation(boolean i_showAsHorizontal, boolean i_showAtTop)
  {
    showAsHorizontal = i_showAsHorizontal; showAtTop = i_showAtTop;
    calculateSize();
  }
  
  void add(Control c) { c.cm = this; controls.add(c);}
  
  void calculateSize()
  {
    if (isMobile == true)
    {
      minScreenSize = min(window.innerWidth, window.innerHeight);
      ctrSize = 0.05 * minScreenSize;
    }
    else
    {
      // Control size is based on the Screen size x 0.25 because it's a mointor and the mouse pointer is snammer than your fingure print.
      // So the size is right for a maximised window.
      // BUT as the window gets smaller, you need the control size to get smaller - so you need to use document size.
      // BUT you can't just use document size - because then the control gets too big too quickly.
      // And you can't just use screen size - because the control would not change at all.
      // So the solution below is to keep screen size UNTIL document size is smaller.
      // The document size is without the x 0.25 because thenit's more like the iPhone screen.
      minScreenSize = min(screen.width, screen.height);
      ctrSize = 0.05 * minScreenSize * 0.25;
      
      float t_minScreenSize = min(document.body.clientWidth, document.body.clientHeight);
      float t_ctrSize = 0.05 * t_minScreenSize;
      if (t_ctrSize < ctrSize) ctrSize = t_ctrSize;
    }
    
    half_ctrSize = ctrSize / 2;
    two_ctrSize = ctrSize * 2;
    
    expandSize = expandFactor * two_ctrSize;
    if (showAsHorizontal == true && expandSize > height) expandSize = height;
    if (showAsHorizontal == false && expandSize > width) expandSize = width;
    
    charScale = two_ctrSize / charSize;
  }

  
  boolean showMenuControl = false;
  void update()
  {
    
    if (isBackgroundDown == false)
    {
      if (mousePressed == true)
      {
        if (isControlDown == false)
        {
          if (showMenuControl == true)
          {
            if ((showAsHorizontal == true && showAtTop == true) || (showAsHorizontal == false && showAtTop == true))
            {
              if (mouseX <= two_ctrSize && mouseY <= two_ctrSize) { if (isOpened == true) showChange = -showChangeStep; else showChange = showChangeStep; isControlDown = true; }
            }
            else
            {
              if (mouseX >= (width - two_ctrSize) && mouseY >= (height - two_ctrSize)) { if (isOpened == true) showChange = -showChangeStep; else showChange = showChangeStep; isControlDown = true; }
            }

            if 
            (
              ((showAsHorizontal == true && showAtTop == false) && mouseX >= (width - two_ctrSize) && mouseY >= (height - two_ctrSize-two_ctrSize) && mouseY < (height - two_ctrSize-half_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == false) && mouseX >= (width - two_ctrSize - two_ctrSize) && mouseX < (width - two_ctrSize-half_ctrSize) && mouseY > (height - two_ctrSize+half_ctrSize))
              ||
              ((showAsHorizontal == true && showAtTop == true) && mouseX <= two_ctrSize && mouseY <=  (two_ctrSize+two_ctrSize) && mouseY > (two_ctrSize+half_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == true) && mouseX <= (two_ctrSize + two_ctrSize) && mouseX > (two_ctrSize+half_ctrSize) && mouseY < (two_ctrSize-half_ctrSize))
            ) 
            { 
              pointerMode = pointerMode+1; if (pointerMode > 2) pointerMode = 0; isControlDown = true; 
              isControlDown = true;
            }
            
            if 
            (
              ((showAsHorizontal == true && showAtTop == false) && mouseX >= (width - two_ctrSize) && mouseY >= (height - two_ctrSize-two_ctrSize-two_ctrSize) && mouseY < (height - two_ctrSize-two_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == false) && mouseX >= (width - two_ctrSize - two_ctrSize-two_ctrSize) && mouseX < (width - two_ctrSize-two_ctrSize) && mouseY > (height - two_ctrSize))
              ||
              ((showAsHorizontal == true && showAtTop == true) && mouseX <= two_ctrSize && mouseY <=  (two_ctrSize+two_ctrSize+two_ctrSize) && mouseY > (two_ctrSize+two_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == true) && mouseX <= (two_ctrSize + two_ctrSize+two_ctrSize) && mouseX > (two_ctrSize+two_ctrSize) && mouseY < (two_ctrSize))
            ) 
            { 
              showCode();
              isControlDown = true;
            }
          }
          else
          {
            if 
            (
              ((showAsHorizontal == true && showAtTop == false) && mouseX >= (width - two_ctrSize) && mouseY >= (height - two_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == false) && mouseX >= (width - two_ctrSize) && mouseY > (height-two_ctrSize))
              ||
              ((showAsHorizontal == true && showAtTop == true) && mouseX <= two_ctrSize && mouseY <=(two_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == true) && mouseX <= two_ctrSize && mouseY <=  (two_ctrSize))
            ) 
            { 
              pointerMode = pointerMode+1; if (pointerMode > 2) pointerMode = 0; isControlDown = true; 
              isControlDown = true;
            }
            
            if 
            (
              ((showAsHorizontal == true && showAtTop == false) && mouseX >= (width - two_ctrSize) && mouseY >= (height - two_ctrSize - two_ctrSize)&& mouseY < (height - two_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == false) && mouseX >= (width - two_ctrSize - two_ctrSize) && mouseX < (width - two_ctrSize) && mouseY > (height-two_ctrSize))
              ||
              ((showAsHorizontal == true && showAtTop == true) && mouseX <= two_ctrSize && mouseY <=(two_ctrSize+two_ctrSize)&& mouseY >(two_ctrSize))
              ||
              ((showAsHorizontal == false && showAtTop == true) && mouseX <= (two_ctrSize+two_ctrSize)&& mouseX > (two_ctrSize) && mouseY <=  (two_ctrSize))
            ) 
            {
              showCode();
              isControlDown = true;
            }
            
          }
        }
        
        if (mouseX >= x1 && mouseX <= x2 && mouseY >= y1 && mouseY <= y2) isControlDown = true;
        
      }
      else
      {
        isControlDown = false;
      }
      
      
      
      for (int i = 0; i < controls.size(); i++) 
      { 
        Control c = (Control) controls.get(i); 
        c.update(); 
        
        //isControlItemDown = isControlItemDown || c.isDown;
        //if (focusControl == null && c.isDown == true) {focusControl = c; }// println("SET");}
        isControlDown = isControlDown || c.isDown;  //SANATH
      }
    }
    
    if (isControlDown == false && mousePressed == true) isBackgroundDown = true;
    if (mousePressed == false) {isBackgroundDown = false; focusControl = null;}// isControlItemDown = false;}
    
    //if (mousePressed == true && focusControl == null ) selectedTextBox = null;
    
    showPercent += showChange;
    if (showPercent > 1) {showPercent = 1; showChange =0; isOpened = true;}
    if (showPercent < 0) {showPercent = 0; showChange =0; isOpened = false;}
  }
  
  void ResetUpdate()
  {   
    mousePressed = false;
    /*for (int i = 0; i < controls.size(); i++) 
    { 
      Control c = (Control) controls.get(i); 
      c.update(); 
      
      //isControlItemDown = isControlItemDown || c.isDown;
      //if (focusControl == null && c.isDown == true) {focusControl = c; }// println("SET");}
      isControlDown = isControlDown || c.isDown;  //SANATH
    }*/
  }
  
  int pointerMode = 0;
  
  void draw()
  {
    float expanseStart;
    float b;
    if (showAsHorizontal == true) b = height;
    else b = width;
    
    if (showAtTop == true) expanseStart = (showPercent * expandSize) - expandSize;
    else expanseStart = b - (showPercent * expandSize);
    

    float w;
    float h;
    
    if (showAsHorizontal == true) 
    { 
      x1 = 0; w = width; 
      if (showAtTop == true) {y1 = 0 + expanseStart; h = expandSize;}
      else {y1 = expanseStart; h = expandSize;}
    }
    else 
    { 
      y1 = 0; h = height;
      if (showAtTop == true) {x1 = 0 + expanseStart; w = expandSize;}
      else {x1 = expanseStart; w = expandSize;}
    }
    x2 = x1 + w;
    y2 = y1 + h;
    
    if (!showGradient)
    {
      stroke(0, 50); strokeWeight(1); fill(255, 140); rectMode(CORNERS);
      rect(x1, y1, x2, y2);
    }
    else
    {
    //////////
      var ctx = externals.context;
      var my_gradient;
      if (showAsHorizontal) my_gradient=ctx.createLinearGradient(0,0,width, 0);
      else my_gradient=ctx.createLinearGradient(0,0,0, height);
      my_gradient.addColorStop(0,color.toString(gradient_c1));
      my_gradient.addColorStop(1,color.toString(gradient_c2));
      ctx.fillStyle=my_gradient;
      ctx.fillRect(x1, y1, x2, y2);
    /////////
    }
    
    for (int i = 0; i < controls.size(); i++) 
    { 
      Control c = (Control) controls.get(i); 
      c.draw(x1, y1, x2, y2); 
    }

    
    
    pushMatrix();
    
    if ((showAsHorizontal == true && showAtTop == true) || (showAsHorizontal == false && showAtTop == true)) translate(ctrSize, ctrSize);
    else translate(width - ctrSize, height - ctrSize);
    
     if (showAsHorizontal == true && showAtTop == true) scale(1, 1);
     if (showAsHorizontal == true && showAtTop == false) scale(1, -1);
     if (showAsHorizontal == false && showAtTop == true) rotate(-HALF_PI);
     if (showAsHorizontal == false && showAtTop == false) rotate(HALF_PI);
    
    if (showMenuControl == true)
    {
      stroke(0); strokeWeight(1); fill(255, 140); ellipseMode(CENTER);
      ellipse( 0, 0, two_ctrSize, two_ctrSize);
      stroke(0); strokeWeight(2);
      if (isOpened == true)
      {
        line (0, 0, half_ctrSize, half_ctrSize);
        line (0, 0, -half_ctrSize, half_ctrSize);
      }
      else
      {
        line (0, 0, -half_ctrSize, -half_ctrSize);
        line (0, 0, half_ctrSize, -half_ctrSize);
      }
    }
    
    
    
    
    pushMatrix();
    if (showMenuControl == true) translate(0, two_ctrSize);
    //noStroke(); fill(255, 140); rectMode(CENTER);
    //rect(0, 0, ctrSize, ctrSize);
    
    pushMatrix();
    if (showAsHorizontal == true && showAtTop == false) scale(1, 1);
    if (showAsHorizontal == true && showAtTop == false) scale(1, -1);
    if (showAsHorizontal == false && showAtTop == false) rotate(-HALF_PI);
    if (showAsHorizontal == false && showAtTop == true) rotate(HALF_PI);
    translate(-half_ctrSize/2, -half_ctrSize/2);
    switch (pointerMode)
    {
      case 0:
      {
        // pointer
        stroke(255, 140), strokeWeight(6); drawPointerIcon();
        stroke(0), strokeWeight(2); drawPointerIcon();
        break;
      }
      case 1:
      {
        // translate
        stroke(255, 140), strokeWeight(6); drawTranslateIcon();
        stroke(0), strokeWeight(2); drawTranslateIcon();
        break;
      }
      case 2:
      {
        // scale
        stroke(255, 140), strokeWeight(6); drawScaleIcon();
        stroke(0), strokeWeight(2); drawScaleIcon();
        break;
      }
    }
    popMatrix();
    
    translate(0, two_ctrSize);
    if (showAsHorizontal == true && showAtTop == false) scale(1, 1);
    if (showAsHorizontal == true && showAtTop == false) scale(1, -1);
    if (showAsHorizontal == false && showAtTop == false) rotate(-HALF_PI);
    if (showAsHorizontal == false && showAtTop == true) rotate(HALF_PI);
    ellipseMode(CENTER); noStroke(); fill(255, 140); ellipse(0, 0, ctrSize+half_ctrSize, ctrSize+half_ctrSize);
    scale(0.4); fill(0); drawInfoIcon();
    
    popMatrix();
    
    popMatrix();
  }
}

void drawPointerIcon()
{
  line(0, 0, half_ctrSize, half_ctrSize); line(0, 0, 0, half_ctrSize); line(0, 0, half_ctrSize,0);
}

void drawTranslateIcon()
{
  line(-half_ctrSize/2, half_ctrSize, half_ctrSize, half_ctrSize); line(0, -half_ctrSize/2, 0, half_ctrSize);
}

void drawScaleIcon()
{
  ellipseMode(CENTER); noFill(); ellipse(0, 0, half_ctrSize/2, half_ctrSize/2); ellipse(0, half_ctrSize, half_ctrSize, half_ctrSize);
}

void drawInfoIcon()
{
  text("?", 0, 0);
}

// Example:
// //Button b1 = new Button(0, 0, .25, .25, "A"); // TextBox // add(""), backspase(), clear() //LabelBox //ImageButton //cm.add(b1); //b1.isContinous = true; //b1.isOn = true; //b1.isDisabled = true;

//________________________________________________________________________
// Enable or disable a group of controls
//________________________________________________________________________
class ControlEnableDisableGroup
{
  ArrayList controls = new ArrayList();
  void add(Control c) { controls.add(c); }

  void enable()
  {
    for (int i = 0; i < controls.size(); i++) { Control c = (Control) controls.get(i); c.isDisabled = false;}
  }

  void disable()
  {
    for (int i = 0; i < controls.size(); i++) { Control c = (Control) controls.get(i); c.isDisabled = true;}
  }
}
// Example:
// ControlEnableDisableGroup edg = new ControlEnableDisableGroup(); //add controls as required: edg.add(b1); // edg.disable(); edg.enable();

//________________________________________________________________________
class Container extends Control
{
  ArrayList controls = new ArrayList();
  Control ctr = null;
  boolean hasBorder = true;
  
  Container(float i_px1, float i_py1, float i_pw, float i_ph) 
  { 
    super(i_px1, i_py1, i_pw, i_ph);
  }
  
  void add(Control c)
  {
    controls.add(c);
  }
  
  void clear()
  {
    controls.clear();
  }
 
  void update()
  {
    if (isVisible == false || isDisabled == true) return;
    
    isDown = false;
    doProcess = false;
    
    for (int i = 0; i< controls.size(); i++)
    {
      Control c = (Control) controls.get(i);
      c.update();
      isDown = isDown || c.isDown;
      
      if (c.doProcess == true) { ctr = c; doProcess = true;}
    }
  }
  
 
  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    for (int i = 0; i< controls.size(); i++)
    {
      Control c = (Control) controls.get(i);
      //c.isDisabled = isDisabled;
      c.draw(x1, y1, x2, y2);
    }
    
    if (hasBorder)
    {
      strokeWeight(1); stroke(0); noFill(); rectMode(CORNERS);
      rect(x1, y1, x2, y2);
    }
  }
}

//________________________________________________________________________
class Control
{
  float x1; float y1; float x2; float y2;
  float w; float h;
  float px1; float py1; float pw; float ph;
  
  boolean isOver = false; boolean isDown = false; boolean doProcess = false;
  boolean isDisabled = false;
  boolean isVisible = true;
  Control(float i_px1, float i_py1, float i_pw, float i_ph) { px1 = i_px1; py1 = i_py1; pw = i_pw; ph = i_ph; }
  void update() {}
  void draw(float i_x1, float i_y1, float i_x2, float i_y2){}

  boolean isInside(int x, int y)
  {
    if (x >= x1 && x <= x2 && y >= y1 && y <= y2) return true;
    return false;
  }
  
  void calculateSize(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    float tw = i_x2 - i_x1;
    float th = i_y2 - i_y1;
    
    x1 = i_x1 + tw * px1;
    y1 = i_y1 +th * py1;
    x2 = x1 + tw * pw;
    y2 = y1 + th * ph;
    
    w = x2 - x1;
    h = y2 - y1;
  }
  
  float getFittedTextSize(String txt, float border)
  {
    //textSize(40);
    float sw = textWidth(txt);
    float sh = textAscent() + textDescent();
    
    //float dw = sw / (w - (w * border));
    //float dh = sh / (h - (h * border));
    
    //float d = max(dw, dh);
    //return 40;// /d; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SANATH
    
    float sx = w / (sw + (2 * border * w));
    float sy = h / (sh + (2 * border * h));
    float s = min (sx, sy);
    return s;
  }
}
// Example:
// in controlManagerDoProcess() if (b1.doProcess == true)

//________________________________________________________________________
class Button extends Control
{
  String txt;
  color c1 = color(0, 50); color c2 = color(255); color cText;
  color c3 = color(190, 50);  color c4 = color(190, 200); color c5 = color(0, 0, 255, 150); color c6 = color(255, 0, 0, 150); color c7 = color(0, 255, 0, 150);  color cBack;
  boolean processed = false;
  boolean isContinous = false;
  boolean isOn = false;
  boolean isManualDraw = false;

  Button (float i_px1, float i_py1, float i_pw, float i_ph, String t) { super(i_px1, i_py1, i_pw, i_ph);  txt = t; }

  void update()
  {
    if (isVisible == false || isDisabled == true) return;
    
    isOver = false;
    isDown = false; //SANATH
    doProcess = false;
    
    //TextBox b = (TextBox) focusControl;
    //if (focusControl != null) println(focusControl.x1);
  
  //println(focusControl);
  
  
  
  
    if ( (focusControl == null || focusControl == this) && isDisabled == false)
    {
      if (isInside(mouseX, mouseY) == true)
      {
        if (isMobile == false) isOver = true;
        if (mousePressed == true) 
        {
          isDown = true; 
          
          
          if(processed == false) 
          {
            doProcess = true;  
            if (isContinous == false) processed = true;
          }
        }
      }
    }
    
    if (mousePressed == false) { processed = false; isDown = false;}   //SANATH
  }

  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    if (isManualDraw)
    {
      if (pjs.maualDraw != null) pjs.maualDraw(this);
      return;
    }
    
    if (isDisabled == true)
    {
      cText = c1;
      cBack = c3;
    }
    else
    {
      cText = c2;
      cBack = c4;
      if (isOn == true) cBack = c7;
      if (isOver == true) cBack = c5;
      if (isDown == true) cBack = c6;
    }
    
    noStroke(); fill(cBack); rectMode(CORNERS);
    rect(x1, y1, x2, y2);
    
    /*if (txt.length > 0)
    {
      float s = min((x2-x1) / txt.length, (y2-y1));
      textSize(s);
      
      fill(cText); textAlign(CENTER, CENTER);
      text(txt, (x1 + x2)/2, (y1 + y2)/2);
    }*/
    
    if (txt.length > 0)
    {
      //textSize(getFittedTextSize(txt, 0.1));
      
      fill(cText); textAlign(CENTER, CENTER);
      //text(txt, (x1 + x2)/2, (y1 + y2)/2);*/
      
      pushMatrix();
      translate((x1+x2)/2, (y1 + y2)/2);
      scale(getFittedTextSize(txt, 0.1));
      text(txt, 0, 0);
      popMatrix();
    }
  }
}
// Example:
/* Example of a new Button
class ImageButton extends Button
{
  ImageButton (float i_px1, float i_py1, float i_pw, float i_ph, String t) { super(i_px1, i_py1, i_pw, i_ph, t); }

  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
      // ib1 draw
      //{
        //ib1.txt
        //ib1.isDisabled  cBack = ib1.c3; cText = c1;
        // cBack = ib1.c3; cText = c2;
        //ib1.isOn == true) cBack = ib1.c7;  
        //ib1.isOver == true) cBack = ib1.c5;
        //ib1.isDown == true) cBack = ib1.c6;
        //noStroke(); fill(255, 0, 0); rectMode(CORNERS);
        //rect(ib1.x1, ib1.y1, ib1.x2, ib1.y2);
      //}
  }
  //Button b1 = new Button(0, 0, .25, .25, "A"); // TextBox // add(""), backspase(), clear() //LabelBox //ImageButton //cm.add(b1); //b1.isContinous = true; //b1.isOn = true; //b1.isDisabled = true;
}
*/


//________________________________________________________________________
class ScrollBar extends Control
{
  float minV = 0;
  float maxV = 0;
  float curV = 0;
  
  float lastV;
  
  color c1 = color(190); color c2 = color(0, 0, 255); color cLine;
  color c3 = color(190, 50);  color c4 = color(255, 150);  color cBack;
  
  ScrollBar(float i_px1, float i_py1, float i_pw, float i_ph, float i_minV, float i_maxV, float i_curV) { super(i_px1, i_py1, i_pw, i_ph); setRange(i_minV, i_maxV, i_curV); }
  
  void setRange(float i_minV, float i_maxV, float i_curV)
  {
    minV = i_minV; maxV = i_maxV; curV = i_curV; lastV = curV;
  }
  
  void update()
  {
    if (mousePressed == false) doProcess = false;
    
    if (isVisible == false || isDisabled == true) return;
    
    isDown = false;
    
    if (isDisabled == false && mousePressed == true && focusControl == null && isInside(mouseX, mouseY) == true )
    {
      isDown = true;
      focusControl = this;
    }
    
    if (isDisabled == false && mousePressed == true && focusControl == this )//&& isInside(mouseX, mouseY) == true )
    {
      isDown = true;
      int d = mouseX - x1;
      curV = constrain( map(mouseX, x1, x2, minV, maxV), minV, maxV );
      
      if (curV != lastV) doProcess = true;
      
      lastV = curV;
    }
  }
  
  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    if (isDisabled == true)
    {
      cLine = c1;
      cBack = c3;
    }
    else
    {
      cLine = c2;
      cBack = c3;
    }
    
    stroke(150); strokeWeight(1); fill(cBack); rectMode(CORNERS);
    rect(x1, y1, x2, y2);
    
    int x = (int) (map(curV, minV, maxV, x1, x2));
    stroke(cLine); strokeWeight(1);
    line(x, y1- h/4, x, y2 + h/4);
  }
  
  //doProcess = false;
}


//________________________________________________________________________
class TextBox extends Control
{
  String txt;
  float s = 1;
  float border = 0.05;
  //int txtLength = 0;
  //ArrayList txt = new ArrayList();
  int crt = 0;
  boolean showcrt = true;
  float charWidth;
  float half_charWidth;
  color c1 = color(0, 50); color c2 = color(150); color cText;
  color c3 = color(190, 50);  color c4 = color(255, 150);  color cBack;
  KeyboardContainer kbContainer = null;
  KeyboardCtrl kbctrl = null;
  boolean isCaseSensistive = false;
  boolean isAutoClear = false;

  TextBox(float i_px1, float i_py1, float i_pw, float i_ph, String t) { super(i_px1, i_py1, i_pw, i_ph);  txt = t; crt = txt.length; selectedTextBox = this;}
  
  /*void setText(String t)
  {
    //txt.clear();
    //for (int i = 0; i < t.length; i++)
    //{
    //  txt.add(t[i]);
    //}
    txt = t;
    txtLength = t.length;
  }*/
  
  void attachKeyboard(KeyboardCtrl i_kbctrl, KeyboardContainer i_kbContainer)
  {
    kbContainer = i_kbContainer;
    kbctrl = i_kbctrl;
    
    if (selectedTextBox == this) kbContainer.setKeyboard(kbctrl, this);
  }
 
  void update()
  {
    if (isVisible == false || isDisabled == true) return;
    
    isDown = false;
    
    if (isDisabled == false && mousePressed == true && focusControl == null && isInside(mouseX, mouseY) == true )
    {
      isDown = true;
      focusControl = this;
      //println(this);
      selectedTextBox = this;
      
      if (kbContainer != null && kbctrl != null)
      {
        kbContainer.setKeyboard(kbctrl, this);
      }
      
    }
    
    if (isDisabled == false && mousePressed == true && focusControl == this )//&& isInside(mouseX, mouseY) == true )
    {
      isDown = true;
      int d = mouseX - x1 - (w * border);
      //d = d - half_charWidth + charWidth;
      //d = d / charWidth;
      d = d / s;
      d = d + (charSize / 2);
      //d = d - (20) - (40);
      d = d / charSize;
      crt = (int) d;
      if (crt > txt.length) crt = txt.length;
      //if (crt > txt.size()) crt = txt.size();
      if (crt < 0) crt = 0; 
    }
  }
  
  void moveLeft()
  {
    crt--;
    if (crt < 0) crt = 0;
  }
  
  void moveRight()
  {
    crt++;
    if (crt > txt.length) crt = txt.length;
  }
 
  void backspace()
  {
    if (crt > 0)
    {
      string temp = txt;
      txt = temp.substring(0, crt-1);
      txt = txt + temp.substring(crt);
      /*for (int i = 0; i < txt.length; i++)
      {
        if (i != crt-1) temp = temp + txt[i];
        //else temp = temp + "A";
      }
      txt = temp + " ";
      //txtLength = txtLength -1;*/
      //txtLength = txtLength -1;
      //txt.remove(crt-1);
      
      crt = crt -1;
      if (crt < 0) crt = 0;
    }
    doProcess = true;
  }
  
  void delete()
  {
    if (crt < txt.length)
    {
      string temp = txt;
      txt = temp.substring(0, crt);
      txt = txt + temp.substring(crt+1);
    }
    doProcess = true;
  }
 
  void clear()
  {
    txt = "";
    crt = 0;
    doProcess = true;
  }
  
  void setText(string s)
  {
    txt = s;
    doProcess = true;
  }
 
  void add(string s)
  {
    if (kbctrl != null)
    {
      if (isCaseSensistive == true)
      {
        if (kbctrl.validKeys.indexOf(s) <= -1) return;
      }
      else
      {
        boolean found = false;
        
        s = s.toLowerCase();
        if (kbctrl.validKeys.indexOf(s) > -1) found = true;
        if (found == false)
        {
          s = s.toUpperCase();
          if (kbctrl.validKeys.indexOf(s) > -1) found = true;
        }
        
        if (found == false) return;
      }
    }
    
    string temp = txt;
    txt = temp.substring(0, crt);
    txt = txt + s;
    txt = txt + temp.substring(crt);
    crt++;
    doProcess = true;
  }
 
  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    if (isDisabled == true)
    {
      cText = c1;
      cBack = c3;
      showcrt = false;
    }
    else
    {
      cText = c2;
      cBack = c4;
      showcrt = true;
    }
    
    if (this != selectedTextBox) showcrt = false;
    
    stroke(150); strokeWeight(1); fill(cBack); rectMode(CORNERS);
    //if (selectedTextBox == this) strokeWeight(3);
    rect(x1, y1, x2, y2);
      
    //charWidth = min((x2-x1) / (txt.length + 1), (y2-y1));
    //half_charWidth = charWidth / 2;
    //textSize(charWidth); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SANATH
    //border = 0.05;
    //float sx = ((x2-x1) - (w * border * 2))/ (txt.length * 40);
    //float sy = ((y2-y1) - (h * border * 2)) / 40;
    //s = min(sx, sy);
    
    float sx = ((x2-x1) - (w * border * 2))/ (txt.length * charSize);
    float sy = ((y2-y1) - (h * border * 2)) / charSize;
    s = min(sx, sy);
    
    pushMatrix();
    translate(x1+(w * border) , (y1 + y2) / 2);
    scale(s);
    translate((charSize / 2), 0);
    fill(cText); fill(0);textAlign(CENTER, CENTER);
    for (int i = 0; i < txt.length+1; i++)
    {
      if (i < txt.length)
      {
        //String s = (String) txt.get(i);
        //text(txt[i], x1 + half_charWidth + (charWidth * i), (y1 + y2) / 2);
        //text(txt[i], (charWidth * i), (y1 + y2) / 2);
        text(txt[i], (charSize * i), 0);
      }
      /*if (i==crt && showcrt == true)
      {
        stroke(0, 0, 255); strokeWeight(1);
        int x = x1 + (charWidth * i);
        line(x, y1-(charWidth/3), x, y2+(charWidth/3));
      }*/
    }
    popMatrix();
    
    //pushMatrix();
    //translate(x1, (y1 + y2) / 2);
    //scale(s, 1);
    //translate(20, 0);
    for (int i = 0; i < txt.length+1; i++)
    {
      /*if (i < txt.length)
      {
        //String s = (String) txt.get(i);
        text(txt[i], x1 + half_charWidth + (charWidth * i), (y1 + y2) / 2);
      }*/
      if (i==crt && showcrt == true)
      {
        stroke(0, 0, 255); strokeWeight(1);
        int x;
        
        if ( i == 0) {x = x1; strokeWeight(2);}
        else 
        if (i == txt.length) {x = x2; strokeWeight(2);}
        else 
        {x =  x1 + (w * border) + ((charSize * i) * s); strokeWeight(1);}
        
        //line(x, y1 - (h * border), x, y2 + (h * border));
        line(x, y1, x, y2);
      }
    }
    //popMatrix();
    
    //fill(0);
    //textSize(40);
    //alert(y1); noLoop();
    //text("Hello", x1, y1);
    
    if (isAutoClear == true) clear();
    doProcess = false;
  }
}
// Example:
// //Button b1 = new Button(0, 0, .25, .25, "A"); // TextBox // add(""), backspase(), clear() //LabelBox //ImageButton //cm.add(b1); //b1.isContinous = true; //b1.isOn = true; //b1.isDisabled = true;


//________________________________________________________________________
class KeyboardLine extends Control
{
  String validKeys = "";
  String txt = "";
  ArrayList buttons = new ArrayList();
  TextBox txtBox;
  
  KeyboardLine(float i_px1, float i_py1, float i_pw, float i_ph, String txt, TextBox i_txtBox, boolean i_isContinous) 
  {
    super(i_px1, i_py1, i_pw, i_ph);
    
    txtBox = i_txtBox;
    
    validKeys = txt;
    
    var t = txt;//txt.split(" ");
    
    float gap = 1 / ((t.length*6) + (t.length-1));
    float dw = gap * 6;
    
    for (int i = 0; i < t.length; i++)
    {
      Button b;
      if ( i == 0) b = new Button(dw*i, 0, dw, 1, t[i]);
      else b = new Button((dw+gap)*i, 0, dw, 1, t[i]);
      
      b.isContinous = i_isContinous;
      
      buttons.add(b);
    }
    
  }
  
  void setTextBox(TextBox i_txtBox)
  {
    txtBox = i_txtBox;
  }
 
  void update()
  {
    if (isVisible == false || isDisabled == true) return;
    
    isDown = false;
    doProcess = false;
    
    if (isDisabled == false)
    {
    for (int i = 0; i< buttons.size(); i++)
    {
      Button b = (Button) buttons.get(i);
      b.update();
      isDown = isDown || b.isDown;
      
      //if (isDown == true) {txt = b.txt; doProcess = true;}
      if (b.doProcess == true) { if (txtBox != null) txtBox.add(b.txt); txt = b.txt; doProcess = true;}
    }
    }
  }
  
 
  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    stroke(0); strokeWeight(1); noFill();rectMode(CORNERS);
    rect(x1, y1, x2, y2);
    
    for (int i = 0; i< buttons.size(); i++)
    {
      Button b = (Button) buttons.get(i);
      b.draw(x1, y1, x2, y2);
      
      //if (b.doProcess == true) { txtBox.add(b.txt); txt = b.txt; doProcess = true;}
    }
  }
}

class KeyboardContainer extends Control
{
  KeyboardCtrl keyboard = null;
  String txt = "";
  
  KeyboardContainer(float i_px1, float i_py1, float i_pw, float i_ph)
  { 
    super(i_px1, i_py1, i_pw, i_ph);
  }
  
  void setKeyboard(KeyboardCtrl i_keyboard, TextBox i_txtBox)
  {
    keyboard = i_keyboard;
    keyboard.setTextBox(i_txtBox);
  }
  
  
  
  
  void update()
  {
    if (isVisible == false || isDisabled == true) return;
    
    isDown = false;
    doProcess = false;
    
    if (keyboard != null && isDisabled == false)
    {
     keyboard.update();
     isDown = isDown || keyboard.isDown;
     if (keyboard.doProcess == true) {txt = keyboard.txt; doProcess = true; if (pjs != null) pjs.setKeyPressed(txt.charCodeAt(0));};
    }
  }
  
 
  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    if (keyboard != null)
    {
      keyboard.draw(x1, y1, x2, y2);
    }
  }
  
}

class KeyboardCtrl extends Control
{
  String validKeys = "";
  String txt = "";
  TextBox txtBox;
  boolean addCycle = false;
  Button cycle = new Button(0, 0, .1, 1, "Cycle");
  Container c = new Container(0, 0, .86, 1);
  Button bkSpace = new Button(.9, 0, .1, 1, "Bksp");
  
  boolean isContinous = false;
  
  ArrayList lines = new ArrayList();
  int currLine;
  //Button del = new Button(.6, 0, .4, .45, "Del");
  //Button clr = new Button(.6, .55, .4, .45, "Clr");
  
  KeyboardCtrl(float i_px1, float i_py1, float i_pw, float i_ph, TextBox i_txtBox) 
  { 
    super(i_px1, i_py1, i_pw, i_ph);
    
    txtBox = i_txtBox;
  }
  
  void setTextBox(TextBox i_txtBox)
  {
    txtBox = i_txtBox;
    
    
    for (int i = 0; i < lines.size(); i++)
    {
      KeyboardLine kbl = (KeyboardLine) lines.get(i);
      kbl.setTextBox(i_txtBox);
    }
  }
  
  void addLine(String t)
  {
    KeyboardLine kbl = new KeyboardLine(0, 0, 1, 1, t, txtBox, isContinous);
    lines.add(kbl);
    validKeys = validKeys + t;
    if (lines.size() == 1) { setLine(0); }
    if (lines.size() == 2) { addCycle = true; c.px1 = 0.14; c.pw = .72;}
  }
  
  void setLine(int i)
  {
    if (i < lines.size()) currLine = i;
    c.clear();
    c.add(lines.get(currLine));
  }
  
  void cycleLine()
  {
    currLine++;
    if (currLine >= lines.size()) currLine = 0;
    setLine(currLine);
  }
 
  void update()
  {
    if (isVisible == false || isDisabled == true) return;
    
    isDown = false;
    doProcess = false;
    
    if (isDisabled == false)
    {
    if (addCycle == true)
    {
      cycle.update();
      isDown = isDown || cycle.isDown;
      if (cycle.doProcess == true) { cycleLine(); }
    }
    
     bkSpace.update();
     isDown = isDown || bkSpace.isDown;
     if (bkSpace.doProcess == true) { txtBox.backspace();  }
     
     //del.update();
     //isDown = isDown || del.isDown;
     //if (del.doProcess == true) txtBox.delete();
     
     //clr.update();
     //isDown = isDown || clr.isDown;
     //if (clr.doProcess == true) txtBox.clear();
     
     
     c.update();
     isDown = isDown || c.isDown;
     //if (c.doProcess == true) {KeyboardLine kbl = (KeyboardLine) c; txt = kbl.txt; doProcess = true;};
     if (c.doProcess == true) {txt = c.ctr.txt; doProcess = true; }
     
    /*
    for (int i = 0; i< lines.size(); i++)
    {
      KeyboardLine kbl = (KeyboardLine) lines.get(i);
      kbl.update();
      isDown = isDown || kbl.isDown;
      
      if (kbl.doProcess == true) { txt = kbl.txt; doProcess = true;}
    }*/
    }
  }
  
 
  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    stroke(0); strokeWeight(1); noFill();rectMode(CORNERS);
    //rect(x1, y1, x2, y2);
    
    if (addCycle == true) cycle.draw(x1, y1, x2, y2);
    
    bkSpace.draw(x1, y1, x2, y2);
    //del.draw(x1, y1, x2, y2);
    //clr.draw(x1, y1, x2, y2);
    
    c.draw(x1, y1, x2, y2);
    /*
    for (int i = 0; i< lines.size(); i++)
    {
      KeyboardLine kbl = (KeyboardLine) lines.get(i);
      kbl.draw(x1, y1, x2 - bkSpace.w, y2);
      
      //if (b.doProcess == true) { txtBox.add(b.txt); txt = b.txt; doProcess = true;}
    }
    */
  }
}

//________________________________________________________________________
class LabelBox extends Control
{
  String txt;
  color c1 = color(0, 50); color c2 = color(150); color cText;
  color c3 = color(190, 50);  color c4 = color(255, 150);  color cBack;

  LabelBox (float i_px1, float i_py1, float i_pw, float i_ph, String t) { super(i_px1, i_py1, i_pw, i_ph);  txt = t; }

  void draw(float i_x1, float i_y1, float i_x2, float i_y2)
  {
    if (isVisible == false) return;
    
    super.calculateSize(i_x1, i_y1, i_x2, i_y2);
    
    if (isDisabled == true)
    {
      cText = c1;
      cBack = c3;
    }
    else
    {
      cText = c2;
      cBack = c4;
    }
    
    //noStroke(); fill(cBack); fill(100, 100, 255);rectMode(CORNERS);
    //rect(x1, y1, x2, y2);
    
    if (txt.length > 0)
    {
      /*float s = min((x2-x1) / txt.length, (y2-y1));
      textSize(s);*/
      
      //textSize(getFittedTextSize(txt, 0.1));
      
      fill(cText); textAlign(CENTER, CENTER);
      //text(txt, (x1 + x2)/2, (y1 + y2)/2);
      pushMatrix();
      translate((x1+x2)/2, (y1 + y2)/2);
      scale(getFittedTextSize(txt, 0));
      text(txt, 0, 0);
      popMatrix();
      
    }
  }
}
//########################################################################