var isMobile;
var pjsCM = null; 
var pjs = null;
var doFirstMouseDown = false;
var firstMouseX;
var firstMouseY;
var ctx;

if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) == true ) 
{
  isMobile = true;
} 
else 
{
  isMobile = false;
} 

function doOnOrientationChange() 
{ 
  callProcessing_SizeChanged(); 
} 

function callProcessing_SizeChanged() 
{ 
  if (pjsCM == null) pjsCM = Processing.getInstanceById("ControlManager"); 
  pjsCM.sizeChanged(); 
} 

function doOnKeyDown()
{
  if (isDisplay == false) return;
  
  if (event.keyCode === 8) // backspace
  {
    if (pjsCM == null) pjsCM = Processing.getInstanceById("ControlManager"); 
    pjsCM.doBackspace();
    event.preventDefault();
  }
}

function onTouchStart(event)
{
  if (isDisplay == false) return;
  
  doFirstMouseDown = true;
  firstMouseX = event.changedTouches[0].pageX;
  firstMouseY = event.changedTouches[0].pageY;
}

function readCombinedFiles(filesToLoad)
{
  var code = "";
  
  var files = filesToLoad.split(' ');
  for (var i = 0; i < files.length; i++)
  {
    var file = files[i];
    if (file != "")
    {
      code = code + readFile(file);
    }
  }
  
  return code;
}

function readFiles(filesToLoad)
{
  var fileCodes = new Array();
  
  var files = filesToLoad.split(' ');
  for (var i = 0; i < files.length; i++)
  {
    var file = files[i];
    if (file != "")
    {
      fileCodes[i] = {name: file, code: readFile(file)};
    }
  }
  
  return fileCodes;
}

function combineCode(baseCode, myCodeArray)
{
  var code = "";
  code = code + baseCode;
  for (var i = 0; i < myCodeArray.length; i++)
  {
    code = code + myCodeArray[i].code;
  }
  return code;
}

function readFile(fileToLoad)
{
  var xmlhttp;
  xmlhttp = new XMLHttpRequest();
  xmlhttp.open('GET', fileToLoad, false);
  xmlhttp.send();
  return xmlhttp.responseText;
}


function highlightButton(e)
{
  
  var x = document.getElementById("tabs");
  for (var b = 0; b < x.childNodes.length; b++)
  {  
    var ni = x.childNodes[b];
    if(ni.nodeName == "BUTTON") ni.className = "notSelected";
  }
  document.getElementById("infoButton").className = "";
  document.getElementById("dataButton").className = "";
    
  if (e != null)
  {
    e.className = "Selected";
  }
}

var displayInfoDescription = false;
function displayCode(i, e)
{
  if (e != null) highlightButton(e);
  
  document.getElementById("code1").style.display = 'inline-block';
  document.getElementById("infoDescription").style.display = 'none';
  document.getElementById("data").style.display = 'none';
  displayInfoDescription = false;
  
  saveCurrentCode();
  document.getElementById("code1").innerHTML = "<pre>" + myCodeArray[i].code + "</pre>";
  currentCodeId = i;
  loadCode();
}


//function loadCode(fileToLoad, element)
//{
//  element.innerHTML = "<pre>" + readFile(fileToLoad) + "</pre>";
//}

var isDisplay = true;
function showCode()
{
  if (pjs != null) { pjs.saveData(); }
  setData();
  
  if (pjsCM == null) pjsCM = Processing.getInstanceById("ControlManager");
  pjsCM.noLoop();
  // show code
  document.getElementById("display").style.display = 'none';
  document.getElementById("info").style.display = 'block';
  document.body.style.overflowX = "auto";
  document.body.style.overflowY = "auto";
  isDisplay = false;
  //document.getElementById("code1").blur();
  document.body.style.zoom = "" + zmLevel + '%';
}

