class Controller
{
  Contract c;
  Suite s;
  Double d;
  Vulnerable v;
  Making m;
  Score score;
  Information info;
  
  Controller(x, y)
  {
    c = new Contract(x, y, 20, 20, 5, [1,2,3,4,5,6,7]); //y+= 30;
    s = new Suite(x+225, y, 20, 20, 5, ["C", "H", "D", "S", "NT"]); y+= 30;
    d = new Double(x+225, y, 20, 20, 5, ["X", "XX"]);
    v = new Vulnerable(x+300, y, 20, 20, 5, ["Vul", "Non-Vul"]); y+= 40;
    m = new Making(x, y+20, 20, 20, 5, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]); y+= 60;
    score = new Score(x, y+30, 120, 60);
    info = new Information(x+160, y, 185, 120);
    
    
    c.bL[0].selected = true; c.updateValue();
    s.bL[0].selected = true; s.updateValue();
    v.bL[1].selected = true; v.updateValue();
    m.bL[0].selected = true; m.updateValue();
    
    Calculate();
  }
  
  void draw()
  {
    c.draw();
    s.draw();
    d.draw();
    v.draw();
    m.draw();
    score.draw();
    info.draw();
    
    
    fill(0); textAlign(CENTER, CENTER);textFont(font1);
    pushMatrix();
    translate(0, -130); scale(1);
    text("Contract", 0, 0);
    popMatrix();
    pushMatrix();
    translate(0, -35); scale(1);
    text("Making", 0, 0);
    popMatrix();
    pushMatrix();
    translate(-112, 125); scale(1);
    text("Score", 0, 0);
    popMatrix();
    textFont(fontNormal);
    
    stroke(255, 220, 190, 160); strokeWeight(0.5); noFill();
    rectMode(CENTER);
    rect(0, -85, 360, 70);
  }
  
  void Calculate()
  {
    info.message = [];
    info.message.push("C " + c.value);
    info.message.push("S " + s.value);
    info.message.push("D " + d.value);
    info.message.push("V " + v.value);
    info.message.push("M " + m.value);
    
    score.value = 0;
    
    var loss = (c.value + 6) - m.value;

    if (loss > 0)
    {
      var AA = 0;
      var A0 = 0;
      if (d.value == null)  { AA = 0; A0 = (v.value == "Non-Vul") ? A0 = -50 : -100; }
      
      //if (d.value == "X")   { AA = 400; A0 = (v.value == "Non-Vul") ? A0 = -300 : -300; }
      
      score.value = AA + (A0 * loss);
    }
    else
    {
      var make = m.value - 7;
      
      var A1 = 0;
      var A2 = 0;
      var Amid = 3;
      if (s.value == "NT")                  { A1 = 40; A2 = 30 * make;     Amid = 3; }
      if (s.value == "H" || s.value == "S") { A1 = 0;  A2 = 30 * (make+1); Amid = 4; }
      if (s.value == "C" || s.value == "D") { A1 = 0;  A2 = 20 * (make+1); Amid = 5; }
      
      var A3 = 0;
      if (c.value >= 1 && c.value < Amid) A3 = (v.value == "Non-Vul") ? 50 : 50;
      if (c.value >= Amid && c.value < 6) A3 = (v.value == "Non-Vul") ? 300 : 500;
      if (c.value == 6) A3 = (v.value == "Non-Vul") ? 800 : 1250;
      if (c.value == 7) A3 = (v.value == "Non-Vul") ? 1300 : 2000;
      
      score.value = A1 + A2 + A3;
    }
  
    score.clear();
    info.clear();
  }
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
    if (bL[id].selected == true) bL[id].selected = false;
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
  
  Information(_x, _y, _w, _h)
  {
    x = _x; y = _y; w = _w; h = _h;
  }
  
  void clear() { t = 0; }
  
  void draw()
  {
    stroke(0, 40); strokeWeight(0.5); fill(255, 255, 100, 90);
    rectMode(CORNERS);
    pushMatrix();
    translate(x, y);
    rect(0, 0, w, h);
    
    var o = 0;
    if (t >= 60) o = map(t, 60, 180, 0, 255);
    
    fill(0, o);
    textAlign(LEFT, CENTER);
    translate(5, 0);
    translate(0, 10);
    for (int i = 0; i < message.length; i++)
    {
      text(message[i], 0, 0);
      translate(0, 15);
    }
    popMatrix();
    
    t++;
    if (t > 180) t = 180;
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