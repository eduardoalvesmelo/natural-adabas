<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.softwareag.natural.unicode.web.*"%>
<%@page import="com.softwareag.natural.unicode.config.*"%>
<%@page import="com.softwareag.natural.unicode.config.BuildRevision"%>
<%@page import="com.softwareag.natural.unicode.config.StyleSheetData"%>
<%@page import="java.util.ArrayList"%>

<%-- Copyright (c) Software AG, Darmstadt --%>

<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
--%>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <title>Natural Web I/O Session</title>
</head>

<script language="javascript">

<%
        String browser = request.getHeader("User-Agent");
//        if(browser.indexOf("MSIE") < 0) {
%>
<%
//    window.captureEvents(Event.KEYDOWN);
//    window.onkeydown=checkForEnter;
%>
<%;
//        }
%>
function fireSelectChange(selIndex){
    document.logonForm.activationValue.value = "2";
    document.logonForm.submit();
}


function fireSetPassword(){
    document.logonForm.activationValue.value = "3";
    document.logonForm.submit();
}
function fireConnect(){

    var okToConnect = true;
    if (document.logonForm.newPassword != null){

        // Value must be the same
        okToConnect = false;
        if (document.logonForm.newPassword.value != document.logonForm.newPassword2.value)
            alert("New passwords must match");
        else
            okToConnect = true;
    }
    if (okToConnect){
        document.logonForm.activationValue.value = "1";
        document.logonForm.submit();
    }
}

function checkForEnter(event){
<%
        if(browser.indexOf("MSIE") >= 0)
            out.println("var currKey = window.event.keyCode;");
        else
            out.println("var currKey = event.which;");
%>
        if (currKey == 13){
            fireConnect();
        }
}

function handleLoad(){
  connectionList = document.getElementsByName("connectionval");
  if ((connectionList != null) && (connectionList.length > 0))
    connectionList[0].focus ();
}

function cUpper(cObj)
{
  cObj.value=cObj.value.toUpperCase();
}


function checkNatChars(cObj)
{
  var myval = cObj.value;
  var bOK = true;
  for (i=0; i< myval.length;i++)
  {
     // Check if character is between A-Z
     if ((myval.charCodeAt(i) < 65) || (myval.charCodeAt(i)> 90))
     {
       // Check if character is between 0-9
       if ((myval.charCodeAt(i) < 48) || (myval.charCodeAt(i)> 57))
       {
         // Check if character is - or _
         if ((myval.charCodeAt(i) != 95) && (myval.charCodeAt(i)!= 45))
         {
           bOK = false ;
           break;
         }
       }
     }
  }
  if (!bOK)
  {
  	alert ("For the user name only the following characters are allowed: A-Z,0-9,_,-");
  	cObj.focus();
  }
}

</script>

<%
        browser = request.getHeader("User-Agent");
        if(browser.indexOf("MSIE") >= 0) {
%>
            <body onkeydown="checkForEnter()" onload="handleLoad()">
<%
        }
        else
        {
%>
            <body onkeydown="checkForEnter(event, this)" onload="handleLoad()">
<%
        }
%>
<img border="0" src="images/sag_logo.png" align="right">
<img border="0" src="images/logonimage.jpg" height="103">
<div align="right" style="font-family:'Times New Roman',Times,serif; font-size:70%">
<%
    out.print (VersionInfo.NWO_VERSION);
%>
<%
    ServletContext context = getServletContext();
    BuildRevision buildRev = new BuildRevision(context);
    String revision = buildRev.getRevisionText();
    if ((revision != null)&&(revision.length () > 0))
    {
        out.print ("Build: " + revision);
    }
%>

</div>
<hr/><h4>Enter connection details:</h4>
<form method="POST" action="natural.jsp" name="logonForm">
<input type="hidden" name="activationValue" value="0"/>
<input type="hidden" name="styleSheetIndex" value="0"/>

<jsp:useBean id="logonDetails" class="com.softwareag.natural.unicode.web.StoredData" scope="session"/>
<jsp:setProperty name="logonDetails" property="*"/>

