<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

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
        <title>Natural Web I/O Host Disconnected</title>
    </head>
    <body>
    <img border="0" src="images/sag_logo.png" align="right">
    <img border="0" src="images/logonimage.jpg" height="103">
    <div align="right" style="font-family:'Times New Roman',Times,serif; font-size:70%">
    Natural Web I/O Interface client for Java EE servers.</div>
    <hr/>
    <br/>
    <br/>
    <h4>The host session has been disconnected</h4>
    <br/>
    <br/>
    <hr/>
<%
    // No cache settings
    response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

    HttpSession mySession = request.getSession();
    String sMessage = null;
    if (mySession.getAttribute("DISCONNECT_MESSAGE") != null)
        sMessage = (String)mySession.getAttribute("DISCONNECT_MESSAGE");
    if ((sMessage == null) || (sMessage.length() == 0))
        sMessage = "Connection to host was closed";
    out.println(sMessage);
    if (mySession.getAttribute("DISCONNECT_CODE") != null){
        Integer errCode = (Integer)mySession.getAttribute("DISCONNECT_CODE");
        if (errCode.intValue() != 0){
            out.print("<hr/>Error code <code><b>");
            out.print(errCode);
            out.println("</b></code> was received from Natural");
        }
    }

    // Clear old messages
    mySession.setAttribute("DISCONNECT_MESSAGE", null);
    mySession.setAttribute("DISCONNECT_CODE", null);
%>
    <hr/>
    <br/>
    <br/>
    <a href="natural.jsp" tabindex="1">Return to the logon page</a>
<div style="font-family:'Times New Roman',Times,serif; font-size:70%; position:absolute; bottom:0px; right:0px;">
Copyright &copy; 2005-2018 Software AG - All rights reserved</div>
    </body>
</html>