function showDisplay()
{
  // show display
  document.getElementById("info").style.display = 'none';
  document.getElementById("display").style.display = 'inline'
  //document.body.style.overflowX = "hidden";
  //document.body.style.overflowY = "hidden";
  //document.body.style.overflow = "hidden";
  document.body.style.overflow = "hidden";
  if (pjsCM == null) pjsCM = Processing.getInstanceById("ControlManager");
  pjsCM.resetMouse();
  pjsCM.loop();
  isDisplay = true;
  //document.getElementById("display").focus();
}


var displayInfoDescriptionHTML = ""
function displayInfo(e)
{
  highlightButton(null);
  e.className = "Info";
  document.getElementById("code1").style.display = 'none';
  document.getElementById("infoDescription").style.display = 'inline-block';
  document.getElementById("data").style.display = 'none';
  displayInfoDescription = true;
  
  if (displayInfoDescriptionHTML == "") 
  {
    displayInfoDescriptionHTML = readFile("_info.html");
    document.getElementById("infoDescription").innerHTML = displayInfoDescriptionHTML;
  }
}

var data = "";
if (iniDataFile != "") data = readFile(iniDataFile);
function loadDataFile(s)
{
  data = readFile(s);
  if (pjs != null) { pjs.resetData(); }
}

function setData()
{
  document.getElementById("data").innerHTML = "<pre>" + data + "</pre>";
}

function displayData(e)
{
  highlightButton(null);
  e.className = "Data";
  document.getElementById("code1").style.display = 'none';
  document.getElementById("infoDescription").style.display = 'none';
  document.getElementById("data").style.display = 'inline-block';
  displayInfoDescription = true;
  
  //if (displayInfoDescriptionHTML == "") displayInfoDescriptionHTML = readFile("_info.html");
  //document.getElementById("infoDescription").innerHTML = displayInfoDescriptionHTML;
}

var zmLevel = 100;

function zoomReset()
{
  zmLevel = 100;
  //document.getElementById("code1").style.zoom = "" + zmLevel + '%';
  document.body.style.zoom = "" + zmLevel + '%';
}

function zoomIn()
{
  zmLevel += 40;
  //document.getElementById("code1").style.zoom = "" + zmLevel + '%';
  document.body.style.zoom = "" + zmLevel + '%';
}

function zoomOut()
{
  zmLevel -= 40;
  if (zmLevel < 100) zmLevel = 100;
  //document.getElementById("code1").style.zoom = "" + zmLevel + '%';
  document.body.style.zoom = "" + zmLevel + '%';
}

function saveCurrentCode()
{
  if (currentCodeId > -1)
  {
    var x = (document.getElementById("code1"));
    myCodeArray[currentCodeId].code = x.innerText || x.textContent;
  }
}

function removeLoadingImage()
{
  var i = document.getElementById("loadingImage1");
  i.parentNode.removeChild(i);
  i = document.getElementById("loadingImage2");
  i.parentNode.removeChild(i);
}

function runCode()
{
  var d = document.getElementById("data");
  data = d.innerText || d.textContent;
  
  saveCurrentCode();
  
  if (pjs != null) { pjs.exit(); }
  pjs = null;
  
  // need to remove and re-add so that P2D and P3D works
  // because the context is linked to the canvas
  var canvas = document.getElementById("mySketch");
  var parent = canvas.parentNode;
  parent.removeChild(canvas);
  canvas = document.createElement("CANVAS");
  canvas.setAttribute("id", "mySketch");
  parent.appendChild(canvas);
  var processingCode = combineCode(baseCode, myCodeArray);
  pjs = new Processing(canvas, processingCode);
  //pjs.resetData();
  
  if (pjsCM == null) pjsCM = Processing.getInstanceById("ControlManager");
  pjsCM.resetControlManager();
  
  // Need this in a timeout so that it gets called after everything is rendered
  setTimeout(focusOnDisplay, 500); 
}

function focusOnDisplay()
{
  document.getElementById("ControlManager").focus();
}


document.addEventListener('touchstart', onTouchStart);
window.addEventListener('keydown', doOnKeyDown); 
window.addEventListener('orientationchange', doOnOrientationChange); 
window.onresize=function() { callProcessing_SizeChanged(); };