<%
    // No cache settings
    response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

    // Position values
    int topPos = 210;
    int topInc = 40;

    // Get the singleton session information
    HttpSession mySession = request.getSession();
    NUSessionDetails nuSessionDetails = new NUSessionDetails(context);
    nuSessionDetails.createSessionDetails();

    StyleSheetData styleSheetData = new StyleSheetData(context);

    // Clear any possible old values
    mySession.setAttribute("DISCONNECT_MESSAGE", null);
    mySession.setAttribute("DISCONNECT_CODE", null);
    mySession.setAttribute("caller", "webio");

    int iNumEntries = nuSessionDetails.getSessionArraySize();
    Boolean bShowSetPassword = Boolean.FALSE;
    int iUseSession = logonDetails.getConnectionID();

    boolean unknownSess = false;
    String sessionID = request.getParameter ("natsession");
    String natserver = request.getParameter("natserver");
   /* if (natserver != null)
    {
    	%><jsp:setProperty name="logonDetails" property="serverAddress" value='<%=request.getParameter("natserver") %>' /><%
    }    */
    String natport = request.getParameter("natport");
  /*  if (natport != null)
    {
    	%><jsp:setProperty name="logonDetails" property="serverPort" value='<%=request.getParameter("natport") %>' /><%
    }     */
    String natuser = request.getParameter("natuser");
   /* if (natuser != null)
    {
        UserData userDetails  = nuSessionDetails.getUserArrayEntryByName(natuser);
        if (userDetails != null)
        {
            String userPassword = userDetails.getPassword();
	    %><jsp:setProperty name="logonDetails" property="password" value='<%=userDetails.getPassword() %>' /><%
        }
	%><jsp:setProperty name="logonDetails" property="username" value='<%=request.getParameter("natuser") %>' /><%
    }*/
    String natparam = request.getParameter("natparam");
 /*   if (natparam != null)
    {
    	%><jsp:setProperty name="logonDetails" property="parameters" value='<%=request.getParameter("natparam") %>' /><%
    }       */
    String natprog = request.getParameter("natprog");
 /*   if (natprog != null)
    {
    	%><jsp:setProperty name="logonDetails" property="natapp" value='<%=request.getParameter("natprog") %>' /><%
    } */

    if (sessionID != null)
    {
    	SessionData activeSessionDetails = nuSessionDetails.getSessionArrayEntryByName(sessionID);
    	if (activeSessionDetails != null)
    	{
            for (int iLoop = 0; iLoop < iNumEntries; iLoop++){
                SessionData mySessionDetails = nuSessionDetails.getSessionArrayEntry(iLoop);
                if (mySessionDetails.getSessionName().equals(activeSessionDetails.getSessionName()))
                {
                    iUseSession = iLoop;
                    logonDetails.setConnectionval(iUseSession);
                }
            }

            logonDetails.setActivationValue(1);
            logonDetails.setClientID("Client");

    	}
    }

    else
    {
    	if ( (natuser!=null) || (natserver!=null) || (natport !=null) || (natparam!=null)|| (natprog!=null))
    	{
    	  logonDetails.setConnectionval(-1);
    	  iUseSession = -1;
    	  unknownSess = true;
    	}
    }


    if ( (natuser!=null) && (natserver!=null) && (natport !=null))
    {
    	logonDetails.setActivationValue(1);
    	logonDetails.setClientID("Client");
    }

    if (mySession.getAttribute("SETPASSWORD") != null)
        bShowSetPassword = (Boolean)mySession.getAttribute("SETPASSWORD");

    // Check on the action to take:
    switch (logonDetails.getActivationValue()){
        case 1:
            // Simply connection, forward to the connection page
            logonDetails.setActivationValue(0);
            mySession.setAttribute("SETPASSWORD", null);
%>
  <jsp:forward page="naturalsession">
  <jsp:param name="redirect" value="<%=request.getRequestURI()%>" />
  </jsp:forward>

<%
        break;
        case 2:
        break;
        case 3:
            // Check current status
            bShowSetPassword = Boolean.valueOf(!(bShowSetPassword.booleanValue()));
            mySession.setAttribute("SETPASSWORD", bShowSetPassword);
        break;

    }

    SessionData activeSessionDetails = null;
    if (iUseSession >= 0)
    {
        // Pick off the default entry
        activeSessionDetails = nuSessionDetails.getSessionArrayEntry(iUseSession);
    }
    if (activeSessionDetails == null){
        activeSessionDetails = new SessionData();
    }
