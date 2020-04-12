Button bSimulation;
Button bReset;

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
    bReset =  addButton(0.15, 0, .1, 1, "Reset");
    
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