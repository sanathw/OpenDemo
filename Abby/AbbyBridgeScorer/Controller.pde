class Controller
{
  var left; var top;
  
  Contract c;
  Suite s;
  Double d;
  Vulnerable v;
  Making m;
  Score score;
  Information info;
  boolean showFullInfo = false;
  boolean showInfo = true;
  var anim1 = 0;
  var anim2 = 0; // if you want the size change to be different
  
  var showWrongMessageCounter = 0;
  
  Answers a;
  var coins = [];
  // sound effects from: https://www.storyblocks.com/audio/search/game+win+sound+effect
  var Win;
  
  Controller(x, y)
  {
    left = x;
    top = y;
    
    c = new Contract(x, y, 20, 20, 5, [1,2,3,4,5,6,7]);
    s = new Suite(x, y+30, 20, 20, 5, ["C", "H", "D", "S", "NT"]);
    d = new Double(x+300, y+30, 20, 20, 5, ["X", "XX"]);
    v = new Vulnerable(x+300, y, 20, 20, 5, ["Non-Vul", "Vul"]);
    m = new Making(x, y+80, 20, 20, 5, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]);
    score = new Score(x, y+160, 120, 60);
    info = new Information(x+160, y+140, 185, 120);
    
    c.bL[0].selected = true; c.updateValue();
    s.bL[0].selected = true; s.updateValue();
    v.bL[0].selected = true; v.updateValue();
    m.bL[0].selected = true; m.updateValue();
    
    a = new Answers(x-20, y+190, 40, 30, 5, ["a", "b", "c", "d"]);
    a.bL[0].callback = answerClicked;
    a.bL[1].callback = answerClicked;
    a.bL[2].callback = answerClicked;
    a.bL[3].callback = answerClicked;
    
    for (int i = 0; i < 12; i++)
    {
      coins.push([0, 0, 0, 0]);
    }
    Win = InitAudio("./_resources/win7.mp3"); // 3  6
    
    Calculate();
  }
  
  ////
  var audio = null;
  var InitAudio(var src)
  {
    var audio = document.createElement("audio");
    audio.setAttribute("src", src);
    audio.load();
    return audio;
  }
  ////
  
  void newGame()
  {
    for (int i = 0; i < c.bL.length; i++) c.bL[i].selected = false;
    for (int i = 0; i < s.bL.length; i++) s.bL[i].selected = false;
    for (int i = 0; i < v.bL.length; i++) v.bL[i].selected = false;
    for (int i = 0; i < d.bL.length; i++) d.bL[i].selected = false;
    for (int i = 0; i < m.bL.length; i++) m.bL[i].selected = false;
    
    var r;
    r = (int) random(c.bL.length);
    c.bL[r].selected = true;
    c.updateValue();
    
    r = (int) random(s.bL.length);
    s.bL[r].selected = true;
    s.updateValue();
    
    r = (int) random(v.bL.length);
    v.bL[r].selected = true;
    v.updateValue();
    
    // double
    r = random();
    if (r < 0.1) d.bL[1].selected = true; // 10% redouble
    else if (r < 0.3) d.bL[0].selected = true;  // 20% double
                                                // 70% not doubled
    d.updateValue();
    
    
    // making
    var l = 6 + c.value;
    var h = 13;
    var r1;
    var bias = map(c.value, 1, 7, .8, .1);
    r = random();
    if (r < bias) // making - 80% if many making options, 10% if 1 making option
    {
      // making
      var diff = (h - l)+1;
      r1 = (int) random(diff);
      r1 += l;
    }
    else // making - 20% if less making options, 90% if 1 making option
    {
      // loosing
      var half_l = (int) (l /2);
      r = random();
      if (r < .8)  // 80% of the time it's the upper half of losing
      {
        r1 = (int) random(half_l+1);
        r1 += half_l;
      }
      else // 20% of the time it's the lower half of losing
      {
        r1 = (int) random(half_l);
      }
    }
    m.bL[r1].selected = true;
    
    
    
    
    
    m.updateValue();
    
    Calculate();
  }
  
  int animW = 0;
  int newGameDelay = 0;
  void animateWin()
  {
    var angle = map(newGameDelay, 120, 0, 0, PI);
    var displacementX = sin(angle);
    var displacementY = map(newGameDelay, 120, 0, 1, -1);
    var op = map(newGameDelay, 120, 0, 255, 0);
    var dd = 10;
    
    var w = 87; var h = 15;
    var p1 = [-w - displacementX * dd, -h * displacementY];
    var p2 = [-p1[0], p1[1]];
    var p3 = [w - displacementX * dd , -p2[1]];
    var p4 = [-p3[0], p3[1]];
    
    pushMatrix();
    translate(-108, 88);
    
    stroke(0); strokeWeight(1); fill(255, 120);
    beginShape();
    vertex(p1[0], p1[1]); 
    vertex(p2[0], p2[1]);
    vertex(p3[0], p3[1]);
    vertex(p4[0], p4[1]);
    vertex(p1[0], p1[1]);
    endShape();
    
    pushMatrix();
    fill(0, op); scale(3);
    text(score.value, 0, 0);
    popMatrix();
    
    popMatrix();
    
    
    
    
    if (doCoins)
    {
      for (int i = 0; i < coins.length; i++)
      {
        pushMatrix();
        translate(coins[i][0], coins[i][1]);
        coins[i][0] += coins[i][2];
        coins[i][1] += coins[i][3];
        coins[i][3] += 0.2;
        pushMatrix();
        scale(0.2);
        image(imgCoin, 0, 0);
        popMatrix();
        popMatrix();
      }
    }
    
    if (animW > 0) animW--;
    if (animW < 0) animW = 0;
    
    if (newGameDelay > 0) newGameDelay--;
    if (newGameDelay < 0) newGameDelay = 0;
    
    if (animW == 0 && newGameDelay == 0) newGame();
  }
  
  void answerClicked(var id)
  {
    info.tries++;
    
    for (int i = 0; i < a.bL.length; i++) a.bL[i].selected = false;
    a.bL[id].selected = true;
    a.updateValue();
    
    if (""+a.bL[id].value == ""+score.value) 
    {
      if (doSound)
      {
        Win.pause(); Win.currentTime = 0; Win.play();
      }
      
      info.wins++;
      
      //showInfo = true;
      animW = 60;
      newGameDelay = 120;
      
      for (int i = 0; i < coins.length; i++)
      {
        coins[i][0] = 0;
        coins[i][1] = 0;
        coins[i][2] = random(10) - 5;
        coins[i][3] = -random(5);
      }
      
      showWrongMessageCounter = 0;
    }
    else
    {
      showWrongMessageCounter = 255;
    }
  }
  
  void createAnswers()
  {
    showInfo = false;
    a.bL[0].value = "";
    a.bL[1].value = "";
    a.bL[2].value = "";
    a.bL[3].value = "";
    
    var offsets = [-200, -100, -50, 50, 100, 200];
    
    // random shuffle by going backwards
    for (int i = offsets.length - 1; i > 0; i--)
    {
      // pick a random index upto the current one
      const j = Math.floor(Math.random() * i);
      
      // swap it with the current one
      const temp = offsets[i];
      offsets[i] = offsets[j];
      offsets[j] = temp;
    }
    
    int keep = (int) random(a.bL.length);
    int j = 0;
    for (int i = 0; i < a.bL.length; i++)
    {
      if (i == keep) a.bL[i].value = score.value;
      else { if (score.value + offsets[j] == 0) j++; a.bL[i].value = score.value + offsets[j]; j++; }
    }
  }
  
  
  void animateInfo()
  {
    pushMatrix();
    var x = map(anim1, 0, 1, 0, -166.5);
    var y = map(anim2, 0, 1, 0, -170);
    var s1 = map(anim1, 0, 1, 1, 2.15);
    var s2 = map(anim1, 0, 1, 1, 2.15);
    info.op = map(min(anim1, anim2), 0, 1, 90, 220);
    info.b = map(min(anim1, anim2), 0, 1, 140, 220);
    translate(x, y);
    scale(s1, s2);
    info.draw(showInfo);
    popMatrix();
  }
  
  var offset = 0;
  var requiredOffset = 0;
  color clr1;
  color clr2;
  void draw()
  {
    showWrongMessageCounter -= 8;
    if (showWrongMessageCounter < 0) showWrongMessageCounter = 0;
    
    if (showFullInfo)
    {
      animateInfo();
      anim1 += 0.05;
      anim2 += 0.05;
      if (anim1 > 1) anim1 = 1;
      if (anim2 > 1) anim2 = 1;
      if (anim1 == 1 && anim2 == 1) 
      {
        if (mousePressed && !pmousePressed) {showFullInfo = false; info.showGameScore = true;}
      }
    }
    else
    {
      if (anim1 > 0 || anim2 > 0)
      {
        animateInfo();
        anim2 -= 0.05;
        anim1 -= 0.05;
        if (anim1 < 0) anim1 = 0;
        if (anim2 < 0) anim2 = 0;
        return;
      }
      
      if (mousePressed && !pmousePressed) 
      {
        if (mouseX >= info.x && mouseX <= (info.x+info.w) && mouseY >= info.y && mouseY <= (info.y+info.h)) {showFullInfo = true; showInfo = true; info.t = 100; info.showGameScore = false; info.wins--; if (info.wins< 0)info.wins = 0;}
      }
      
      info.draw(showInfo);
      
      c.draw();
      s.draw();
      d.draw();
      v.draw();
      m.draw();
      if (testMode) 
      {
        var msg = "What score is it?";
        if (animW == 0 && newGameDelay == 0) 
        {
          if (a.value != null) msg = "Wrong, try again";
          a.draw();
        }
        else 
        {
          msg = "Correct :-)";
          animateWin();
        }
        
        pushMatrix();
        
        translate(-105, 50);
        textAlign(CENTER, CENTER);textFont(font1);
        
        if (showWrongMessageCounter > 0)
        {
          fill(255, 0, 0, showWrongMessageCounter); stroke(255, 200, 0, showWrongMessageCounter); strokeWeight(12); rectMode(CENTER);
          rect(0, 0, 160, 30);
          
          if (showWrongMessageCounter > 100) 
          {
            translate(-5+random()*20, 0);
          }
        }
        
        
        fill(clr1);
        text(msg, 0, 0);
        
         
        if (showWrongMessageCounter > 100) 
        {
          fill(0, showWrongMessageCounter);
          text(msg, 0, 0);
        }

        
        textFont(fontNormal);
        popMatrix();
      }
      else score.draw();
      
      
      switch(imgBackId)
      {
        case 0: clr1 = color(255, 120); clr2 = color(255); break;
        case 1: clr1 = color(0); clr2 = color(255); break;
        case 2: clr1 = color(0, 40, 0); clr2 = color(0); break;
        case 3: clr1 = color(255); clr2 = color(0); break;
        case 4: clr1 = color(255); clr2 = color(0); break;
        case 5: clr1 = color(0, 180); clr2 = color(0); break;
        case 6: clr1 = color(0, 180); clr2 = color(0); break;
        case 7: clr1 = color(255); clr2 = color(255); break;
        case 8: clr1 = color(212, 206, 146); clr2 = color(0); break;
        case 9: clr1 = color(160, 140, 0); clr2 = color(255); break;
        default: clr1 = color(255); clr2 = color(0);
      }
      
      var spc = 25;
      var x = 0;
      var total_x = 0;
      
      pushMatrix();
      x = left+6-(spc*6); total_x += x;
      translate(x, 8);
      //fill(255, 40); stroke(0, 0); strokeWeight(0.001);
      //rect(-7, -5, 338, 6);
      
      requiredOffset = c.value-1;
      offset += (requiredOffset-offset)/8;
      x = spc * offset; total_x += x;
      translate(x, top+100);
      for (int i = -13; i < 7; i++)
      {
        if (total_x > -185 && total_x < 165)
        {
          pushMatrix();
          scale(0.8);
          fill(clr2, 120);
          //fill(0);
          if (i==0) 
          {
            stroke(clr2, 120); strokeWeight(2); line(5, -4, 5, -9); line(-7, -9, 16, -9);
            text("=", 2, 0);
          }
          else if (i > 0) text("+"+i, 0, 0);
          else text(""+i, 0, 0);
          popMatrix();
        }
        
        x = spc; total_x += x;
        translate(x, 0);
      }
      popMatrix();
      
      
      pushMatrix();
      translate(left+175, top+110);
      fill(clr1); textAlign(CENTER, CENTER);textFont(font1);
      pushMatrix();
      translate(0, -124); scale(1);
      text("Contract", 0, 0);
      popMatrix();
      pushMatrix();
      translate(0, -40); scale(1);
      text("Making", 0, 0);
      popMatrix();
      pushMatrix();
      translate(-110, 125); scale(1);
      text("Score", 0, 0);
      popMatrix();
      textFont(fontNormal);
      
      stroke(255, 220, 190, 160); strokeWeight(0.5); noFill();
      rectMode(CENTER);
      rect(0, -85, 360, 60);
      popMatrix();
    }
  }
  
  void Calculate()
  {
    for (int i = 0; i < a.bL.length; i++) a.bL[i].selected = false;
    a.updateValue();
  
    info.message = [];
    /*info.message.push("C " + c.value);
    info.message.push("S " + s.value);
    info.message.push("D " + d.value);
    info.message.push("V " + v.value);
    info.message.push("M " + m.value);*/
    
    score.value = 0;
    
    var underTricks = (c.value + 6) - m.value;
    var overTricks = m.value - (c.value + 6);

    if (underTricks > 0)
    {      
      if (d.value == null)  
      { 
        var m = "";
        
        var A0 = 0;
        var vulnerable = "";
        if (v.value == "Non-Vul") { A0= -50; vulnerable = "non-vulnerable"; }
        else { A0 = -100; vulnerable = "vulnerable"; }
        
        score.value = A0 * underTricks;
        
        // message
        var tricks = underTricks > 1 ? "tricks" : "trick";
        info.message.push("" + A0 + " (for " + vulnerable + ")");
        info.message.push("        " + "x " + underTricks + " (under " + tricks + ")");
        
        info.message.push("--------");
        info.message.push("= " + score.value);
      }
      
      if (d.value == "X" || d.value == "XX")  
      {
        var dblMult = d.value == "X" ? 1 : 2;
        var dblType = d.value == "X" ? "double" : "re-double";
        
        var underTrick_1;
        var underTrick_2;
        var underTrick_3;
        var underTrick_3_Extra;
        
        var vulnerable;
        var m1 = "";
        var m2 = "";
        var m3 = "";
        var m4 = "";
        
        if (v.value == "Non-Vul")
        {
          vulnerable = "non-vulnerable";
          underTrick_1 = -100;
          underTrick_2 = -300;
          underTrick_3 = -500;
          underTrick_3_Extra = -300;
        }
        else
        {
          vulnerable = "vulnerable";
          underTrick_1 = -200;
          underTrick_2 = -500;
          underTrick_3 = -800;
          underTrick_3_Extra = -300;
        }
        
        m1 = "" + underTrick_1;
        m2 = "" + underTrick_2;
        m3 = "" + underTrick_3;
        m4 = "" + underTrick_3_Extra;
        
        underTrick_1 *= dblMult;
        underTrick_2 *= dblMult;
        underTrick_3 *= dblMult;
        underTrick_3_Extra *= dblMult;
        
        //m1 = "" + underTrick_1 + " (" + m1 + " for 1 undertrick " + vulnerable + ")";
        //m2 = "" + underTrick_2 + " for 2 undertricks (" + vulnerable + ")";
        //m3 = "" + underTrick_3 + " for 3 undertricks (" + vulnerable + ")";
        //m4 = "" + underTrick_3_Extra + " for extra undertrick over undertrick 3 (" + vulnerable + ")";
        
        //info.message.push("[" + m3 + "]");
        
        
        var A0 = 0;
        if (underTricks == 1) { A0 = underTrick_1; info.message.push("        " + m1 + " (for 1 undertrick " + vulnerable + ")"); info.message.push("        x " + dblMult + " (" + dblType + ")"); }
        else if (underTricks == 2) { A0 = underTrick_2; info.message.push("        " + m2 + " (for 2 undertricks " + vulnerable + ")"); info.message.push("        x " + dblMult + " (" + dblType + ")"); }
        else if (underTricks == 3) { A0 = underTrick_3; info.message.push("        " + m3 + " (for 3 undertricks " + vulnerable + ")"); info.message.push("        x " + dblMult + " (" + dblType + ")"); }
        else 
        {
          var v1 = (3 - m.value + c.value);
          var v2 = (underTrick_3_Extra * v1);
          A0 = underTrick_3 + v2;
          
           info.message.push("        " + m3 + " (for 3 undertricks " + vulnerable + ")");
           info.message.push("        x " + dblMult + " (" + dblType + ")"); 
           info.message.push("" + underTrick_3 + " = "); 
           info.message.push("+"); 
           info.message.push("        " + m4 + " (for extra undertrick over undertricks 3 " + vulnerable + ")"); 
           info.message.push("        x " + dblMult + " (" + dblType + ")"); 
           info.message.push("        x " + v1 + " (for 3 - making + contract)");
           info.message.push("" + v2 + "   = ");
        }
        
        score.value = A0;
        
        info.message.push("--------");
        info.message.push("= " + score.value);
      }
    }
    else
    {
      var m1 = "";
      var m2 = "";
      var m3 = "";
      var m4 = "";
      var vulnerable = "";
      
      var m5 = "";
      var over7 = m.value - 7; m5 = "making above 7 for Major/minor"
      if (s.value == "NT" && (d.value == "X" || d.value == "XX")) over7 = c.value - 1; m5 = "contracts above 1 for NT";
      
      var A1 = 0;
      var A2 = 0;
      var Amid = 0;
      if (s.value == "NT")                  { A1 = 40; A2 = 30 * over7; Amid = 2; m1 = "(for trick 7)";  m2 = "30 (for trick 8-13)"; m3 = "NT"; }
      if (s.value == "H" || s.value == "S") { A1 = 30; A2 = 30 * over7; Amid = 3; m1 = "(for trick 7)";  m2 = "30 (for trick 8-13)"; m3 = "Majors"; }
      if (s.value == "C" || s.value == "D") { A1 = 20; A2 = 20 * over7; Amid = 4; m1 = "(for trick 7)";  m2 = "20 (for trick 8-13)"; m3 = "minors"; }
      
      var A3 = 0;
      if (c.value >= 1 && c.value <= Amid) { m4 = "Part Score Bonus"; if (v.value == "Non-Vul") { A3 = 50; vulnerable = "non-vulnerable " + m3 + " 1-" + Amid; } else { A3 = 50; vulnerable = "vulnerable " + m3 + " 1-" + Amid; }}
      if (c.value > Amid && c.value <= 5) { m4 = "Game Bonus 3NT, 4H/S, 5C/D"; if (v.value == "Non-Vul") { A3 = 300; vulnerable = "non-vulnerable " + m3 + " " + (Amid+1) +"-5"; } else { A3 = 500; vulnerable = "vulnerable " + m3 + " " + (Amid+1) +"-5"; }}
      if (c.value == 6) { m4 = "Small Slam 12 tricks bid 6 level"; if (v.value == "Non-Vul") { A3 = 800; vulnerable = "non-vulnerable 6"; } else { A3 = 1250; vulnerable = "vulnerable 6"; }}
      if (c.value == 7) { m4 = "Grand Slam 13 tricks bid 7 level";  if (v.value == "Non-Vul") { A3 = 1300; vulnerable = "non-vulnerable 7"; } else { A3 = 2000; vulnerable = "vulnerable 7"; }}
      
      if (d.value == null)  
      {
        score.value = A1 + A2 + A3;
        
        // message
        info.message.push("[" + m3 + "]");
        info.message.push("" + A1 + " " + m1);
        if (A2 > 0) 
        {
          info.message.push("+");
          info.message.push("        " + m2);
          info.message.push("        " + "x " + over7 + " " + m5);
          info.message.push("" + A2 + "   = ");
        }
        info.message.push("+");
        info.message.push("        " + "(for " + vulnerable + ")");
        info.message.push("        " + "(" + m4 + ")");
        info.message.push("" + A3);
        info.message.push("--------");
        info.message.push("= " + score.value);
      }
      
      if (d.value == "X" || d.value == "XX")  
      {
        var oldA2 = A2;
        var dblMult = d.value == "X" ? 1 : 2;
        var dblType = d.value == "X" ? "double" : "re-double";
        
        var instult = 50*dblMult;
        
        info.message.push("[" + m3 + "]");
        info.message.push("          " + A1 + " " + m1);
        if (s.value == "NT" && oldA2 > 0) 
        {
          info.message.push("          " + "+");
          info.message.push("          " + m2);
          info.message.push("          " + "x " + over7 + " " + m5);
        }
        else
        {
          info.message.push("          " + "x " + c.value + " (contract)");
        }
        
        
        
        if (s.value == "NT") A1 = (A1 + oldA2);
        else A1 = (A1 * c.value);
        
        info.message.push("          " + A1 + " =");
        
        A1 = A1 * (2 * dblMult);
        info.message.push("          " + "x " + (2 * dblMult) + " for " + dblType);
        info.message.push("" + A1 + "   =");
        
        
        
        if (v.value == "Non-Vul") { A2 = (100 * dblMult)  * overTricks; m2 = "" + (100 * dblMult);  vulnerable = "non-vulnerable"; } else { A2 = (200 * dblMult) * overTricks; m2 = ""+(200 * dblMult);  vulnerable = "vulnerable"; }
        
        if (A1 > 100 && A3 == 50) if (v.value == "Non-Vul") {A3 = 300; m4 = "50 -> 300 Game Bonus for non-vulnerable double and above 100"} else {A3 = 500; m4 = "50 -> 500 Game Bonus for vulnerable double and above 100"}
        
        score.value = A1 + A2 + A3 + instult;
        
        
        // message
        if (A2 > 0) 
        {
          info.message.push("+");
          info.message.push("        " + m2 + " (for " + dblType + " " + vulnerable + ")");
          var tricks = overTricks > 1 ? "tricks" : "trick";
          info.message.push("        " + "x " + overTricks + " (over " + tricks + " for " + vulnerable + ")");
          info.message.push("" + A2 + "   = ");
        }
        info.message.push("+");
        info.message.push("" + A3 + "  (" + m4 + ")");
        info.message.push("+");
        info.message.push("" + instult + "  (insult for " + dblType + ")");

        info.message.push("--------");
        info.message.push("= " + score.value);
      }
    }
  
    score.clear();
    info.clear();
    
    showInfo = true;
    if (testMode) createAnswers();
  }
  
  
}



