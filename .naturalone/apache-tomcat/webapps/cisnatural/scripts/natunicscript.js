// Copyright (c) Software AG, Darmstadt
var COMMAND_URL = "clientCommand?";
var DEF_START_PAGE = "natural.jsp";
var CIS_WEBIO_PAGE = "servlet/StartCISPage?PAGEURL=/cisnatural/natlegacy.html";
var CIS_START_PAGE = "servlet/StartCISPage?PAGEURL=/cisnatural/NatLogon.html";
var FIRSTSCREEN = "1";
var CHECKSCREEN = "2";
var SCREENUPDATE = "4";
var DISCONNECT = "5";
var COMMAND_HEADER = "NUCommand";
var RESPONSE_HEADER = "NUResponse";
var WINDOW_ID_HEADER = "NUWindowHeader";
var RTL_HEADER = "NURTLHeader";
var SCREEN_ROWS_HEADER = "NUScreenRows";
var SCREEN_COLS_HEADER = "NUScreenCols";
var LOGON_MESSAGE_HEADER = "NULogonMessage";
var NAT_MESSAGE_HEADER = "NUNatMessage";
var RESP_SCREEN_OK = "1001";
var RESP_NO_SCREEN = "1002";
var RESP_ASYNCH_SCREEN = "1003";
var RESP_HOST_DISCONNECTED = "1004";
var RESP_CALL_CANCELLED = "1005";
var RESP_CALL_NOACTION = "1006";
var RESP_RICH_SCREEN = "1007";
var RESP_IN_ASYNCH_MODE = "1008";
var RESP_NO_ADAPTER = "1009";
var RESP_NO_CONNECTION = "1010";
var DIV_BASE_NAME  = "layer";
var DIV_SCREEN_NAME  = "mainlayer";
var DIV_SCREEN_NAME_RTL  = "mainlayer_rtl";
var DIV_PFKEY_NAME  = "pfkeydiv";
var DIV_PFKEY_NAME_RTL  = "pfkeydiv_rtl";
var PFKEYS_ENTRY = "pfkeys";
var PFKEY_DATA = "pfkey";
var PFKEY_ID = "pfkeydata";
var WINTITLE = "nuwintitle";
var WINWIDTH = "nuwinwidth";
var WINHEIGHT = "nuwinheight";
var WINROW = "nuwinrow";
var WINCOL = "nuwincol";
var WINATTRIBUTES = "nuwinattributes";
var NUWINDOW = "nuwindow";
var NUWINDOWID = "window";
var pkeyData = null;
var windowData = null;
var firstScreen;
var noCloseMessage = false;
var richScreen = false;
var PFCOUNT = "count";
var PFTOOLTIP = "tooltip";
var PFNUMBER = "number";
var fontHeight = 10;
var fontWidth = 12;
var X_COORD_OFFSET = 0;
var Y_COORD_OFFSET = 0;
var bWaitingForServer = false;
var bSentScreenUpdate = false;
var httpRequestMain = false;
var iStoredWindowID = 0;
var activeDivArea = null;
var mainDivArea = null;
var pkeyDivArea = null;
var iCurrScreenRows = 24;
var iCurrScreenCols = 80;
var iAllowedKeys = 0;
var iAllowedKeysCount = null;
var iColSchemeCount = null;
var focusField = "";
var focusElem = null;
var isRichClientType = 0;
var varTimeOut=null;
var iTimeout = 120000;
var session_id=null;
var subsession_id = null;
var model_id = null;
var doubleClickBehavior = 50;
var showPFKeyNumbers = false;
var checkNumericFields = true;
var autoSkipToNext = false;
var displayAllPfKeys = 0;
var asyncMode = false;
var savedDivArea = null;
var sRTL = "ltr";
var copyMode=false;
var NCH_AT_WNOVLSCR = 0x10000000 /* 'S' */
var NCH_AT_WNOVLWIN = 0x20000000 /* 'W' */
var NCH_AT_WNOVLOFF = 0x40000000 /* 'O' */
var winScreenSwitch = "";
function getDocValue(xmlDoc, tag)
{
var outStr = "";
tempVal = xmlDoc.getElementsByTagName(tag);
if ((tempVal != null) && (tempVal[0] != null) && (tempVal[0].firstChild != null))
outStr = tempVal[0].firstChild.nodeValue;
return outStr;
}
function buildScreenUpdate(value)
{
var xmlNewDoc=null;
if (window.ActiveXObject)
{
xmlNewDoc=new ActiveXObject("Microsoft.XMLDOM");
}
else if (document.implementation && document.implementation.createDocument)
{
xmlNewDoc=document.implementation.createDocument("","",null);
}
var oNewItem = xmlNewDoc.createProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
xmlNewDoc.appendChild(oNewItem);
var screenElement = createScreenReturn(xmlNewDoc);
var returnElement = addReturnAction(xmlNewDoc, value);
var objectList = xmlNewDoc.createDocumentFragment();
var payloadNodeList = activeDivArea.getElementsByTagName("input");
var savedNodeList = savedDivArea.getElementsByTagName("input");
var focusID = 0;
if ((focusField != "") && (focusField.length > 8))
focusID = right(focusField, focusField.length - 8);
addAttribute(screenElement, xmlNewDoc, "focus_object", focusID);
addAttribute(screenElement, xmlNewDoc, "focus_value", saveCaret(focusElem));
var loop;
for (loop = 0; loop < payloadNodeList.length; loop++)
{
var object = payloadNodeList.item(loop);
if (object.type == "hidden"){
if (object.name == "_internal_hiddenscreenid")
{
addAttribute(screenElement, xmlNewDoc, "id", object.value);
}
}
else if ((object.type == "text") || (object.type == "password"))
{
var savedObject = savedNodeList.item(loop);
var testString = object.name;
if (left(testString, 8)  == "Element_")
{
if (savedObject.value != object.value)
{
addReturnObject(objectList, xmlNewDoc, "input", right(testString, testString.length - 8), object.value.translateChars(false));
}
}
}
}
screenElement.appendChild(returnElement);
screenElement.appendChild(objectList);
xmlNewDoc.appendChild(screenElement);
var sRet = "";
if (window.ActiveXObject)
{
sRet = xmlNewDoc.xml;
}
else if (typeof window.XMLSerializer != "undefined")
{
var xmlSerializer = new XMLSerializer();
sRet = xmlSerializer.serializeToString(xmlNewDoc);
}
screenElement.removeChild (returnElement);
screenElement = removeAllChildren (screenElement);
xmlNewDoc.removeChild (screenElement);
xmlNewDoc = null;
payloadNodeList = null;
oNewItem = null;
screenElement = null;
returnElement = null;
objectList = null;
return(sRet);
}
function handleDisconnect()
{
if ((isRichClientType==false) && (noCloseMessage == false))
{
makeAJAXRequest(COMMAND_URL, DISCONNECT, null, false);
}
}
function addReturnObject(parentElement, xmlNewDoc, objectType, objectID, objectValue)
{
var retObject = xmlNewDoc.createElement("object");
addAttribute(retObject, xmlNewDoc, "type", objectType);
addAttribute(retObject, xmlNewDoc, "id", objectID);
addAttribute(retObject, xmlNewDoc, "string", objectValue);
parentElement.appendChild(retObject);
}
function addReturnAction(xmlNewDoc, keyValue)
{
var returnElement = xmlNewDoc.createElement("return_action");
addAttribute(returnElement, xmlNewDoc, "value", keyValue);
return returnElement;
}
function createScreenReturn(xmlNewDoc)
{
var screenElement = xmlNewDoc.createElement("screen_update");
return screenElement;
}
function addAttribute(baseElement, xmlNewDoc, attrID, attrValue)
{
var nextAttr = xmlNewDoc.createAttribute(attrID);
nextAttr.value = attrValue;
attrMap = baseElement.attributes;
attrMap.setNamedItem(nextAttr);
}
function submitKeyPad(pkeyValue)
{
if (asyncMode)
return;
var sScreenUpdate = buildScreenUpdate(pkeyValue);
makeAJAXRequest(COMMAND_URL, SCREENUPDATE, sScreenUpdate, true);
bSentScreenUpdate = true;
setWaitCursor(true);
}
var directions = {
LEFT: 0,
RIGHT: 1,
UP: 2,
DOWN: 3
};
function getFieldInfo (inputObject)
{
var testtoolid = inputObject.getAttribute ('data-testtoolid');
var row = 0;
var column = 0;
var size = parseInt (inputObject.getAttribute ('size'),10);
if (testtoolid != null)
{
var parts = testtoolid.split ('_');
if (parts.length == 3)
{
column = parseInt (parts[1],10);
row = parseInt (parts[2],10);
}
}
return {
row: row,
column: column,
size: size
};
}
function jumpToNextInputField(direction)
{
var payloadNodeList = activeDivArea.getElementsByTagName("input");
var focusFound = false;
var focusCandidate = null;
var focusSet = false;
var loop=0;
var startFieldSel =0;
var startFieldInfo ;
var pos=0;
if (direction==directions.LEFT || direction==directions.UP)
{
loop = payloadNodeList.length-1;
}
while (!focusSet)
{
var inputObject = payloadNodeList.item(loop);
if ((inputObject.type == "text") || (inputObject.type == "password"))
{
if (focusFound) {
if (inputObject.readOnly==false)
{
if (direction==directions.RIGHT || direction==directions.LEFT)
{
setCaretPosition(payloadNodeList.item(loop), 0,false);
focusSet=true;
break;
}
else
{
var curField = getFieldInfo (payloadNodeList.item(loop));
if (direction==directions.DOWN && curField.row == startFieldInfo.row+1)
{
if (curField.column + curField.size >= startFieldSel)
{
pos = startFieldSel - curField.column;
if (pos > curField.size || pos<0)
pos = 0;
setCaretPosition(payloadNodeList.item(loop), pos,false);
focusSet=true;
break;
}
}
else if (direction==directions.UP && curField.row == startFieldInfo.row-1)
{
if (curField.column + curField.size > startFieldSel)
{
pos = startFieldSel - curField.column;
if (pos > curField.size || pos<0)
pos = 0;
focusCandidate = payloadNodeList.item(loop);
}
}
else if (curField.row != startFieldInfo.row)
{
if (focusCandidate==null)
{
setCaretPosition(payloadNodeList.item(loop), pos,false);
focusSet=true;
break;
}
else
{
setCaretPosition (focusCandidate,pos,false);
focusSet=true;
break;
}
}
else if (inputObject.name == focusElem.name)
{
if (focusCandidate==null)
{
setCaretPosition(payloadNodeList.item(loop), pos,false);
focusSet=true;
break;
}
setCaretPosition (focusCandidate,pos,false);
focusSet=true;
break;
}
}
}
}
else
{
if (inputObject.name == focusElem.name)
{
startFieldInfo = getFieldInfo (inputObject);
startFieldSel = startFieldInfo.column + focusElem.selectionStart;
focusFound = true;
}
}
}
if (direction==directions.RIGHT || direction==directions.DOWN)
{
loop++;
}
else
{
loop--;
}
if (direction==directions.RIGHT || direction==directions.DOWN)
{
if (loop>=payloadNodeList.length)
{
loop=0;
if (focusFound==false)
{
return false;
}
}
}
else
{
if (loop <= 0)
{
loop = payloadNodeList.length-1;
if (focusFound==false)
{
return false;
}
}
}
}
return true;
}
function checkKeyUp (wEvent)
{
var target = wEvent.target;
var currentKey = wEvent.keyCode || wEvent.which;
if (target.nodeName == "INPUT")
{
var newValue = target.value.translateChars(true);
if (newValue != target.value)
{
target.value = newValue;
}
}
if (autoSkipToNext==false)
return false;
if ((currentKey != 13) && (currentKey != 16) && (currentKey != 9) && (currentKey != 8) && ((currentKey<35) || (currentKey>40)) &&
((currentKey < 112) || (currentKey > 123)))
{
var curCaretPos = 0;
if ("selectionStart" in focusElem)
{
curCaretPos = focusElem.selectionStart;
if (focusElem.maxLength == curCaretPos)
{
jumpToNextInputField(directions.RIGHT);
}
}
else
{
if (document.selection == null) return;
focusElem.caretPos = document.selection.createRange();
focusElem.caretPos.moveStart ('character', -focusElem.value.length);
if (focusElem.caretPos.text != null)
{
curCaretPos = focusElem.caretPos.text.length;
}
if (curCaretPos >= focusElem.maxLength)
{
jumpToNextInputField(directions.RIGHT);
}
}
}
}
function preventDefault(event)
{
if (event.stopPropagation && event.preventDefault)
{
event.stopPropagation();
event.preventDefault();
}
else
{
event.keyCode = 0;
event.returnValue = false;
event.cancelBubble = true;
}
}
function pfkeyspreventDefault(event)
{
var currentKey = (event.keyCode) ?  event.keyCode : event.which;
if ((currentKey > 111) && (currentKey < 124))
{
preventDefault(event);
}
}
function checkKeyPress(wEvent)
{
var event;
if (bWaitingForServer)
{
preventDefault(wEvent);
return false;
}
if (wEvent!=null)
{
currentKey = wEvent.keyCode || wEvent.which;
event = wEvent;
}
else
return false;
if ((currentKey == 13) || ((currentKey > 111) && (currentKey < 124)))
{
if (currentKey == 13)
currentKey = 50;
else
{
currentKey -= 111;
if (event.shiftKey && event.ctrlKey)
currentKey += 50;
else if (event.shiftKey)
currentKey += 12;
else if (event.ctrlKey)
currentKey += 24;
else if (event.altKey)
currentKey += 36;
}
if (currentKey != 50)
{
if (currentKey == 1){
document.onhelp = function() {return (false);};
window.onhelp = function() {return(false);}
}
preventDefault(event);
}
submitKeyPad(currentKey);
return false;
}
else if (currentKey==89 && event.ctrlKey)
{
changeCopyMode (event);
}
if ("selectionStart" in focusElem)
{
if (currentKey==39)
{
if (focusElem.value.length == focusElem.selectionStart)
{
jumpToNextInputField(directions.RIGHT);
focusElem.setSelectionRange(0,0);
wEvent.preventDefault();
return true;
}
}
else if (currentKey==37)
{
if ( (0 == focusElem.selectionStart) && (focusElem.selectionEnd == 0) )
{
jumpToNextInputField(directions.LEFT);
focusElem.setSelectionRange(focusElem.maxLength,focusElem.maxLength);
wEvent.preventDefault();
return true;
}
}
else if (currentKey==38)
{
jumpToNextInputField(directions.UP);
wEvent.preventDefault();
return true;
}
else if (currentKey==40)
{
jumpToNextInputField(directions.DOWN);
wEvent.preventDefault();
return true;
}
}
}
function doGetCaretPosition (oField)
{
var iCaretPos = 0;
if (document.selection)
{
oField.focus ();
var oSel = document.selection.createRange ();
oSel.moveStart ('character', -oField.value.length);
iCaretPos = oSel.text.length;
}
return iCaretPos;
}
function makeAJAXRequest(sURL, sCommand, sRequestData, asynchronous)
{
bSendOK = false;
if (setMainHttpRequest(sCommand==DISCONNECT))
{
httpRequestMain.onreadystatechange = function () {if (httpRequestMain.readyState == 4) {processAJAXMainPacket();}};
httpRequestMain.open('POST', sURL, asynchronous);
httpRequestMain.setRequestHeader('Content-Type', 'text/xml; charset=UTF-8');
httpRequestMain.setRequestHeader(COMMAND_HEADER, sCommand);
if (session_id != null)
{
httpRequestMain.setRequestHeader('Session-ID', session_id);
}
if (subsession_id != null)
{
httpRequestMain.setRequestHeader('Subsession-ID', subsession_id);
}
if (model_id != null)
{
httpRequestMain.setRequestHeader('Model-ID', model_id);
}
httpRequestMain.send(sRequestData);
bSendOK = true;
}
return bSendOK;
}
function isNumeric(wEvent)
{
if (checkNumericFields==false)
return true;
var key;
var keychar;
var target = wEvent.target;
var currentKey = wEvent.keyCode || wEvent.which;
if (target.getAttribute("numeric") == "numeric")
{
key = currentKey;
keychar = String.fromCharCode(key);
if ((key==null) || (key==0) || (key==8) ||
(key==9) || (key==13) || (key==27) ||
(key==37) || (key==38) || (key==39) || (key==40) )
{
return true;
}
else if ((("0123456789+-_,. ?").indexOf(keychar) > -1))
{
return true;
}
else
{
return false;
}
}
return true;
}
function processAJAXMainPacket()
{
var locat;
var locat1;
var locat2;
var locat3;
var pathname;
var pathparts;
var cisurl;
var i;
if (!httpRequestMain)
return false;
switch (httpRequestMain.status){
case 200:
var sRespCode = httpRequestMain.getResponseHeader(RESPONSE_HEADER);
if (firstScreen){
var logonMessage = httpRequestMain.getResponseHeader(LOGON_MESSAGE_HEADER);
if ((logonMessage != null) && (logonMessage.length > 0)){
dispString = "";
for (var myLoop = 0; myLoop < logonMessage.length; myLoop++){
var testStr = logonMessage.substring(myLoop, myLoop + 1);
if (testStr == "|")
dispString += "\r\n";
else
dispString += testStr;
}
alert(dispString);
}
var natMessage = httpRequestMain.getResponseHeader(NAT_MESSAGE_HEADER);
if ((natMessage != null) && (natMessage.length>0))
{
natMessage = "Natural reported the following message while startup:\r\n\r\n"  + natMessage;
natMessage += "\r\n\r\nDo you want to continue?";
var answer = confirm (natMessage);
if (!answer)
{
window.open("disconnectPage.jsp", "_self");
return;
}
}
firstScreen = false;
}
if (bSentScreenUpdate)
{
document.body.style.cursor = "default";
document.documentElement.style.cursor = 'default';
}
bSentScreenUpdate = false;
if (varTimeOut != null)
{
clearTimeout (varTimeOut);
}
switch (sRespCode){
case RESP_SCREEN_OK:{
if (asyncMode)
setWaitCursor(false);
asyncMode=false;
if (processReceivedScreen()){
iTimeout = 120000;
varTimeOut = setTimeout('makeAJAXRequest(COMMAND_URL, CHECKSCREEN, null, true)', iTimeout);
}
else{
window.open("disconnectPage.jsp", "_self");
return;
}
}
break;
case RESP_NO_SCREEN:{
bWaitingForServer = false;
varTimeOut = setTimeout('makeAJAXRequest(COMMAND_URL, CHECKSCREEN, null, true)', iTimeout);
}
break;
case RESP_IN_ASYNCH_MODE: {
asyncMode=true;
varTimeOut = setTimeout('makeAJAXRequest(COMMAND_URL, CHECKSCREEN, null, true)', iTimeout);
}
break;
case RESP_ASYNCH_SCREEN:{
asyncMode=true;
if (processReceivedScreen()){
setWaitCursor(true);
makeAJAXRequest(COMMAND_URL, CHECKSCREEN, null, true);
iTimeout=100;
}
else{
window.open("disconnectPage.jsp", "_self");
return;
}
}
break;
case RESP_NO_ADAPTER:
break;
case RESP_NO_CONNECTION:
case RESP_HOST_DISCONNECTED:{
noCloseMessage = true;
if (isRichClientType)
{
locat = window.location.search;
locat1 = locat.replace ("?sessionid","&SESSIONID");
locat2 = locat1.replace ("subsessionid","SUBSESSIONID");
locat3 = locat2.replace ("modelid","MODELID");
pathname = window.location.pathname;
pathparts = pathname.split("/");
cisurl = "/";
for (i=1;i<pathparts.length-1;i++)
{
cisurl+=pathparts[i] + "/";
}
cisurl += CIS_WEBIO_PAGE + locat3 + "&WORKPLACE=true";
parent.parent.document.body.onunload = null;
parent.parent.document.body.onbeforeunload = null;
parent.parent.self.onunload = null;
parent.parent.self.onbeforeunload = null;
parent.parent.location.href = cisurl;
}
else
{
window.open("disconnectPage.jsp", "_self");
}
}
break;
case RESP_RICH_SCREEN:
{
noCloseMessage = true;
richScreen = true;
if (isRichClientType)
{
locat = window.location.search;
locat1 = locat.replace ("?sessionid","&SESSIONID");
locat2 = locat1.replace ("subsessionid","SUBSESSIONID");
locat3 = locat2.replace ("modelid","MODELID");
pathname = window.location.pathname;
pathparts = pathname.split("/");
cisurl = "/";
for (i=1;i<pathparts.length-1;i++)
{
cisurl+=pathparts[i] + "/";
}
cisurl += CIS_WEBIO_PAGE + locat3 + "&WORKPLACE=true";
parent.parent.document.body.onunload = null;
parent.parent.document.body.onbeforeunload = null;
parent.parent.self.onunload = null;
parent.parent.self.onbeforeunload = null;
parent.parent.location.href = cisurl;
}
else
{
alert ("Natural for Ajax screens are not supported with Natural WebIO");
window.open("disconnectPage.jsp", "_self");
}
}
break;
case RESP_CALL_CANCELLED:{
}
break;
case RESP_CALL_NOACTION:{
}
break;
default:{
}
break;
}
break;
case 12002:
case 12029:
case 12030:
case 12031:
case 12152:
makeAJAXRequest(COMMAND_URL, CHECKSCREEN, null, true);
break;
case 0:
break;
default:
alert("Error: Unexpected HTTP status: " + httpRequestMain.status);
try
{
if (httpRequestMain != null)
httpRequestMain.abort();
httpRequestMain = null;
}
catch(e)
{
}
if (isRichClientType)
{
pathname = window.location.pathname;
pathparts = pathname.split("/");
top.open("/" + pathparts[1] + "/" + CIS_START_PAGE, "_self");
}
else
{
window.open(DEF_START_PAGE, "_self");
}
}
}
function setMainHttpRequest(isDisconnectCmd)
{
var bOKToProcess = true;
if (bSentScreenUpdate)
bOKToProcess = false;
else if ((!bSentScreenUpdate) && (bWaitingForServer))
{
if (httpRequestMain != null)
httpRequestMain.abort();
httpRequestMain = null;
}
bOKToProcess |= isDisconnectCmd;
if (bOKToProcess)
{
httpRequestMain = null;
if (window.XMLHttpRequest)
{
httpRequestMain = new XMLHttpRequest();
}
else if (window.ActiveXObject)
{
try
{
httpRequestMain = new ActiveXObject("Msxml2.XMLHTTP");
}
catch (e)
{
try
{
httpRequestMain = new ActiveXObject("Microsoft.XMLHTTP");
}
catch (e)
{
bOKToProcess = false;
}
}
}
bWaitingForServer = true;
}
return bOKToProcess;
}
function removeAllChildren(divArea)
{
if (divArea == null){
return null;
}
if ( divArea.hasChildNodes() )
{
while ( divArea.childNodes.length >= 1 )
{
divArea.removeChild(divArea.firstChild);
}
}
return divArea;
}
function processReceivedScreen()
{
var xmlRespDoc;
if (window.DOMParser)
{
var xmlParser= new DOMParser();
xmlRespDoc = xmlParser.parseFromString(httpRequestMain.responseText, "text/xml");
}
else
{
xmlRespDoc = new ActiveXObject("Microsoft.XMLDOM");
xmlRespDoc.async = false;
xmlRespDoc.loadXML(httpRequestMain.responseText);
}
var iWindowID = parseInt(httpRequestMain.getResponseHeader(WINDOW_ID_HEADER));
sRTL = httpRequestMain.getResponseHeader(RTL_HEADER);
var payloadNodeTextList = xmlRespDoc.documentElement.childNodes;
var nodeLoop = 0;
var payloadNodeText = "";
while (nodeLoop < payloadNodeTextList.length)
{
if (payloadNodeTextList[nodeLoop].childNodes[0] != null)
payloadNodeText += payloadNodeTextList[nodeLoop].childNodes[0].data;
nodeLoop++;
}
var newScreenCols = httpRequestMain.getResponseHeader(SCREEN_COLS_HEADER);
var newScreenRows = httpRequestMain.getResponseHeader(SCREEN_ROWS_HEADER);
processXMLData(payloadNodeText);
activeDivArea = handleWindowLevel(iWindowID, payloadNodeText);
iStoredWindowID = iWindowID;
if (iWindowID == 0)
updateScreenLayout(newScreenCols, newScreenRows);
if (pkeyDivArea==null)
{
createPFKeyDiv (true);
}
processPKeyData();
var mainDiv = document.getElementById(DIV_SCREEN_NAME);
var pfkeydiv = document.getElementById(DIV_PFKEY_NAME);
if (sRTL != null)
{
document.body.dir=sRTL;
if (sRTL=="rtl")
{
if (mainDiv != null)
{
mainDiv.className = DIV_SCREEN_NAME_RTL;
mainDiv.dir="rtl";
}
if (pfkeydiv!=null)
{
pfkeydiv.className = DIV_PFKEY_NAME_RTL;
pfkeydiv.dir = "rtl";
}
}
else
{
if (mainDiv!=null)
{
mainDiv.className = DIV_SCREEN_NAME;
mainDiv.dir="ltr";
}
if (pfkeydiv!=null)
{
pfkeydiv.className = DIV_PFKEY_NAME;
pfkeydiv.dir = "ltr";
}
}
}
else
{
if (mainDiv!=null)
{
mainDiv.className = DIV_SCREEN_NAME;
mainDiv.dir="ltr";
}
if (pfkeydiv!=null)
{
pfkeydiv.className = DIV_PFKEY_NAME;
pfkeydiv.dir = "ltr";
}
}
activeDivArea = removeAllChildren (activeDivArea);
if (isNaN(iWindowID) && activeDivArea == null)
{
return false;
}
savedDivArea = removeAllChildren (savedDivArea);
activeDivArea.innerHTML = payloadNodeText;
savedDivArea = null;
savedDivArea = document.createElement("div");
savedDivArea.innerHTML = payloadNodeText;
if (winScreenSwitch=="screen")
{
var msgLine=getWindowMessageLine(iWindowID.toString());
if (msgLine != null)
{
setScreenMessageLine("0", msgLine);
if (iWindowID > 0)
clearWindowMessageLine(iWindowID.toString());
}
}
var focusData = 0;
var focusObject = null;
var focusObjectName = "";
var focusObjects = document.getElementsByName("_internal_focusobject");
var focusDataObjects = document.getElementsByName("_internal_focusdata");
if (focusObjects.length > 0)
{
var useIndex = 0;
var iLoop;
for (iLoop = 1; ((iLoop < focusObjects.length) && (useIndex == 0)); iLoop++)
{
var testObject = focusObjects.item(iLoop);
if (testObject != null){
if (testObject.getAttribute('disabled') != true)
useIndex = iLoop;
}
}
focusObjectName = "Element_" + focusObjects.item(useIndex).value;
var focusObjectList = document.getElementsByName(focusObjectName);
try
{
if (focusObjectList != null)
{
var foc=0;
for (foc=0;foc<focusObjectList.length ;foc++)
{
if (focusObjectList.item(foc)!=null && focusObjectList.item(foc).parentNode==activeDivArea)
{
focusObject = focusObjectList.item(foc);
}
}
}
}
catch (error)
{
focusObject = null;
}
}
if (focusObject == null)
{
focusObject = getFirstField();
focusData = 0;
}
if (focusDataObjects.length > 0)
focusData = focusDataObjects.item(0).value;
setCaretPosition(focusObject, focusData, true);
focusElem = focusObject;
httpRequestMain = null;
bWaitingForServer = false;
xmlRespDoc = null;
xmlParser = null;
document.execCommand("OverWrite", false, true);
return true;
}
function getFirstField()
{
var payloadNodeList = activeDivArea.getElementsByTagName("input");
var loop=0;
var field = null;
while (( field==null) && (payloadNodeList.length>loop))
{
var object = payloadNodeList.item(loop);
if (object==null){
return null;
}
if ((object.type == "text") || (object.type == "password"))
{
field = payloadNodeList.item(loop);
focusObject = field;
}
loop++;
}
return field;
}
function processPKeyData()
{
if (displayAllPfKeys > 0)
{
createPFToolbar(displayAllPfKeys);
updatePFToolbarEntries();
}
else
{
creatPFKeyButtons();
}
}
function trim (myString)
{
return myString.replace (/^\s+/, '').replace (/\s+$/, '');
}
function creatPFKeyButtons()
{
var iLoop;
if (pkeyData != null)
{
pkeyTree = pkeyData.getElementsByTagName(PFKEYS_ENTRY);
if ((pkeyTree != null) && (pkeyTree[0] != null)){
var attrMap = pkeyTree[0].attributes;
iAllowedKeysCount = parseInt(attrMap.getNamedItem(PFCOUNT).value);
if(isNaN(iAllowedKeysCount))
iAllowedKeysCount = 0;
}
if (iAllowedKeysCount != 0)
{
pkeys = pkeyData.getElementsByTagName(PFKEY_DATA);
htmlForDiv = "";
var iLoop=0;
if (sRTL=="rtl")
iLoop = iAllowedKeysCount - 1;
while (true)
{
var attrMap = pkeys[iLoop].attributes;
var pfNumber = parseInt(attrMap.getNamedItem(PFNUMBER).value);
var pfTitle = pkeys[iLoop].firstChild.nodeValue;
pfTitle = trim(pfTitle);
var sElementName = "<div class='PFButtonArroundDiv'>";
if (showPFKeyNumbers == "true")
{
sElementName += "<input class='PFButton' type='button' value='";
sElementName += getPfKeysText (pfNumber,false) + "=" + pfTitle + "' ";
}
else
{
sElementName += "<input class='ToolBarButton' type='button' value='";
sElementName += pfTitle + "' ";
}
sElementName += "title='";
sElementName += getPfKeysText (pfNumber,true)
sElementName += "' onclick='submitKeyPad(";
sElementName += pfNumber;
sElementName += ")'/></div>";
if (pfNumber == 50)
{
sElementName += htmlForDiv;
htmlForDiv = sElementName;
}
else
{
htmlForDiv += sElementName;
}
if (sRTL=="rtl"){
iLoop--;
if ( iLoop <= -1) break;
}
else
{
iLoop++;
if (iLoop >= iAllowedKeysCount) break;
}
}
var preText = "<br/>";
htmlForDiv = preText.concat (htmlForDiv);
htmlForDiv += "<br/><br/>";
if (pkeyDivArea!=null)
{
pkeyDivArea.innerHTML = htmlForDiv;
}
}
}
else
{
iAllowKeysCount = 0;
if (pkeyDivArea !=null) {
pkeyDivArea.innerHTML = "";
}
}
}
function createPFToolbar(numRows)
{
var rowCnt;
var myhtml= "<table>";
myhtml +="<tr>";
myhtml += "<td bottom='0%' height='1' valign='top' align='center' class='TDAroundControl' colspan='60'> ";
myhtml += "<table cellpadding='0' cellspacing='0'><tbody>";
for (rowCnt=1; rowCnt<numRows+1; rowCnt++)
{
myhtml += "<tr id='row" + rowCnt + "'>";
myhtml += "<td class='TDAroundControl'>";
myhtml += "<div class='TDAroundControlDiv'></div>";
myhtml += "</td>";
myhtml += "<td colspan='1' rowspan='1' class='TDAroundControl' align='left' valign='middle' width='60'>";
if (rowCnt == 1)
myhtml += "<button class='ToolBarButton' title='Enter' tabindex='1' type='button' id='pf50' onclick='submitKeyPad(50)'>&#160;Enter</button>";
myhtml += "</td>";
myhtml += "<td class='TDAroundControl' ";
myhtml += "<div class='TDAroundControlDiv'></div></td>";
var pfStart = 1 + ((rowCnt-1) * 12);
var pfStop = pfStart + 12;
var pfkey;
for (pfkey=pfStart; pfkey<pfStop;pfkey++)
{
myhtml += "<td colspan='1' rowspan='1' class='TDAroundControl' align='left' valign='middle' width='60'>";
var keyShortCut = getPfKeysText(pfkey,true);
myhtml += "<button class='ToolBarButton' title='" + keyShortCut + "' tabindex='1' type='button' id='pf" +pfkey +"' onclick='submitKeyPad("+pfkey+")'>&#160;PF"+pfkey+"</button>";
myhtml += "</td>";
myhtml += "<td class='TDAroundControl'>";
myhtml += "<div class='TDAroundControlDiv'></div></td>";
}
myhtml += "</tr>";
}
myhtml += "</tbody></table>";
myhtml += "</td>";
myhtml += "</tr>";
myhtml += "</table>";
if (pkeyDivArea != null)
{
pkeyDivArea.innerHTML = myhtml;
}
}
function updatePFToolbarEntries()
{
var iLoop;
if (pkeyData != null)
{
pkeyTree = pkeyData.getElementsByTagName(PFKEYS_ENTRY);
if ((pkeyTree != null) && (pkeyTree[0] != null))
{
var attrMap = pkeyTree[0].attributes;
iAllowedKeysCount = parseInt(attrMap.getNamedItem(PFCOUNT).value);
if(isNaN(iAllowedKeysCount))
iAllowedKeysCount = 0;
}
if (iAllowedKeysCount != 0)
{
pkeys = pkeyData.getElementsByTagName(PFKEY_DATA);
for (iLoop = 0; iLoop < iAllowedKeysCount; iLoop++)
{
var attrMap = pkeys[iLoop].attributes;
var pfNumber = parseInt(attrMap.getNamedItem(PFNUMBER).value);
var pfTitle = pkeys[iLoop].firstChild.nodeValue;
pfTitle = trim(pfTitle);
var pfkey = document.getElementById ("pf" + pfNumber);
if (pfkey==null)
{
var newButton = document.createElement("button");
addAttribute(newButton, document, "class", "ToolBarButton");
var titleStr = getPfKeysText(pfNumber,true);
addAttribute(newButton, document, "title", titleStr);
addAttribute(newButton, document, "tabindex", "1");
var id = "pf" + pfNumber;
addAttribute(newButton, document, "id", id);
addAttribute(newButton, document, "onclick", "submitKeyPad("+pfNumber+")");
var text = document.createTextNode(pfTitle);
newButton.appendChild(text);
var newTD = document.createElement("td");
addAttribute(newTD, document, "class", "TDAroundControl");
addAttribute(newTD, document, "align", "left");
addAttribute(newTD, document, "valign", "middle");
addAttribute(newTD, document, "width", "50");
newTD.appendChild(newButton);
var tdArround = document.createElement("td");
addAttribute(tdArround, document, "class", "TDAroundControl");
var divArroundDiv = document.createElement("div");
addAttribute(tdArround, document, "class", "TDAroundControlDiv");
tdArround.appendChild (divArroundDiv);
var row1 = document.getElementById ("row1");
row1.appendChild (newTD);
row1.appendChild (tdArround);
}
pfkey = document.getElementById ("pf" + pfNumber);
if (pfkey != null)
{
pfkey.title = getPfKeysText(pfNumber,true);
if (showPFKeyNumbers == "true")
{
var tempInner = getPfKeysText(pfNumber,false);
if (pfNumber <=48)
tempInner += "=" + pfTitle;
pfkey.childNodes[0].nodeValue = tempInner;
pfkey.className = "PFButton";
}
else
{
pfkey.childNodes[0].nodeValue  = pfTitle;
}
}
}
}
}
}
function getPfKeysText (pfNumber, withBlanks)
{
var tooltip="";
if (pfNumber <50)
{
if (withBlanks)
tooltip = "PF " + pfNumber;
else
tooltip = "PF" + pfNumber;
}
/*
else if (pfNumber <25)
{
tooltip = "Shift-F" + (pfNumber-12);
}*/
else if (pfNumber == 50)
{
tooltip = "Enter";
}
else if (pfNumber>=51 && pfNumber<=53)
{
var panum = pfNumber-50;
if (withBlanks)
tooltip = "PA " + panum;
else
tooltip = "PA" + panum;
}
else if (pfNumber==54)
{
tooltip = "Clear";
}
else if (pfNumber==55)
{
tooltip = "PgUp";
}
else if (pfNumber==56)
{
tooltip = "PgDn";
}
return tooltip;
}
function enableStyleSheet (styleSheetName, enabled)
{
for( var i in document.styleSheets )
{
if (document.styleSheets[i].href != null)
{
var sHref = document.styleSheets[i].href.split('?')[0];
var styleSheetNameLen = sHref.length;
if (sHref.substr(styleSheetNameLen-styleSheetName.length, styleSheetNameLen-1) ==  styleSheetName )
{
document.styleSheets[i].disabled = !enabled;
break;
}
}
}
}
function updateScreenLayout(newScreenCols, newScreenRows)
{
if (newScreenRows>40)
{
enableStyleSheet ("model2.css", false);
enableStyleSheet ("model3.css", false);
enableStyleSheet ("model4.css", true);
enableStyleSheet ("model5.css", false);
}
else if (newScreenRows>30)
{
enableStyleSheet ("model2.css", false);
enableStyleSheet ("model3.css", true);
enableStyleSheet ("model4.css", false);
enableStyleSheet ("model5.css", false);
}
else if (newScreenCols>100)
{
enableStyleSheet ("model2.css", false);
enableStyleSheet ("model3.css", false);
enableStyleSheet ("model4.css", false);
enableStyleSheet ("model5.css", true);
}
else
{
enableStyleSheet ("model2.css", true);
enableStyleSheet ("model3.css", false);
enableStyleSheet ("model4.css", false);
enableStyleSheet ("model5.css", false);
}
if ((newScreenCols != iCurrScreenCols) || (newScreenRows != iCurrScreenRows))
{
var oldDiv = document.getElementsByName(DIV_SCREEN_NAME)[0];
if (oldDiv != null)
document.body.removeChild(oldDiv);
iCurrScreenCols = parseInt(newScreenCols);
iCurrScreenRows = parseInt(newScreenRows);
}
createBaseScreenLayout();
}
function processXMLData(newHTML)
{
var xmlDataIsland = null;
var newDivArea = document.createElement("div");
newHTML = convertSpecialChars(newHTML);
newDivArea.innerHTML = newHTML;
var xmlDataIslandList = newDivArea.getElementsByTagName("xml");
var islandLoop;
windowData = null;
pkeyData = null;
if (xmlDataIslandList != null)
{
for (islandLoop = 0; islandLoop < xmlDataIslandList.length; islandLoop++)
{
if (window.ActiveXObject)
{
var xmlTempDoc = new ActiveXObject("Microsoft.XMLDOM");
xmlTempDoc.async="false";
xmlDataIsland = xmlDataIslandList[islandLoop];
if (xmlDataIsland != null)
{
xmlTempDoc.loadXML(xmlDataIsland.innerHTML);
}
else
xmlTempDoc = null;
if (xmlTempDoc != null)
{
var dataList = xmlTempDoc.getElementsByTagName(NUWINDOW);
if ((dataList != null) && (dataList.length != 0))
{
windowData = xmlTempDoc;
}
else
{
dataList = xmlTempDoc.getElementsByTagName(PFKEYS_ENTRY);
if ((dataList != null) && (dataList.length != 0))
pkeyData = xmlTempDoc;
}
}
xmlTempDoc = null;
}
else
{
attrLen = 0;
var el = xmlDataIslandList.item(islandLoop);
el.normalize();
if (el.attributes)
{
attrLen = el.attributes.length;
var foundIndex = -1;
for (var attrLoop = 0; ((attrLoop < attrLen) && (foundIndex  == -1)); attrLoop++)
{
if (el.attributes.item(attrLoop).nodeName == "id")
foundIndex = attrLoop;
}
if (foundIndex != -1)
{
if (el.attributes.item(foundIndex).nodeValue == PFKEY_ID)
{
pkeyData = el;
}
else if (el.attributes.item(foundIndex).nodeValue == NUWINDOWID)
{
windowData = el;
}
}
}
}
}
}
xmlDataIsland = null;
newDivArea = removeAllChildren (newDivArea);
newDivArea = null;
return;
}
function buildDivElement(xmlDoc, iWindowID)
{
var winWidth = parseInt(getDocValue(xmlDoc, WINWIDTH));
var winHeight = parseInt(getDocValue(xmlDoc, WINHEIGHT));
var winRow = parseInt(getDocValue(xmlDoc, WINROW));
var winCol = parseInt(getDocValue(xmlDoc, WINCOL));
var winAttrs = parseInt(getDocValue(xmlDoc, WINATTRIBUTES));
if (NCH_AT_WNOVLSCR == (winAttrs & NCH_AT_WNOVLSCR))
winScreenSwitch = "screen";
if (NCH_AT_WNOVLWIN == (winAttrs & NCH_AT_WNOVLWIN))
winScreenSwitch = "window";
if (NCH_AT_WNOVLOFF == (winAttrs & NCH_AT_WNOVLOFF))
winScreenSwitch = "";
var newDiv = document.createElement("div");
var xMax = 100;
var yMax = 100;
var left = (xMax * (winCol - 1)) / iCurrScreenCols;
var top = (yMax * winRow) / iCurrScreenRows;
var width = (xMax * (winWidth + 1)) / iCurrScreenCols;
var height = (yMax * (winHeight + 1)) / iCurrScreenRows;
var newLayerName = DIV_BASE_NAME + iWindowID;
newDiv.setAttribute ("id" ,newLayerName);
newDiv.className = "naturalwindow";
newDiv.setAttribute ("onkeydown","checkKeyPress()");
newDiv.style.position ="absolute";
if (sRTL == "rtl") {
newDiv.style.right = left + "%";
}
else {
newDiv.style.left =  left + "%";
}
newDiv.style.top = top + "%";
newDiv.style.width = width + "%";
newDiv.style.height = height + "%";
newDiv.style.zindex =  iWindowID + 1;
var divScreen = document.getElementById(DIV_SCREEN_NAME);
if (divScreen != null) {
divScreen.appendChild(newDiv);
}
else  {
updateScreenLayout(iCurrScreenCols, iCurrScreenRows);
var divSScreen = document.getElementById(DIV_SCREEN_NAME);
if (divSScreen != null)
divSScreen.appendChild(newDiv);
else
document.body.insertBefore(newDiv, null);
}
divScreen = null;
return newDiv;
}
function disablePrevTopLevelWindow()
{
var prevLayerName = DIV_BASE_NAME + iStoredWindowID;
var oPrevWinDiv = null;
if (iStoredWindowID == 0)
oPrevWinDiv = mainDivArea;
else
oPrevWinDiv = document.getElementById(prevLayerName);
if (oPrevWinDiv != null)
disableTextBoxes(oPrevWinDiv, true);
}
function deletePrevChildWindows(iWindowID)
{
var iWinLoop;
for (iWinLoop = iStoredWindowID; iWinLoop > iWindowID; iWinLoop--)
{
var prevLayerName = DIV_BASE_NAME + iWinLoop;
var prevDiv = document.getElementById(prevLayerName);
if (prevDiv != null) {
if (document.getElementById(DIV_SCREEN_NAME) != null)
{
document.getElementById(DIV_SCREEN_NAME).removeChild(prevDiv);
}
else
{
document.body.removeChild(prevDiv);
}
}
}
var currLayerName = DIV_BASE_NAME + iWindowID;
return document.getElementById(currLayerName);
}
function handleWindowLevel(iWindowID, newHTML)
{
var retObject = null;
if (iWindowID > iStoredWindowID)
{
disablePrevTopLevelWindow();
if (windowData != null)
retObject = buildDivElement(windowData, iWindowID);
else
retObject = mainDivArea;
}
else if (iWindowID < iStoredWindowID)
{
retObject = deletePrevChildWindows(iWindowID);
}
else
{
retObject = activeDivArea;
}
iStoredWindowID = iWindowID;
if (retObject == null)
retObject = mainDivArea;
return retObject;
}
function disableTextBoxes(oHtmlHolder, bDisable)
{
var textboxArray = oHtmlHolder.getElementsByTagName("input");
var iLoop;
for (iLoop = 0; iLoop < textboxArray.length; iLoop++)
{
textbox = textboxArray[iLoop];
if (textbox.type == "text")
{
textbox.disabled = bDisable;
}
}
}
function createBaseDiv(name, top, left, width, height, zIndex)
{
var isNewDiv = true;
var myDiv = document.getElementById(name);
if (myDiv != null)
{
isNewDiv = false;
}
else
{
myDiv = document.createElement("div");
}
var sElementName = "position: absolute; ";
if (name == DIV_SCREEN_NAME)
{
sElementName += "width: " + width + "px; ";
sElementName += "height: " + height + "px; ";
}
else
{
}
sElementName += "z-index:" + zIndex +";";
myDiv.style.cssText = sElementName;
if (isNewDiv)
{
myDiv.setAttribute("id", name);
document.body.insertBefore(myDiv, null);
}
return myDiv;
}
function createCopyIcon ()
{
var copyIcon = document.getElementById("copyIcon");
if (copyIcon!=null) return;
copyIcon = document.createElement("button");
copyIcon.id="copyIcon";
copyIcon.type="button";
copyIcon.title="Switch to copy mode";
copyIcon.setAttribute ('onclick', 'changeCopyMode(event)');
copyIcon.className="ICONImage";
copyIcon.style.display="inline-block";
copyIcon.style.padding="0";
copyIcon.style.border="none";
var copyIconImg = document.getElementById("copyIconImg");
if (copyIconImg!=null) return;
copyIconImg = document.createElement("img");
copyIconImg.id="copyIconImg";
copyIconImg.src="images/copy.gif";;
copyIcon.appendChild (copyIconImg);
document.body.insertBefore(copyIcon, null);
}
function createScreenMessageLine (id)
{
var msgL="MessageLine_".concat(id);
var messageLine=document.getElementById(msgL);
if (messageLine!=null) return;
var mainDiv = document.getElementById(DIV_SCREEN_NAME);
if (mainDiv==null) return;
messageLine=document.createElement("span");
messageLine.id=msgL;
messageLine.className="MessageLine";
messageLine.name="MessageLine";
messageLine.style.top="100%";
messageLine.style.position="absolute";
var appChild = mainDiv.appendChild(messageLine);
}
function setScreenMessageLine (id, msgLine)
{
var msgL="MessageLine_".concat(id);
if (msgLine==null) return;
var messageLine=document.getElementById(msgL);
if (messageLine==null) return;
var res = msgLine.left.substring(0, 6);
if(res==="LEFT: ")
messageLine.style.left=msgLine.left.slice(6);
else if(res==="RIGHT:")
messageLine.style.right=msgLine.left.slice(7);
messageLine.style.top=msgLine.top;
messageLine.style.position=msgLine.position;
messageLine.style.width="100%";
messageLine.classList.add("OutputField");
messageLine.innerText=msgLine.text;
var divScreen = document.getElementById(DIV_SCREEN_NAME);
if (divScreen != null) {
var height=divScreen.clientHeight/iCurrScreenRows;
height=height.toString();
messageLine.style.height=height.concat("px");
}
return true;
}
function getWindowMessageLine (id)
{
var msgL="MessageLine_".concat(id);
var messageLine=document.getElementById(msgL);
if (messageLine==null) return;
var vScreenLeft=messageLine.getAttribute('data-screen-left');
var vScreenTop=messageLine.getAttribute('data-screen-top');
var vScreenPosition=messageLine.getAttribute('data-screen-position');
return {
text: messageLine.innerText,
left: vScreenLeft,
top: vScreenTop,
position: vScreenPosition
};
}
function clearWindowMessageLine (id)
{
var msgL="MessageLine_".concat(id);
var messageLine=document.getElementById(msgL);
if (messageLine==null) return;
messageLine.innerText="";
return true;
}
function calcFontSize()
{
var myBody = document.getElementsByTagName("BODY")[0];
var myDiv = document.createElement("DIV");
var mySpan = document.createElement("SPAN");
myBody.appendChild(myDiv);
myDiv.appendChild(mySpan);
mySpan.innerHTML  = "X";
fontWidth = mySpan.offsetWidth;
fontHeight = mySpan.offsetHeight;
myBody.removeChild(myDiv);
myDiv.removeChild (mySpan);
}
function createPFKeyDiv (calcFont)
{
var leftMain = X_COORD_OFFSET;
if (calcFont)
{
calcFontSize();
}
var top = ((iCurrScreenRows + 2 ) * (fontHeight + 3));
var widthMain = iCurrScreenCols * fontWidth;
var heightMain =((iCurrScreenRows + 1 ) * (fontHeight + 4));
pkeyDivArea = createBaseDiv(DIV_PFKEY_NAME, top, leftMain, widthMain + 30, heightMain + 100);
}
function createBaseScreenLayout()
{
var leftMain = X_COORD_OFFSET;
var topMain =  Y_COORD_OFFSET;
var isNewDiv = true;
var myDiv = document.getElementById(DIV_SCREEN_NAME);
if (myDiv != null)
{
isNewDiv = false;
}
if (isNewDiv){
calcFontSize();
}
var widthMain = iCurrScreenCols * fontWidth;
var heightMain =((iCurrScreenRows + 1 ) * (fontHeight + 4));
mainDivArea = createBaseDiv(DIV_SCREEN_NAME, topMain, leftMain, widthMain, heightMain,1);
createCopyIcon();
if (winScreenSwitch=="screen")
{
createScreenMessageLine("0");
}
activeDivArea = mainDivArea;
createPFKeyDiv(false);
}
function runLoadScript(type, sessionid, subsessionid, doubleClick, showPFKey, displayPfkeys, checkNumFields, autoSkip, modelid)
{
if (type == "rich")
{
isRichClientType = true;
}
session_id = sessionid;
subsession_id = subsessionid;
model_id = modelid;
doubleClickBehavior = doubleClick;
showPFKeyNumbers = showPFKey;
if (checkNumFields == "false")
{
checkNumericFields = new Boolean(false);
}
else
{
checkNumericFields = new Boolean(true);
}
if (autoSkip == "false")
{
autoSkipToNext = new Boolean(false);
}
else
{
autoSkipToNext = new Boolean(true);
}
displayAllPfKeys = parseInt(displayPfkeys);
firstScreen = true;
noCloseMessage = false;
makeAJAXRequest(COMMAND_URL, FIRSTSCREEN, null, true);
}
function handleDoubleClick(szFieldID, elem)
{
handleFocusSwitch(szFieldID, elem);
if (doubleClickBehavior!='disabled')
{
submitKeyPad(doubleClickBehavior);
}
}
function handleFocusSwitch(szFieldID, elem)
{
focusField = szFieldID;
focusElem = elem;
}
String.prototype.translateChars = function(direction)
{
var translateFromCharsArr = document.getElementsByName("_internal_convert_from");
var translateToCharsArr = document.getElementsByName("_internal_convert_to");
var patt;
var id;
var translateFromChars="";
var translateToChars="";
if (translateFromCharsArr.length>0 && translateToCharsArr.length>0)
{
if (direction == true)
{
translateFromChars = translateFromCharsArr.item(0).value;
translateToChars = translateToCharsArr.item(0).value;
}
else
{
translateToChars = translateFromCharsArr.item(0).value;
translateFromChars = translateToCharsArr.item(0).value;
}
if (translateFromChars.length>0 && translateToChars.length>0)
{
patt=new RegExp("[" + translateFromChars + "]","g");
id= translateToChars.split('');
return this.replace(patt, function(w)
{
var idx = translateFromChars.indexOf (w);
return id[+idx];
});
}
}
return this;
};
function saveCaret(elem)
{
var storedCaretPos = 0;
if ((elem != null) && (elem.nodeType == 1))
{
if ((typeof(elem.setSelectionRange))!='undefined')
storedCaretPos = elem.selectionStart;
if (elem.maxLength == storedCaretPos)
storedCaretPos -= 1;
}
else if ((elem != null) && (elem.isTextEdit))
{
elem.caretPos = document.selection.createRange();
storedCaretPos = elem.caretPos;
}
return storedCaretPos;
}
function setCaretPosition(ctrl, pos, select)
{
try
{
if (ctrl==null)
{
var focusObject = document.getElementById("_internal_hiddenfocusset");
if (focusObject!=null)
{
focusObject.focus();
}
}
else if (ctrl.getAttribute('tabindex') == '-1')
{
if (ctrl != null)
{
ctrl.focus();
}
}
else
{
focusElem = ctrl;
focusElem.focus();
if (focusElem.setSelectionRange)
{
focusElem.setSelectionRange(pos,pos);
focusElem.select();
}
}
}
catch (e)
{
}
}
/*
function isOverwriteEnabled() {
try {
return document.queryCommandValue("OverWrite");
} catch (ex) {
return false;
}
}
*/
function left(inStr, nChars)
{
var retStr = "";
if (nChars > 0)
{
if (nChars > String(inStr).length)
retStr = inStr;
else
retStr = String(inStr).substring(0, nChars);
}
return retStr;
}
function right(inStr, nChars)
{
var retStr = "";
if (nChars > 0)
{
var testStr = String(inStr);
if (nChars > testStr.length)
retStr = inStr;
else
{
var iLen = testStr.length;
retStr = testStr.substring(iLen - nChars, iLen);
}
}
return retStr;
}
function setWaitCursor(dowait)
{
var mycursor = "";
var loop;
if (dowait) mycursor= "wait";
if (document.documentElement!=null)
{
document.documentElement.style.cursor = mycursor;
}
if (document.body != null)
{
document.body.style.cursor = mycursor;
}
var payloadNodeList = activeDivArea.getElementsByTagName("input");
for (loop = 0; loop < payloadNodeList.length; loop++)
{
var object = payloadNodeList.item(loop);
if ((object.type == "text") || (object.type == "password"))
{
object.style.cursor = mycursor;
}
}
}
function convertSpecialChars(str)
{
var toChar = new Array ('&#34;','&#38;','&#38;','&#60;','&#62;','&#160;','&#161;','&#162;','&#163;','&#164;','&#165;','&#166;','&#167;','&#168;','&#169;','&#170;','&#171;','&#172;','&#173;','&#174;','&#175;','&#176;','&#177;','&#178;','&#179;','&#180;','&#181;','&#182;','&#183;','&#184;','&#185;','&#186;','&#187;','&#188;','&#189;','&#190;','&#191;','&#192;','&#193;','&#194;','&#195;','&#196;','&#197;','&#198;','&#199;','&#200;','&#201;','&#202;','&#203;','&#204;','&#205;','&#206;','&#207;','&#208;','&#209;','&#210;','&#211;','&#212;','&#213;','&#214;','&#215;','&#216;','&#217;','&#218;','&#219;','&#220;','&#221;','&#222;','&#223;','&#224;','&#225;','&#226;','&#227;','&#228;','&#229;','&#230;','&#231;','&#232;','&#233;','&#234;','&#235;','&#236;','&#237;','&#238;','&#239;','&#240;','&#241;','&#242;','&#243;','&#244;','&#245;','&#246;','&#247;','&#248;','&#249;','&#250;','&#251;','&#252;','&#253;','&#254;','&#255;','&#8364;');
var fromChar = new Array(/&quot;/g,/&amp;/g,/&amp;/g,/&lt;/g,/&gt;/g,/&nbsp;/g,/&iexcl;/g,/&cent;/g,/&pound;/g,/&curren;/g,/&yen;/g,/&brvbar;/g,/&sect;/g,/&uml;/g,/&copy;/g,/&ordf;/g,/&laquo;/g,/&not;/g,/&shy;/g,/&reg;/g,/&macr;/g,/&deg;/g,/&plusmn;/g,/&sup2;/g,/&sup3;/g,/&acute;/g,/&micro;/g,/&para;/g,/&middot;/g,/&cedil;/g,/&sup1;/g,/&ordm;/g,/&raquo;/g,/&frac14;/g,/&frac12;/g,/&frac34;/g,/&iquest;/g,/&Agrave;/g,/&Aacute;/g,/&Acirc;/g,/&Atilde;/g,/&Auml;/g,/&Aring;/g,/&AElig;/g,/&Ccedil;/g,/&Egrave;/g,/&Eacute;/g,/&Ecirc;/g,/&Euml;/g,/&Igrave;/g,/&Iacute;/g,/&Icirc;/g,/&Iuml;/g,/&ETH;/g,/&Ntilde;/g,/&Ograve;/g,/&Oacute;/g,/&Ocirc;/g,/&Otilde;/g,/&Ouml;/g,/&times;/g,/&Oslash;/g,/&Ugrave;/g,/&Uacute;/g,/&Ucirc;/g,/&Uuml;/g,/&Yacute;/g,/&THORN;/g,/&szlig;/g,/&agrave;/g,/&aacute;/g,/&acirc;/g,/&atilde;/g,/&auml;/g,/&aring;/g,/&aelig;/g,/&ccedil;/g,/&egrave;/g,/&eacute;/g,/&ecirc;/g,/&euml;/g,/&igrave;/g,/&iacute;/g,/&icirc;/g,/&iuml;/g,/&eth;/g,/&ntilde;/g,/&ograve;/g,/&oacute;/g,/&ocirc;/g,/&otilde;/g,/&ouml;/g,/&divide;/g,/&oslash;/g,/&ugrave;/g,/&uacute;/g,/&ucirc;/g,/&uuml;/g,/&yacute;/g,/&thorn;/g,/&yuml;/g,/&euro;/g);
for (var i=0; i<fromChar.length; i++)
{
str = str.replace(fromChar[i], toChar[i]);
}
return str;
}
function cancelHelp()
{
preventDefault(window.event);
return false;
}
function changeCopyMode (event){
if (copyMode==false)
setToCopyMode(event);
else
resetCopyMode(event);
}
function setToCopyMode(e){
makeAJAXRequest(COMMAND_URL, "9", null, true);
var myDiv = document.getElementById("copyIcon");
myDiv.title="End the copy mode";
var divImg = document.getElementById("copyIconImg");
divImg.src="images/copyend.gif";
copyMode=true;
}
function resetCopyMode(e){
makeAJAXRequest(COMMAND_URL, "8", null, true);
var myDiv = document.getElementById("copyIcon");
myDiv.title="Switch to copy mode";
var divImg = document.getElementById("copyIconImg");
divImg.src="images/copy.gif";
copyMode=false;
}
window.onkeydown=pfkeyspreventDefault;
