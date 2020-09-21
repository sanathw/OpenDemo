//Container c1;
Button bSound;
Button bCoins;
Button b1;
Button bFullScreen;
Button bTestMode;
//ScrollBar s1;
//TextBox t1;
//LabelBox l1;
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
    setupCM(SHOW_AS_HORIZONTAL, SHOW_AT_BOTTOM, 3, START_CLOSED);
    //setupCM(SHOW_AS_VERTICAL, SHOW_AT_LEFT, 3, START_OPENED);
    //setupCM(SHOW_AS_VERTICAL, SHOW_AT_RIGHT, 3, START_OPENED);
    
    //setCMGradient(color(255, 0, 0,90), color(0, 0, 255, 0));
    
    //setContainer(null);
    //c1 = addContainer(0, 0.2, 1, 0.8);
    // add buttons to tab
    
    //setContainer(c1);
    bSound = addButton(0.02, .1, .05, .8, "snd");
    bCoins = addButton(0.09, .1, .05, .8, "coins");
    b1 = addButton(.2, .1, .15, .8, "Background");
    bFullScreen = addButton(.45, .1, .15, .8, "Full screen");
    bTestMode = addButton(.7, .1, .15, .8, "Test Mode");
    
    //s1 = addScrollBar(0.012, 0.4, .7, .31, 0, 100, 50);
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
  if (bSound != null && bSound.doProcess == true) 
  {
    doSound = !doSound;
    //pjsCM.HideControlBar();
  }
  
  if (bCoins != null && bCoins.doProcess == true) 
  {
    doCoins = !doCoins;
    //pjsCM.HideControlBar();
  }
  
  if (b1 != null && b1.doProcess == true) 
  {
    imgBackId++;
    if (imgBackId > 9) imgBackId = 0;
  }
  
  if (bFullScreen != null && bFullScreen.doProcess == true) 
  {
    // from this apps _main.html 
    //toggleFullScreen(null);
    //or
    requestFullScreen(document.documentElement);
    pjsCM.HideControlBar();
    
    
    //pjsCM.noLoop();
    //setTimeout(pjsCM.loop(), 15000); // 1.5 seconds
  }
  
  if (bTestMode != null && bTestMode.doProcess == true) 
  {
    testMode = !testMode;
    if (testMode) c.newGame();
    pjsCM.HideControlBar();
  }
  
  UpdateUI();
}

void UpdateUI()
{
  bSound.isOn = doSound;
  bCoins.isOn = doCoins;
  bTestMode.isOn = testMode;
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