class Answers extends ButtonOptionList
{
  Answers(_x, _y, _w, _h, _s, _values) { super(_x, _y, _w, _h, _s, _values); }
  Button createButton(x, y, w, h, value, callback, id) { return new AnswerButton(x, y, w, h, value, callback, id); }
}


class Contract extends ButtonOptionList
{
  Contract(_x, _y, _w, _h, _s, _values) { super(_x, _y, _w, _h, _s, _values); }
  Button createButton(x, y, w, h, value, callback, id) { return new ContractButton(x, y, w, h, value, callback, id); }
}


class Suite extends ButtonOptionList
{
  Suite(_x, _y, _w, _h, _s, _values) { super(_x, _y, _w, _h, _s, _values); }
  Button createButton(x, y, w, h, value, callback, id) { return new SuiteButton(x, y, w, h, value, callback, id); }
}


class Double extends ButtonOptionList
{
  Double(_x, _y, _w, _h, _s, _values) { super(_x, _y, _w, _h, _s, _values); }
  Button createButton(x, y, w, h, value, callback, id) { return new DoubleButton(x, y, w, h, value, callback, id); }
  
  void buttonDown(id)
  {
    if (bL[id].selected == true) {bL[id].selected = false;  updateValue(); Calculate();}
    else super.buttonDown(id);
  }
}


