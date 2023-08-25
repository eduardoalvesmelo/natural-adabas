<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%-- Copyright (c) Software AG, Darmstadt --%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Natural for AJAX Configuration Tool</title>
    </head>
    <frameset rows="105,*" frameborder=no>
      <frame src="conf_topFrame.jsp" name="topframe" scrolling="no" noresize/>
      <frameset cols="300,*" onResize="if (navigator.family == 'nn4') window.location.reload()" frameborder=yes>
        <frame src="faces/conf_leftFrame.jsp" name="treeframe"/>
        <frame src="faces/conf_rightFrame.jsp" name="basefrm"/>
      </frameset>
    </frameset>
</html>
