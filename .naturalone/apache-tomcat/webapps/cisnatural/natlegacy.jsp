<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.lang.System.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.rmi.PortableRemoteObject"%>
<%@page import="java.rmi.RemoteException"%>
<%@page import="javax.servlet.jsp.*"%>
<%@page import="com.softwareag.natural.unicode.config.BuildRevision"%>
<%@page isThreadSafe="false" %>

<%-- Copyright (c) Software AG, Darmstadt --%>

<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
--%>
<%
    HttpSession mySession = request.getSession();

    // Set caller as richgui
    mySession.setAttribute("caller", "richgui");
%>

<%
    // Get style sheet name
    String styleSheet = request.getParameter("styleSheet");

    // Get session id from CISNatAdapter and set it for the servlet
    String cisID = request.getParameter ("sessionid");
    mySession.setAttribute("sessionid", cisID);

    String cissubID = request.getParameter ("subsessionid");
	String cisModelID = request.getParameter ("modelid");
    String doubleClickBehavior = request.getParameter("doubleClickBehavior");
    String pfKeysDisplay = request.getParameter("pfkeysdisplay");
    String showPFKeyNumbers = request.getParameter("showPFKeyNumbers");
    String checkNumFields = request.getParameter("checknumfields");
    String autoSkip = request.getParameter("autoskip");

    if (showPFKeyNumbers==null)
        showPFKeyNumbers="false";


%>
	<!DOCTYPE html>
    <html>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1'>
        <title>Natural Session</title>

<%
    // No cache settings
    response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>

<%
    ServletContext context = getServletContext();
    BuildRevision buildRev = new BuildRevision(context);
    String revision = "343";
    if (buildRev.getRevisionText()!=null)
	    revision = buildRev.getRevisionText();
%>


            <script src="scripts/natunicscript.js?version=<%=revision %>" ></script>
            <link rel="stylesheet" href="<%=styleSheet%>" type="text/css" ></link>
            <link rel="stylesheet" href="resources/tmodels/model2.css" type="text/css" ></link>
         	<link rel="stylesheet" href="resources/tmodels/model3.css" type="text/css" ></link>
            <link rel="stylesheet" href="resources/tmodels/model4.css" type="text/css" ></link>
            <link rel="stylesheet" href="resources/tmodels/model5.css" type="text/css" ></link>
            <link rel="stylesheet" media="print" href="resources/nwoprint.css" type="text/css"></link>
    </head>
    <body onload="runLoadScript('rich','<%=cisID %>','<%=cissubID %>','<%=doubleClickBehavior %>','<%=showPFKeyNumbers %>', '<%=pfKeysDisplay %>', '<%=checkNumFields %>', '<%=autoSkip %>','<%=cisModelID %>');" onkeyup="checkKeyUp(event)"; onkeypress="return isNumeric(event)";  onkeydown="checkKeyPress(event);" onhelp="cancelHelp();" onbeforeunload="handleDisconnect();" >


    </body>
</html>