%>

<%    if (!unknownSess){
%>
<!--        First output the session list -->
        <span style="position: absolute; left:74px; top:<%out.print(topPos);%>px">Session ID:</span>
	<select size="1" name="connectionval" onchange="javascript:fireSelectChange(value)" style="position: absolute; left:244px; width: 300px; top:<%out.print(topPos);%>px; width:255x">
<%

    for (int iLoop = 0; iLoop < iNumEntries; iLoop++){
        SessionData mySessionDetails = nuSessionDetails.getSessionArrayEntry(iLoop);
%>
        <option <%out.print("value='"+iLoop+"'"); if (iUseSession == iLoop) out.print(" selected='true'");%>><%out.print(mySessionDetails.getSessionName());%></option>
<%
        }
%>
	</select>

<%    }%>
      <input type="Button" ID="Login" value="Connect" style="position: absolute; left:564px; width:128px; top:<%out.print(topPos);%>px" onclick="fireConnect()">
<%         if (activeSessionDetails.getUseStoredUser() == false)
{
           if (bShowSetPassword.booleanValue()){
%>
            <input type="Button" value="Don't change password" style="position: absolute; left:728px;width:140px; top:<%out.print(topPos);%>px;" onclick="fireSetPassword()" >
<%

}else{
%>
            <input type="Button" value="Change password" style="position: absolute; left:728px;width:140px; top:<%out.print(topPos);%>px;" onclick="fireSetPassword()" >
<%
}
}%>
</p>
<%      topPos+= topInc;%>
<% if (activeSessionDetails.getUseServerDetails() == false){%>
<% if (natserver == null){%>
	<span id="NatServerLabel" style="position: absolute; left:74px; top:<%out.print(topPos);%>px">Host name:</span>
	<input type="text" ID="NatServer" name="serverAddress" value='<jsp:getProperty name="logonDetails" property="serverAddress"/>' size="40" style="position: absolute; left:244px; top:<%out.print(topPos);%>px"></p>
<%      topPos+= topInc;%>
<%    }
%>
<% if (natport == null){%>
	<span id="NatPortLabel" style="position: absolute; left:74px; top:<%out.print(topPos);%>px">Port number: </span>
	<input type="text" ID="NatPort" name="serverPort" value='<jsp:getProperty name="logonDetails" property="serverPort"/>' maxlength="5" size="12" style="position: absolute; left:244px; top:<%out.print(topPos);%>px"></p>
<%
      topPos+= topInc;
}%>
<%    } %>
<%    if (activeSessionDetails.getUseStoredUser() == false){%>
<% if (natuser == null){%>
	<span id="UserNameLabel" style="position: absolute; left:74px; top:<%out.print(topPos);%>px">User name: </span>
        <input type="text" id="UserName" name="username" value='<jsp:getProperty name="logonDetails" property="username"/>' style="position: absolute; left:244px; top:<%out.print(topPos);%>px"
<% if (activeSessionDetails.isUserUppercase()){ %>
        onkeyup="cUpper(this);"
<% }%>
<% if (activeSessionDetails.isSessionTypeMF()){ %>
	size="12" maxlength="8"></p>
<% }else if (activeSessionDetails.isSessionTypeMF_NSC()){ %>
	onkeyup="cUpper(this);" onBlur="checkNatChars(this)" size="12" maxlength="8"></p>
<% }else{ %>
	size="40" maxlength="32"></p>
<% }%>
<%      topPos+= topInc;%>
	<span id="PasswordLabel" style="position: absolute; left:74px; top:<%out.print(topPos);%>px">Password: </span>
	<input id="Password" type="password" name="password" style="position: absolute; left:244px; width: 300px; top:<%out.print(topPos);%>px"
<% if ((activeSessionDetails.isSessionTypeMF()) || (activeSessionDetails.isSessionTypeMF_NSC() )){ %>
	size="12" maxlength="8"></p>
<% }else{ %>
	size="40" maxlength="32"></p>
<% }%>
<%
      topPos+= topInc;
}%>
<%    } %>
<%    if (activeSessionDetails.getUseNaturalApp() == false){%>
	<span id="NatProgLabel" style="position: absolute; left:70px; top:<%out.print(topPos);%>px">Application: </span>
	<input id="NatProg" type="text" name="natapp" value='<jsp:getProperty name="logonDetails" property="natapp"/>' size="40" style="position: absolute; left:244px; top:<%out.print(topPos);%>px"></p>
<%
      topPos+= topInc;
}%>
<%    if (activeSessionDetails.getUseParameters() == false){%>
	<span id="NatParamLabel" style="position: absolute; left:70px; top:<%out.print(topPos);%>px">Natural parameters: </span>
	<input id="NatParam" type="text" name="parameters" value='<jsp:getProperty name="logonDetails" property="parameters" />' size="40" style="position: absolute; left:244px; top:<%out.print(topPos);%>px"></p>
<%
      topPos+= topInc;
}%>

