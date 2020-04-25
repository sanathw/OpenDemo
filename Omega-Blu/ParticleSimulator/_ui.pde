Button bControls;

Container c0A;
Button bSimulation;
Button bReset;
Button bShowTouch;
Container c1;
ScrollBar sStickProbability; LabelBox lStickProbability;
ScrollBar sConnectionProbability; LabelBox lConnectionProbability; // Blob probability
ScrollBar sRotation; LabelBox lRotation;
Button bStopStartRotation;

Container c0B;
Button bDebug;
Button bStopStart; LabelBox lbStopStart;
Button bStep; LabelBox lStep;
Button bVelocity;
Button bInfo;
Button bMoveParticle;
Button bModelOffset;

boolean showA = true;

boolean isUiSetup = false;
void setupUI()
{
  with (pjsCM)
  {
    setupCM(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM, 4, START_OPENED);
    
    bSimulation =  addButton(0, 0, .1, 1, "Sim:");
    bReset = addButton(0.115, 0, .1, 1, "Reset");
    bShowTouch = addButton(.23, 0, .06, 1, "Touch");
    
    bControls = addButton(0.3, 0.25, .04, .5, "...");
    
    c0A = addContainer(0.345, 0.01, .45, 0.96); c0A.hasBorder = true;
    setContainer(c0A);
    
    //c1 = addContainer(0.3, 0, .45, 1); c1.hasBorder = false;
    //setContainer(c1);

    sStickProbability = addScrollBar(0, 0, 1, .3, 0, 1, 0);
    lStickProbability = addLabelBox(0, 0, 1, .3, "Stick prob:");
    
    sConnectionProbability = addScrollBar(0, 0.4, 1, .2, 0, 1, 0);
    lConnectionProbability = addLabelBox(0, 0.4, 1, .2, "water                Blob prob:                 solid");
    
    sRotation = addScrollBar(0, 0.7, 1, .3, -0.2, 0.2, 0);
    lRotation = addLabelBox(0, 0.7, 1, .3, "Rot:");
    
    setContainer(null);
    bStopStartRotation = addButton(0.8, 0, .1, 1, "Stop Rot");
    
    
    
    c0B = addContainer(0.345, 0.01, .45, 0.96); c0B.hasBorder = true;
    setContainer(c0B);
    var i = 0.03;
    var w = 0.12;
    war s = 0.02;
    bDebug = addButton(i, 0.25, w, .5, "Debug"); i += (w+s);
    
    bStopStart = addButton(i, 0.25, w, .5, "[   ]"); 
    lStopStart = addLabelBox(i, 0.77, w, .2, "play"); 
    i += (w+s);
    bStep = addButton(i, 0.25, w, .5, ">"); 
    lStep = addLabelBox(i, 0.77, w, .2, "step");
    i += (w+s);
    bVelocity = addButton(i, 0.25, w, .5, "vel"); i += (w+s);
    bInfo = addButton(i, 0.25, w, .5, "DEL"); i += (w+s);
    bMoveParticle = addButton(i, 0.25, w, .5, "move"); i += (w+s);
    bModelOffset = addButton(i, 0.25, w, .5, "+"); i += (w+s);
  }
  
  resetData();
  isUiSetup = true;
}

void updateDisplayInfo()
{ 
  if (!isUiSetup) return;
  
  
  c0A.isVisible = false;
  c0B.isVisible = false;
  
  if (showA) c0A.isVisible = true;
  else c0B.isVisible = true;
  
  bSimulation.txt = "Sim: " + simulation;
  
  bShowTouch.isOn = showTouch;

  sStickProbability.curV = StickProbability;
  lStickProbability.txt = "Stick prob: " + StickProbability.toFixed(3);
  
  sConnectionProbability.curV = ConnectionProbability;
  lConnectionProbability.txt = "water                Blob prob: " + ConnectionProbability.toFixed(3) + "                solid";
  
  sRotation.curV = Rotation;
  lRotation.txt = "-    Rot: " + Rotation.toFixed(3) + "    +";
  //sRotation.isDisabled = !doRotation; // allow the scrollbar to change while not rotating
  lRotation.isDisabled = !doRotation;
  
  if (doRotation) bStopStartRotation.txt = "Stop Rot";
  else bStopStartRotation.txt = "Start Rot";
  
  bDebug.isOn = SHOW_DEBUG;
  if (loop) lStopStart.txt = "stop";
  else lStopStart.txt = "play";
  
  bVelocity.isOn = showVelocity;
  
  if (showInfo) bInfo.txt = "Info";
  else bInfo.txt = "DEL";
  
  bMoveParticle.isDisabled = !showInfo;
  bMoveParticle.isOn = moveParticle;
  
  bModelOffset.isOn = showModelOffset;
}

void processUI()
{
  if (bControls != null && bControls.doProcess == true) 
  {
    showA = !showA;
  }
  
  if (bSimulation != null && bSimulation.doProcess == true) 
  {
    simChange = true;
    simulation++;
    if (simulation > 9) simulation = 1;
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
  
  
  if (bDebug != null && bDebug.doProcess == true) 
  {
    SHOW_DEBUG = !SHOW_DEBUG;
  }
  
  if (bStopStart != null && bStopStart.doProcess == true) 
  {
    loop = !loop; stopAfter = false;
  }
  
  if (bStep != null && bStep.doProcess == true) 
  {
    loop = true; stopAfter = true;
  }
  
  if (bVelocity != null && bVelocity.doProcess == true) 
  {
    showVelocity = !showVelocity;
  }
  
  if (bInfo != null && bInfo.doProcess == true) 
  {
    showInfo = !showInfo;
  }
  
  if (bMoveParticle != null && bMoveParticle.doProcess == true) 
  {
    moveParticle = !moveParticle;
  }
  
  if (bModelOffset != null && bModelOffset.doProcess == true) 
  {
    showModelOffset = !showModelOffset;
  }
}

void drawHUD(var g)
{ 
  g.textAlign(LEFT, TOP);
  
  if (loop == false)
  {
    g.fill(255, 0, 0);
    g.text("STOPPED", 0, 0);
  }
  
  
  g.pushMatrix();
  g.translate(20, 60);
  g.scale(0.4);
  g.fill(0, 90);
  g.text(debugHUDMessage1, 0, 0); g.translate(0, 60);
  g.fill(0);
  g.text(debugHUDMessage2, 0, 0); g.translate(0, 60);
  g.text(debugHUDMessage3, 0, 0);
  g.popMatrix();
  
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