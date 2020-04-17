Button bSimulation;
Button bReset;
Button bShowTouch;
Container c1;
ScrollBar sStickProbability; LabelBox lStickProbability;
ScrollBar sConnectionProbability; LabelBox lConnectionProbability;
ScrollBar sRotation; LabelBox lRotation;
Button bStopStartRotation;

boolean isUiSetup = false;
void setupUI()
{
  with (pjsCM)
  {
    setupCM(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM, 4, START_OPENED);
    
    bSimulation =  addButton(0, 0, .1, 1, "Sim:");
    bReset = addButton(0.11, 0, .1, 1, "Reset");
    
    bShowTouch = addButton(0.22, 0, .06, 1, "Touch");
    
    c1 = addContainer(0.3, 0, .45, 1); c1.hasBorder = false;
    setContainer(c1);

    sStickProbability = addScrollBar(0, 0, 1, .3, 0, 1, 0);
    lStickProbability = addLabelBox(0, 0, 1, .3, "Stick prob:");
    
    sConnectionProbability = addScrollBar(0, 0.4, 1, .2, 0, 1, 0);
    lConnectionProbability = addLabelBox(0, 0.4, 1, .2, "Connect prob:");
    
    sRotation = addScrollBar(0, 0.7, 1, .3, -0.2, 0.2, 0);
    lRotation = addLabelBox(0, 0.7, 1, .3, "Rot:");
    
    setContainer(null);
    bStopStartRotation = addButton(0.78, 0, .1, 1, "Stop Rot");
  }
  
  resetData();
  isUiSetup = true;
}

void updateDisplayInfo()
{ 
  if (!isUiSetup) return;
  
  bSimulation.txt = "Sim: " + simulation;
  
  bShowTouch.isOn = showTouch;

  sStickProbability.curV = StickProbability;
  lStickProbability.txt = "Stick prob: " + StickProbability.toFixed(3);
  
  sConnectionProbability.curV = ConnectionProbability;
  lConnectionProbability.txt = "Connect prob: " + ConnectionProbability.toFixed(3);
  
  sRotation.curV = Rotation;
  lRotation.txt = "-    Rot: " + Rotation.toFixed(3) + "    +";
  //sRotation.isDisabled = !doRotation; // allow the scrollbar to change while not rotating
  lRotation.isDisabled = !doRotation;
  
  if (doRotation) bStopStartRotation.txt = "Stop Rot";
  else bStopStartRotation.txt = "Start Rot";
}

void processUI()
{
  if (bSimulation != null && bSimulation.doProcess == true) 
  {
    simChange = true;
    simulation++;
    if (simulation > 5) simulation = 1;
    setupSimulation();
  }
  
  if (bReset != null && bReset.doProcess == true) 
  {
    simChange = false;
    setupSimulation();
  }
  
  if (bShowTouch != null && bShowTouch.doProcess == true) 
  {
    showTouch = !showTouch;
    g.background(0, 0);
  }
  
  if (sStickProbability != null && sStickProbability.doProcess == true) 
  {
    StickProbability = sStickProbability.curV;
  }
  
  if (sConnectionProbability != null && sConnectionProbability.doProcess == true) 
  {
    ConnectionProbability = sConnectionProbability.curV;
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
  if (loop == false)
  {
    g.fill(255, 0, 0);
    g.textAlign(LEFT, TOP);
    g.text("STOPPED", 0, 0);
  }
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