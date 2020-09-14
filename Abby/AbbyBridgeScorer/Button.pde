class ContractButton extends Button
{
  ContractButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
}


class SuiteButton extends Button
{
  SuiteButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
  
  void draw()
  {
    super.drawBegin();
    
    var img = null;
    switch(value)
    {
      case "C": img = imgClubs; break;
      case "H": img = imgHearts; break;
      case "D": img = imgDiamonds; break;
      case "S": img = imgSpades; break;
      default: img = null;
    }
    
    if (img != null) 
    {
      pushMatrix();
      image(img, 0, 0, w-4, h-4);
      popMatrix();
      showValue = false;
    }
    
    super.drawEnd();
  }
}


class DoubleButton extends Button
{
  DoubleButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
}


class VulnerableButton extends Button
{
  VulnerableButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id); showValue = false;}
  
  void draw()
  {
    super.drawBegin();
    
    var s = 0.5;
    if((isOver && mousePressed) || selected) s = 1;
    
    var c = null;
    switch(value)
    {
      case "Vul": c = color(255, 0, 0); break;
      case "Non-Vul": c = color(0, 255, 0); break;
      default: img = color(0, 0);
    }
    pushMatrix();
    scale(s);
    fill(c);
    rect(0, 0, w, h);
    popMatrix();
    
    super.drawEnd();
  }
}


class MakingButton extends Button
{
  MakingButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
}




class Button
{
  var x; var y; var w; var h;
  var l; var t; var r; var b;
  var callback;
  var id;
  var isOver = false;
  var value;
  var selected = false;
  var showValue = true;
  bar margin = 2.5;
  
  Button(_x, _y, _w, _h, _value, _callback, _id)
  {
    x = _x; y = _y; w = _w; h = _h;
    l = x - w/2; t = y - h/2;
    r = l + w;   b = t + h;
    value = _value;
    callback = _callback;
    id = _id;
  }
  
  boolean checkPressed()
  {
    isOver = false;
    if( mouseX >= l-margin && mouseX <= r+margin && mouseY >= t-margin && mouseY <= b+margin)
    {
      isOver = true;
      if (mousePressed && !pmousePressed && callback != null) callback(id);
      if (mousePressed) return true;
    }
    return false;
  }
  
  void doHighlight1()
  {
    stroke(0); strokeWeight(1); fill(255);
    rect(0, 0, w, h);
  }
  
  void doHighlight2()
  {
    stroke(0); strokeWeight(1); noFill();
    rect(0, 0, w, h);
  }
  
  void noHighlight()
  {
    stroke(0, 0); strokeWeight(0.001); fill(255, 40);
    rect(0, 0, w, h);
  }
  
  void drawBegin()
  {
    checkPressed();
    rectMode(CENTER); textAlign(CENTER, CENTER);
    pushMatrix();
    translate(x, y);
    
    //if((isOver && mousePressed) || selected) doHighlight1();
    if(selected) doHighlight1();
    else noHighlight();
  }
  
  void drawEnd()
  {
    //if((isOver && mousePressed) || selected) doHighlight2();
    if(selected) doHighlight2();
    
    if (showValue)
    {
      fill(0); 
      pushMatrix();
      scale(1.2);
      text(""+value, 0, 0);
      popMatrix();
    }
    
    popMatrix();
  }
  
  void draw()
  {
    drawBegin();
    
    drawEnd();
  }
}