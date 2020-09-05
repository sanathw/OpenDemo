class ContractButton extends Button
{
  ContractButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
  
  void draw()
  {
    super.drawBegin();
    
    stroke(0); strokeWeight(1); fill(190);
    
    if((isOver && mousePressed) || selected) fill(255, 0, 0);
    
    rect(0, 0, w, h);
    fill(0); text(""+value, 0, 0);
    
    super.drawEnd();
  }
}


class SuiteButton extends Button
{
  SuiteButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
  
  void draw()
  {
    super.drawBegin();
    
    stroke(0); strokeWeight(1); fill(190);
    
    if((isOver && mousePressed) || selected) fill(0, 255, 0);
    
    rect(0, 0, w, h);
    fill(0); text(""+value, 0, 0);
    
    super.drawEnd();
  }
}


class DoubleButton extends Button
{
  DoubleButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
  
  void draw()
  {
    super.drawBegin();
    
    stroke(0); strokeWeight(1); fill(190);
    
    if((isOver && mousePressed) || selected) fill(0, 0, 255);
    
    rect(0, 0, w, h);
    fill(0); text(""+value, 0, 0);
    
    super.drawEnd();
  }
}


class VulnerableButton extends Button
{
  VulnerableButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
  
  void draw()
  {
    super.drawBegin();
    
    stroke(0); strokeWeight(1); fill(190);
    
    if((isOver && mousePressed) || selected) fill(255, 255, 0);
    
    rect(0, 0, w, h);
    pushMatrix();
    scale(0.5);
    fill(0); text(""+value, 0, 0);
    popMatrix();
    
    super.drawEnd();
  }
}


class MakingButton extends Button
{
  MakingButton(_x, _y, _w, _h, _value, _callback, _id) {super(_x, _y, _w, _h, _value, _callback, _id);}
  
  void draw()
  {
    super.drawBegin();
    
    stroke(0); strokeWeight(1); fill(190);
    
    if((isOver && mousePressed) || selected) fill(255, 0, 0);
    
    rect(0, 0, w, h);
    fill(0); text(""+value, 0, 0);
    
    super.drawEnd();
  }
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
    if( mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b)
    {
      isOver = true;
      if (mousePressed && !pmousePressed && callback != null) callback(id);
      if (mousePressed) return true;
    }
    return false;
  }
  
  void drawBegin()
  {
    checkPressed();
    rectMode(CENTER); textAlign(CENTER, CENTER);
    pushMatrix();
    translate(x, y);
  }
  
  void drawEnd()
  {
    popMatrix();
  }
  
  void draw()
  {
    drawBegin();
    
    stroke(0); strokeWeight(1); fill(190);
    
    if(isOver) fill(255, 255, 0);
    
    rect(x, y, w, h);
    drawEnd();
  }
}