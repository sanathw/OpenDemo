Button bSimulation;
Button bReset;

Container c1;

LabelBox lTemperature;
ScrollBar sTemperature;

LabelBox lRotation;
ScrollBar sRotation;

Button bStopStartRotation;


//TextBox t1;
//
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
    
    
    bSimulation =  addButton(0, 0, .1, 1, "Sim:");
    bReset =  addButton(0.15, 0, .1, 1, "Reset");
    
    
    //setContainer(null);
    c1 = addContainer(0.3, 0, .45, 1); c1.hasBorder = false;
    // add buttons to tab
    
    setContainer(c1);
    //b1 = addButton(.012, .1, .12, .31, "Triangle");
    sTemperature = addScrollBar(0, 0, 1, .4, 0, 1, 0);
    lTemperature = addLabelBox(0, 0, 1, .4, "Temp:");
    
    sRotation = addScrollBar(0, 0.6, 1, .4, -0.2, 0.2, 0);
    lRotation = addLabelBox(0, 0.6, 1, .4, "Rot:");
    
    setContainer(null);
    bStopStartRotation = addButton(0.78, 0, .1, 1, "Stop Rot");
    
    
    //t1 = addTextBox(.012, .48, .76, .2, "");
    //
    //kbContainer = addKeyboardContainer(.14, .78, .632, .2);
    //kbctrl1 = addKeyboardCtrl(0, 0, 1, 1, null);
    //kbctrl1.addLine("1234567890");
    //t1.attachKeyboard(kbctrl1, kbContainer);
    //kbContainer.setKeyboard(kbctrl1, t1); // to start off with a keyboard
    
    //c.hasBorder = true;
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

void updateDisplayInfo()
{
  bSimulation.txt = "Sim: " + simulation;
  
  sTemperature.curV = Temperature;
  lTemperature.txt = "Temp: " + Temperature.toFixed(2);
  
  sRotation.curV = Rotation;
  lRotation.txt = "-    Rot: " + Rotation.toFixed(2) + "    +";
  
  sRotation.isDisabled = !doRotation;
  lRotation.isDisabled = !doRotation;
  if (doRotation) bStopStartRotation.txt = "Stop Rot";
  else bStopStartRotation.txt = "Start Rot";
  
}

void setupSimulation()
{
  W = new World();
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

void processUI()
{
  if (bSimulation != null && bSimulation.doProcess == true) 
  {
    simulation++;
    if (simulation > 5) simulation = 1;
    
    setupSimulation();
  }
  
  if (bReset != null && bReset.doProcess == true) 
  {
    setupSimulation();
  }
  
  
  if (sTemperature != null && sTemperature.doProcess == true) 
  {
    Temperature = sTemperature.curV;
  }
  
  if (sRotation != null && sRotation.doProcess == true) 
  {
    Rotation = sRotation.curV;
  }
  
  if (bStopStartRotation != null && bStopStartRotation.doProcess == true) 
  {
    doRotation = !doRotation;
  }
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