<!--%    if (activeSessionDetails.getUseCustomInfo() == false){%>
	<span style="position: absolute; left:70px; top:<%out.print(topPos);%>px">Custom Info </span>
	<input type="text" name="customInfo" size="40" style="position: absolute; left:244px; top:<%out.print(topPos);%>px"></p-->
<%
      //topPos+= topInc;
//}%>
	<input type="hidden" name="clientID" value="ClientID">
        <!--input type="hidden" name="newPassword" value=""-->
<%    if (activeSessionDetails.getUseStoredUser() == false){%>
<!--input type="Button" value="Connect" style="position: absolute; left:264px; top:<%out.print(topPos);%>px" onclick="fireConnect()"-->
<%
        if (bShowSetPassword.booleanValue()){

      topPos+= topInc;
%>
            <span id="NewPasswordLabel" style="position: absolute; left:70px; top:<%out.print(topPos);%>px">New password: </span>
            <input id="NewPassword" type="password" name="newPassword" style="position: absolute; left:244px; width: 300px; top:<%out.print(topPos);%>px"
<% if ((activeSessionDetails.isSessionTypeMF()) || (activeSessionDetails.isSessionTypeMF_NSC() )){ %>
	size="12" maxlength="8"></p>
<% }else{ %>
	size="40" maxlength="32"></p>
<% }%>
<%
      topPos+= topInc;
%>
            <span id="NewPassword2Label" style="position: absolute; left:70px; top:<%out.print(topPos);%>px">Repeat new password:</span>
            <input id="NewPassword2" type="password" name="newPassword2" style="position: absolute; left:244px; width: 300px; top:<%out.print(topPos);%>px"
<% if ((activeSessionDetails.isSessionTypeMF()) || (activeSessionDetails.isSessionTypeMF_NSC() )){ %>
	size="12" maxlength="8"></p>
<% }else{ %>
	size="40" maxlength="32"></p>
<% }%>
<%
      topPos+= topInc;
%>
<%
        }
        else
        {
            logonDetails.setNewPassword("");
        }
%>
<%
        }
        else{
%>
<!--input type="Button" name="connectButton" value="Connect" style="position: absolute; left:264px; top:<%out.print(topPos);%>px" onclick="fireConnect()"-->
<%}%>


</form>

</p>
</p>
<div style="font-family:'Times New Roman',Times,serif; font-size:70%; position:absolute; bottom:0px; right:0px;">
Copyright &copy; 2005-2018 Software AG - All rights reserved</div>
</body>
</html>