//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

//file:///C:/Sanath/Projects/Web/MyCodeMirror/simple2.html

//https://developer.mozilla.org/en/docs/Web/JavaScript/Guide/Regular_Expressions
//http://jsfiddle.net/cpatik/3QAeC/
//http://stackoverflow.com/questions/13949059/persisting-the-changes-of-range-objects-after-selection-in-html/13950376#13950376
//http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
//http://codebits.glennjones.net/editing/events-contenteditable.htm
//http://regexpal.com/
//http://cs.smu.ca/~porter/csc/355/regexpal/
//http://regexpal.com/
// http://www.w3schools.com/cssref/css_websafe_fonts.asp
//http://jaspreetchahal.org/how-to-disable-autocorrect-spellcheck-and-autocomplete-html5-tip/

function re_keywordJoin(words)
{
  return new RegExp('((\\b' +  words.join("\\b)|(\\b")   + '\\b))');
}

var strTab = "  ";

var inMultiLineComment = false;
var formatted = "";

var re_startingSpaces = new RegExp('^(\\s*)');
var re_singleComment = new RegExp('//.*'); 
var re_multiCommentStart = new RegExp('/\\*');
var re_multiCommentEnd = new RegExp('\\*/');
var re_string = new RegExp('".*?"');
//var re_keyword1 = new RegExp('((\\bfloat\\b)|(\\bboolean\\b))', 'g'); // need to put \b but because of escape in javascript (not regex) need \\b
var re_keyword1 = re_keywordJoin(['float', 'boolean', 'int', 'double', 'class', 'var', 'string', 'if', 'else', 'for', 'break', 'void']);
var re_number = new RegExp('(\\b\\d+\\.*\\d*|\\.\\d+)');

function formatPreLineSegment(line)
{
  var match_string = line.match(re_string);
  if (match_string)
  {
    var loc = match_string.index;
    var preLine = line.substring(0, loc);
    formatPreLineSegment(preLine);
    formatted += "<span class='string'>" + match_string[0] + "</span>";
    line = line.substring(loc+match_string[0].length);    
    formatPreLineSegment(line);
    return;
  }
  else
  {
    var match_number = line.match(re_number);
    var match_keyword1 = line.match(re_keyword1);
    
    var m = Number.MAX_VALUE;
    
    if (match_number) m = Math.min(m, match_number.index);
    if (match_keyword1) m = Math.min(m, match_keyword1.index);
    
    if (match_number && match_number.index == m)
    {
      //for (var i = 0; i < match_number.length; i++)
      //{
      //  line = line.replace(new RegExp(match_number[i], 'g'),"<span class='number'>" + match_number[i] +"</span>");
      //}
      var loc = match_number.index;
      formatted +=line.substring(0, loc);
      formatted += "<span class='number'>" + match_number[0] + "</span>";
      line = line.substring(loc+match_number[0].length);    
      formatPreLineSegment(line);
      return;
    }
    
    if (match_keyword1 && match_keyword1.index == m)
    {
      //for (var i = 0; i < match_keyword1.length; i++)
      //{
      //  line = line.replace(new RegExp(match_keyword1[i], 'g'),"<span class='keyword1'>" + match_keyword1[i] +"</span>");
      //}
      //formatted += line;
      var loc = match_keyword1.index;
      //var preLine = line.substring(0, loc);
      //formatPreLineSegment(preLine);
      formatted +=line.substring(0, loc);
      formatted += "<span class='keyword1'>" + match_keyword1[0] + "</span>";
      line = line.substring(loc+match_keyword1[0].length);    
      formatPreLineSegment(line);
      //formatted += line;
      return;
    }
    
    formatted += line;
    
    
  }
}

