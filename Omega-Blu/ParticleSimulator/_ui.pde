Button bSimulation;
Button bReset;
Button bShowSprings;
Button bShowTouch;
Container c1;
ScrollBar sTemperature; LabelBox lTemperature;
ScrollBar sRotation; LabelBox lRotation;
Button bStopStartRotation;

boolean isUiSetup = false;
void setupUI()
{
  with (pjsCM)
  {
    setupCM(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM, 3, START_OPENED);
    
    bSimulation =  addButton(0, 0, .1, 1, "Sim:");
    bReset = addButton(0.11, 0, .1, 1, "Reset");
    
    bShowSprings = addButton(0.22, 0, .06, 0.45, "Springs");
    bShowTouch = addButton(0.22, 0.55, .06, 0.45, "Touch");
    
    c1 = addContainer(0.3, 0, .45, 1); c1.hasBorder = false;
    setContainer(c1);

    sTemperature = addScrollBar(0, 0, 1, .4, 0, 1, 0);
    lTemperature = addLabelBox(0, 0, 1, .4, "Temp:");
    
    sRotation = addScrollBar(0, 0.6, 1, .4, -0.2, 0.2, 0);
    lRotation = addLabelBox(0, 0.6, 1, .4, "Rot:");
    
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
  
  bShowSprings.isOn = showSprings;
  bShowTouch.isOn = showTouch;

  sTemperature.curV = Temperature;
  lTemperature.txt = "Temp: " + Temperature.toFixed(3);
  
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
    simulation++;
    if (simulation > 5) simulation = 1;
    setupSimulation();
  }
  
  if (bReset != null && bReset.doProcess == true) 
  {
    setupSimulation();
  }
  
  if (bShowSprings != null && bShowSprings.doProcess == true) 
  {
    showSprings = !showSprings;
  }
  
  if (bShowTouch != null && bShowTouch.doProcess == true) 
  {
    showTouch = !showTouch;
    g.background(0, 0);
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