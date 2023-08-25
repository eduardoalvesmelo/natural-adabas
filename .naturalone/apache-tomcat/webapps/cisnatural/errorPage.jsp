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
        <title>Natural Web/IO Error Occurred</title>
    </head>
    <body style="background-color: white;">
    <img border="0" src="images/sag_logo.png" align="right">
    <img border="0" src="images/logonimage.jpg" height="103">
    <div align="right" style="font-family:'Times New Roman',Times,serif; font-size:70%">
    Natural Web I/O Interface client for Java EE servers.
    </div>
    <hr/>
    <br/>
    <br/>
    <h4>The following error has been reported</h4>
    <br/>
    <hr/>
<%
    // No cache settings
    response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

    HttpSession mySession = request.getSession();
    String errorMess = (String)mySession.getAttribute("ERRORMESSAGE");
    if ((errorMess != null) && (errorMess.length() > 0))
        out.println(mySession.getAttribute("ERRORMESSAGE"));
    else
        out.println("No specific error has been received");
    mySession.setAttribute("ERRORMESSAGE", null);
%>
    <hr/>
    <br/>
    <br/>
    <a href="natural.jsp" tabindex="1">Return to the logon page</a>
    <div style="font-family:'Times New Roman',Times,serif; font-size:70%; position:absolute; bottom:0px; right:0px;">
    Copyright &copy; 2005-2018 Software AG - All rights reserved</div>
    </body>
</html>
