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
    c = new Contract(x, y, 20, 20, 5, [1,2,3,4,5,6,7]); y+= 30;
    s = new Suite(x, y, 20, 20, 5, ["C", "H", "D", "S", "NT"]); y+= 30;
    d = new Double(x, y, 20, 20, 5, ["X", "XX"]);
    v = new Vulnerable(x+60, y, 20, 20, 5, ["Vul", "Non-Vul"]); y+= 30;
    m = new Making(x, y, 20, 20, 5, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]); y+= 30;
    score = new Score(x, y, 40, 30); y+= 40;
    info = new Information(x, y, 200, 100);
    
    c.bL[0].selected = true;
    s.bL[0].selected = true;
    v.bL[0].selected = true;
    m.bL[0].selected = true;
    
    info.message = [];
    info.message.push("info line 1");
    info.message.push("info line 2");
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
}






class Score
{
  var x; var y; var w; var h;
  var hw; var hh;
  
  var value = 0;
  Score(_x, _y, _w, _h)
  {
    x = _x; y = _y; w = _w; h = _h;
    hw = w/2; hh = h/2;
  }
  
  void draw()
  {
    stroke(0); strokeWeight(1); fill(255);
    rectMode(CENTER);
    pushMatrix();
    translate(x+hw, y+hh);
    rect(0, 0, w, h);
    fill(0);
    textAlign(CENTER, CENTER);
    text(""+value, 0, 0);
    popMatrix();
  }
}

class Information
{
  var x; var y; var w; var h;
  var message = [];
  Information(_x, _y, _w, _h)
  {
    x = _x; y = _y; w = _w; h = _h;
  }
  
  void draw()
  {
    stroke(0); strokeWeight(1); fill(255, 255, 100);
    rectMode(CORNERS);
    pushMatrix();
    translate(x, y);
    rect(0, 0, w, h);
    fill(0);
    textAlign(LEFT, CENTER);
    translate(5, 0);
    translate(0, 10);
    for (int i = 0; i < message.length; i++)
    {
      text(message[i], 0, 0);
      translate(0, 15);
    }
    popMatrix();
  }
}






class ButtonOptionList
{
  var bL = [];
  
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
  
  void buttonDown(id)
  {
    for (int i = 0; i < bL.length; i++) bL[i].selected = false;
    bL[id].selected = true;
  }
}