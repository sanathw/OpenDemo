
Button bGrow;
Button bColorState;

Container c1;
Button bAnimate;
ScrollBar sAngle;
Button bGoldenAngle;
ScrollBar sMaxN;
ScrollBar sC;
//TextBox t1;
LabelBox lAngle1;
LabelBox lAngle2;
LabelBox lMaxN1;
LabelBox lMaxN2;
LabelBox lC1;
LabelBox lC2;
//KeyboardContainer kbContainer;
//KeyboardCtrl kbctrl1;

void setupUI()
{
  with (pjsCM)
  {
    //showLocation(SHOW_AS_HORIZONTAL, SHOW_AT_TOP);
    //showLocation(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM);
    //showLocation(SHOW_AS_VERTICAL, SHOW_AT_LEFT);
    //showLocation(SHOW_AS_VERTICAL, SHOW_AT_RIGHT);
    //setupCM(SHOW_AS_HORIZONTAL, SHOW_AT_TOP, 3, START_OPENED);
    setupCM(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM, 3, START_OPENED);
    //setupCM(SHOW_AS_VERTICAL, SHOW_AT_LEFT, 3, START_OPENED);
    //setupCM(SHOW_AS_VERTICAL, SHOW_AT_RIGHT, 3, START_OPENED);
    
    //setCMGradient(color(255, 0, 0,90), color(0, 0, 255, 0));
    
    setContainer(null);
    
    bGrow = addButton(0, 0, .1, 1, "Grow");
    bColorState = addButton(0.12, 0, .08, 1, "Color");
    
    c1 = addContainer(0.25, 0, 0.65, 1);

    // add buttons to tab
    setContainer(c1);
    
    bAnimate = addButton(0, 0, .1, 1, "Animate");
    
    lAngle1   = addLabelBox(0.1, 0, .4, .3, "Angle");
    lAngle2   = addLabelBox(0.1, 0.4, .4, .6, "");
    sAngle   = addScrollBar(0.1, 0, .4, 1, 0, 360, 0);
    
    bGoldenAngle = addButton(0.5, 0, .1, 1, "Golden");
    
    lMaxN1    = addLabelBox(0.65, 0, .15, .3, "Circles");
    lMaxN2    = addLabelBox(0.65, 0.4, .15, .6, "");
    sMaxN    = addScrollBar(0.65, 0, .15, 1, 1, 1000, 0);
    
    lC1       = addLabelBox(0.85, 0, .15, .3, "Space");
    lC2       = addLabelBox(0.85, 0.4, .15, .6, "");
    sC       = addScrollBar(0.85, 0, .15, 1, 0, 20, 0);
    //t1 = addTextBox(.012, .48, .76, .2, "");
    //l1 = addLabelBox(.8, .8, .1, .15, "24");
    //kbContainer = addKeyboardContainer(.14, .78, .632, .2);
    //kbctrl1 = addKeyboardCtrl(0, 0, 1, 1, null);
    //kbctrl1.addLine("1234567890");
    //t1.attachKeyboard(kbctrl1, kbContainer);
    //kbContainer.setKeyboard(kbctrl1, t1); // to start off with a keyboard
    
    //c1.hasBorder = true;
    //b.isOn = false;
    //b.isContinous = false;
    //b.isManualDraw = flase;
    //x.isDisabled = false;
    //x.isVisible = true;
    //t.isAutoClear = false;
    //t.isCaseSensistive = false;
    //kbctrl.isContinous = false;
    //s.setRange(minV, maxV, curV);
    //s.curV;
    setContainer(null);
    
    
  }
  
  resetData();
}

//void maualDraw(var o)
//{
//  var g = pjsCM;
//  if (o == bColor1)
//  {
//    if (o.isDisabled) {}
//    else
//    {
//      g.fill(255, 0, 0); g.noStroke();
//      if (o.isOn) {g.stroke(0); g.strokeWeight(4);}
//      if (o.isOver) {g.fill(255, 100, 100);}
//      if (o.isDown) {}
//      g.rectMode(CORNERS);
//      g.rect(o.x1, o.y1, o.x2, o.y2);
//    }
//  }
//}

void processUI()
{
  if (bGrow != null && bGrow.doProcess == true) 
  {
    n = 0;
    g.background(0, 0);
    doAnimate = false;
    
    doGrow = true;
  }
  
  if (bColorState != null && bColorState.doProcess == true) 
  {
    doColorState++;
    if (doColorState == 6) doColorState = 0;
  }
  
  if (bAnimate != null && bAnimate.doProcess == true) 
  {
    doAnimate = !doAnimate;
  }
  
  if (sAngle != null && sAngle.doProcess == true) 
  {
    angleChange = sAngle.curV;
  }
  
  if (bGoldenAngle != null && bGoldenAngle.doProcess == true) 
  {
    angleChange = 137.508; //goldern angle
  }
  
  if (sMaxN != null && sMaxN.doProcess == true) 
  {
    maxN = (int) sMaxN.curV;
  }
  
  if (sC != null && sC.doProcess == true) 
  {
    c = (int) sC.curV;
  }
  
  UpdateUI();
}

void UpdateUI()
{
  bGrow.isOn = doGrow;
  
  c1.isVisible = !doGrow;
  
  bAnimate.isOn = doAnimate;
  
  lAngle2.txt = "" + angleChange.toFixed(2);
  sAngle.curV = angleChange;
  
  lMaxN2.txt = "" + maxN;
  sMaxN.curV = maxN;
  
  lC2.txt = "" + c;
  sC.curV = c;
}


void drawHUD(var g)
{   
}

void resetData()
{
  //use data
  //String[] lines = split(data, "\r\n");
}

void saveData()
{
  //save into data
  //data = "";
  //data += "" + "...." + "\r\n";
}