class Vulnerable extends ButtonOptionList
{
  Vulnerable(_x, _y, _w, _h, _s, _values) { super(_x, _y, _w, _h, _s, _values); }
  Button createButton(x, y, w, h, value, callback, id) { return new VulnerableButton(x, y, w, h, value, callback, id); }
}


class Making extends ButtonOptionList
{
  Making(_x, _y, _w, _h, _s, _values) { super(_x, _y, _w, _h, _s, _values); }
  Button createButton(x, y, w, h, value, callback, id) { return new MakingButton(x, y, w, h, value, callback, id); }
  
  /*void draw()
  {
    image(imgBlur, 0, 0);
    super.draw();
  }*/
}






class Score
{
  var x; var y; var w; var h;
  var hw; var hh;
  var value = 0;
  var t = 0;
  
  Score(_x, _y, _w, _h)
  {
    x = _x; y = _y; w = _w; h = _h;
    hw = w/2; hh = h/2;
  }
  
  void clear() { t = 0; }
  
  void draw()
  {
    var c;
    
    stroke(0); strokeWeight(2); fill(255, 60);
    rectMode(CENTER);
    pushMatrix();
    translate(x+hw, y+hh);
    rect(0, 0, w, h);
    
    if (value < 0) c = color(180, 0, 0);
    else c = color(0, 140, 0);
    
    fill(c);
    
    scale(3);
    textAlign(CENTER, CENTER);
    text(""+value, 0, 0);
    popMatrix();
    
    
    //var o = -w;
    var o = 160;
    //if (t >= 30) o = map(t, 20, 60, -w, 0);
    if (t >= 30) o = map(t, 30, 60, 160, 0);
    pushMatrix();
    translate(x+w, y+h);
    fill(190, o);
    rectMode(CORNERS);
    rect(0, 0, -w, -h);
    popMatrix();
    
    t++;
    if (t > 60) t = 60;
  }
}