function formatLineSegment(line)
{   

    if (inMultiLineComment == false)
    {
      var match_singleComment = line.match(re_singleComment);
      var match_multiCommentStart = line.match(re_multiCommentStart);
      
      
      //if (dbg == true) alert(line);
      //if (dbg == true) alert(inMultiLineComment);
      
      if 
      (
        (match_singleComment && !match_multiCommentStart)
        ||
        (match_singleComment && match_multiCommentStart && match_singleComment.index < match_multiCommentStart.index)
      )
      {
      
        var loc = match_singleComment.index;
        var preLine = line.substring(0, loc);
        formatPreLineSegment(preLine);
        line = line.substring(loc);
        line = line.replace(match_singleComment[0],"<span class='comment'>" + match_singleComment[0] +"</span>");
        formatted += line;
      }
      else if 
      (
        (match_multiCommentStart && !match_singleComment)
        ||
        (match_multiCommentStart && match_singleComment && match_multiCommentStart.index < match_singleComment.index)
      )
      {
        var loc = match_multiCommentStart.index;
        var preLine = line.substring(0, loc);
        formatPreLineSegment(preLine);
        
        formatted += "<span class='comment'>" + match_multiCommentStart[0];
        inMultiLineComment = true;
        
        formatLineSegment(line.substring(loc+match_multiCommentStart[0].length));
        //line = line.replace(match_multiCommentStart[0],"<span class='comment'>" + match_multiCommentStart[0]);
        //formatted += line;
        
      }
      else
      {
        formatPreLineSegment(line);
      }
    }
    else
    {
      var match_multiCommentEnd = line.match(re_multiCommentEnd);
      if (match_multiCommentEnd)
      {
        //line = line.replace(match_multiCommentEnd[0],match_multiCommentEnd[0] +"</span>");
        inMultiLineComment = false;
        //formatted += line;
        var loc = match_multiCommentEnd.index + match_multiCommentEnd[0].length;
        formatted += line.substring(0, loc) +"</span>";
        formatLineSegment(line.substring(loc));
      }
      else
      {
        formatted += line;
      }
    }
    
    
}

function loadCode()
{
  var code = (document.getElementById("code1"));
  formatted = code.innerHTML;
  
  //formatted = formatted.replace('\n',''); // remove the first newline
  
  var re = new RegExp('\t', "mg");        // change all newlines to <br>
  formatted = formatted.replace(re,strTab); // make tabs spaces
  
  re = new RegExp('\n', "mg");        // change all newlines to <br>
  formatted = formatted.replace(re,'<br>');
  code.innerHTML = formatted;
  
  formatCode();
}


var startingSpaces = new Array();
function formatCode()
{
  inMultiLineComment = false;
  
  var code = (document.getElementById("code1"));
  var raw = code.innerText || code.textContent;
  var lines = new Array();
  lines = raw.split('\n');
  
 
  formatted = "";
  for (var i = 0; i < lines.length; i++)
  {
    var line = lines[i];
    
    var match_startingSpaces = line.match(re_startingSpaces);
    if (match_startingSpaces)
    {
      startingSpaces[i] = match_startingSpaces[0];
    }
    else
    {
      startingSpaces[i] = "";
    }
  
    
    formatLineSegment(lines[i]);
    if (i != lines.length-1) formatted += "<br>";
    if (i == prevLineEnter)
    {
      formatted += startingSpaces[i];
      prevLineEnter = -1;
      if (addBr == false) brCount = i+1;
      charCount = startingSpaces[i].length;
    }

  }
  
  prevLineEnter = -1;
  
  code.innerHTML = "<pre>" + formatted + "</pre>";
}







  //////////////////////////////////////////////////////////////////////////////////
  function displayNode(x, t)
  {
    console.log(t + x.nodeName + ": " + (x.innerText || x.textContent));
    
    for (var i = 0; i < x.childNodes.length; i++)
    {      
      var ni = x.childNodes[i];
      displayNode(ni, t+"    ");
    }
  }
  
  // ######################################################################
  //.......................................................................
  var brCount = 0;
  var charCount = 0;
  function getCurrentLineAndColumn(x)
  {
    var range = window.getSelection().getRangeAt(0);
    var n = range.startContainer;
    var o = range.startOffset;
    if (n.nodeName != "#text") {n = n.childNodes[o]; o = 0;}
    brCount = 0;
    charCount = 0;
    countBRsAndCharstoNode(x, n);
    var v = n.innerText || n.textContent;
    if (o > 0 && v[0] == '\n') o = o-1;
    charCount += o;
  }
  function countBRsAndCharstoNode(x, n)
  {
    if (x != n && x.nodeName == "BR") {brCount++; charCount=0;}
    
    if (x!= n && x.nodeName == "#text")
    {
      var v = x.innerText || x.textContent; 
      v = v.replace(new RegExp('\n', 'g'),'');
      charCount += v.length;
    }
    
    if (x == n) return false;
    
    for (var i = 0; i < x.childNodes.length; i++)
    {      
      var ni = x.childNodes[i];
      var r = countBRsAndCharstoNode(ni, n);
      if (r == false) return false;
    }
    return true;
  }
  //.......................................................................
  
  var selNode;
  var selOffset;
  var brNode;
  function setCurrentLineAndColumn(x)
  {
    selNode = null;
    selOffset = 0;
    brNode = null;
    setNodeAndOffset(x);
    var range = document.createRange();
    range.setStart(selNode, selOffset);
    range.setEnd(selNode, selOffset);
    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);
  }
  
  function setNodeAndOffset(x)
  {
    if (x.nodeName == "BR") {brCount--;}

    if ((brNode != null && x != brNode && brCount <= 0))
    {
      if (x.nodeName == "#text")
      {
        var v = x.innerText || x.textContent; 
        
        var addOne = 0;
        if (v[0] == '\n')
        {
          v = v.replace(new RegExp('\n', 'g'),'');
          addOne = 1;
        }
        
        selOffset = charCount + addOne;
        charCount -= v.length;  
      }
      
      if (charCount <= 0)
      {
        if (x.nodeName == "#text")
        {
          selNode = x;
        }
        else
        {
          selNode = x.parentNode;
          for (var i = 0; i < selNode.childNodes.length; i++)
          {
            if (selNode.childNodes[i] == x) break;
          }
          selOffset = i;
          if (addBr == true && x.nextSibling != null && x.nextSibling.nodeName == "BR") selOffset++;
        }
        return false;
      }
    }
    
    if (brCount == 0) brNode = x;
    
    for (var i = 0; i < x.childNodes.length; i++)
    {      
      var ni = x.childNodes[i];
      var r = setNodeAndOffset(ni);
      if (r == false) return false;
    }
    return true;
  }
  //.......................................................................
  // ######################################################################

  function updateCode(e)
  {
    if (isDisplay == true) return;
    if (displayInfoDescription == true) return;
    
    if (e == null || e.ctrlKey == null || e.keyCode == null || (e.ctrlKey != null && e.ctrlKey == false && e.keyCode != 17))
    {
    //console.log();
      var x = document.getElementById("code1");
      getCurrentLineAndColumn(x);

      //x.innerHTML = x.innerHTML;
      formatCode();
      
      setCurrentLineAndColumn(x);
      addBr = false;
    }
  }
  
  var addBr = false;
  var prevLineEnter = -1;
  function checkEnter(e)
  {
    //alert(e.keyCode);
    if (e.keyCode == 9)
    {
      //alert("A");
      e.preventDefault();
      var sel = window.getSelection();
      var range = sel.getRangeAt(0);
      range.deleteContents();
      var node = document.createTextNode(strTab);
      range.insertNode(node);
      
      range.setStart(node, strTab.length);
      range.setEnd(node, strTab.length);
      var sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
    }
    
    if (e.keyCode == 13)
    {
      addBr = true;
      var x = document.getElementById("code1");
      getCurrentLineAndColumn(x);
      prevLineEnter = brCount;
      if (charCount != 0) addBr = false;
    }
  }
  
  window.addEventListener('keyup', updateCode); 
  //document.keyup
  //////////////////////////////////////////////////////////////////////////////////