class Information
{
  var x; var y; var w; var h;
  var message = [];
  var t = 0;
  var op = 90;
  var b = 140;
  
  var tries = 0;
  var wins = 0;
  var showGameScore = true;
  
  Information(_x, _y, _w, _h)
  {
    x = _x; y = _y; w = _w; h = _h;
  }
  
  void clear() { t = 0; }
  
  void draw(var showInfo)
  {
    stroke(0, 40); strokeWeight(0.5); fill(255, 255, b, op);
    rectMode(CORNERS);
    pushMatrix();
    translate(x, y);
    rect(0, 0, w, h);
    
    var o = 0;
    
    //if (showInfo)
    if (!testMode || !showGameScore)
    {
      pushMatrix();
      
      if (t >= 40) o = map(t, 40, 100, 0, 255);
      
      fill(0, o);
      textAlign(LEFT, CENTER);
      translate(5, 0);
      translate(0, 6);
      pushMatrix();
      scale(0.45);
      for (int i = 0; i < message.length; i++)
      {
        text(message[i], 0, 0);
        translate(0, 14);
      }
      
      t++;
      if (t > 100) t = 100;
      popMatrix();
      popMatrix();
    }
    
    if (testMode && showGameScore)
    {
      textAlign(CENTER, CENTER);
      pushMatrix();
      translate((w/2)-30, h/2);
      scale(1);
      fill(255, min(255 - o, 140));
      text("help?", 0, 0);
      fill (0, 190);
      scale(0.6);
      translate(0, 20);
      text("(Clicking here will)", 0, 0);
      translate(0, 15);
      text("make you lose 1 point)", 0, 0);
      popMatrix();
      
      
      
      pushMatrix();
      translate(-10, -30);
      pushMatrix();
      translate (150, 90);
      pushMatrix();
      scale(0.5);
      //tint(255, 180);
      image(imgCoin, 0, 0);
      //tint(255, 255);
      stroke(0, 0); strokeWeight(0.001); fill(255, 100);
      ellipseMode(RADIUS);
      ellipse(0, 0, 48, 48);
      popMatrix();
      
      textAlign(CENTER, CENTER);
      pushMatrix();
      translate(2, -34);
      fill(255);
      scale(.8);
      text("" + wins + " / " + tries, 0, 0);
      translate(0, -10);
      scale(0.5);
      text("wins    tries", -4, 0);
      popMatrix();
      
      pushMatrix();
      translate(2, 30);
      fill(255);
      scale(0.8);
      text("your game score", 0, 0);
      popMatrix();
      
      var percent = 0;
      if (tries > 0) percent = (wins / tries) * 100;
      var s = percent.toFixed(2);
      var s1 = parseFloat(s);
      var s2 = s1.toString();
      
      pushMatrix();
      translate(2, 0);
      fill(255, 0, 255);
      scale(1.5);
      text(s2 + "%", 0, 0);
      popMatrix();
      popMatrix();
      
      popMatrix();
    }
    
    
    popMatrix();
  }
}






class ButtonOptionList
{
  var bL = [];
  var value = null;
  
  ButtonOptionList(_x, _y, _w, _h, _s, _values)
  {
    var x = _x + _w/2;
    var y = _y + _h/2;
    
    for (int i = 0; i < _values.length; i++)
    {
      bL[i] = new createButton(x, y, _w, _h, _values[i], buttonDown, i);
      x += _w+_s;
    }
  }
  
  Button createButton(x, y, w, h, value, callback, id) {return null}
  
  void draw()
  {
    for (int i = 0; i < bL.length; i++)
    {
      bL[i].draw();
    }
  }
  
  void updateValue()
  {
    value = null;
    for (int i = 0; i < bL.length; i++) 
    {
      if (bL[i].selected) 
      {
        value = bL[i].value;
        break;
      }
    }
  }
  
  void buttonDown(id)
  {
    for (int i = 0; i < bL.length; i++) bL[i].selected = false;
    bL[id].selected = true;
    updateValue();
    Calculate(); 
  }
}