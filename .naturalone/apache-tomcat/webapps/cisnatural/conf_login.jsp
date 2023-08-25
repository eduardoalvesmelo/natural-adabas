<%@ page language="java"%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>

<%-- Copyright (c) Software AG, Darmstadt --%>

<!DOCTYPE html>

<script language=javascript>
window.history.forward(1);
</script>
<HTML>
<HEAD>
<TITLE>Logon to Natural for Ajax</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="conf_nwostyle.css" type=text/css rel=stylesheet>
</HEAD>
<BODY leftMargin=0 topMargin=0
onload="javascript: document.forms[0].j_username.focus();return true;"
marginheight="0" marginwidth="0">
<FORM name=loginform action=j_security_check method=post>
<TABLE title="" cellSpacing=0 cellPadding=0 align=center border=0>
  <TBODY>

  <TR>
    <TD></TD>
    <TD vAlign=center noWrap></TD>
    <TD>&nbsp;</TD></TR>
  <TR>
    <TD>&nbsp;</TD>
    <TD style="BACKGROUND-POSITION: left top; BACKGROUND-IMAGE: url(images/login-backimage.jpg); BACKGROUND-REPEAT: no-repeat"
    vAlign=center align=middle height=435>
      <TABLE title="" cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width=300><IMG height=245 alt="" src="images/dot.gif"
            width=260></TD>
          <TD vAlign=top align=left width=415 bgColor=#ffffff>
          	<H3 style="white-space:nowrap;color: #038299; font-size: 20px; font-family: Verdana">Natural for Ajax Logon</H3>
            <TABLE cellSpacing=0 cellPadding=0 border=0>
              <TBODY>
<%
              String showError = request.getParameter ("showError");
              if (showError != null && showError.equals("true")) {
			            String errMsg ="Logon failed";
                  Object jExcep = session.getAttribute("j_exception");
			            if (jExcep != null){
			                errMsg = jExcep.toString();
			            }
%>
              <TR>
                <TD colSpan=2>
                  <DIV class=logErr>
                  <TABLE class=AlrtTbl title="" cellSpacing=0 cellPadding=0
                  align=center border=0>
                    <TBODY>
                    <TR>
                      <TD vAlign=center>
                      	<div if="${errMsg != null}" width="100%" style="color:red"><%=errMsg %></div>

                        <DIV class=AlrtErrTxt><IMG height=21 alt=Error
                        src="images/error_large.gif" width=21>
                        Authentication Failed </DIV>
                        <DIV class=AlrtMsgTxt>Re-enter your user name and
                        password. </DIV></TD></TR></TBODY></TABLE></DIV></TD></TR>

<%}%>
              <TR>
                <TD noWrap>
                  <DIV>&nbsp;<SPAN class=LblLev2Txt> <LABEL for=username>User name: </LABEL></SPAN></DIV></TD>
                <TD>
                  <DIV><INPUT id=username tabIndex=1 name=j_username></DIV></TD></TR>
              <TR>
                <TD noWrap>
                  <DIV>&nbsp;<SPAN class=LblLev2Txt> <LABEL for=password>Password: </LABEL></SPAN></DIV></TD>
                <TD>
                  <DIV><INPUT id=password tabIndex=2
                  type=password name=j_password></DIV></TD></TR>
              <TR>
                <TD></TD>
                <TD><SPAN id=loginEnable>
                  <TABLE border=0>
                    <TBODY>
                    <TR>
                      <TD>
                        <DIV>
                        <DIV><INPUT class=submitButtonColor id=loginButton onclick="this.form.submit(); return false;" tabIndex=3 type=submit value="Log In" name=loginButton>
                        </DIV></DIV></TD></TR></TBODY></TABLE></SPAN>
                      </TD></TR>
              <TR>
                <TD>&nbsp;</TD></TR>
              <TR>
                <TD></TD>
                <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD>&nbsp;</TD></TR>
  <TR>
    <TD>&nbsp;</TD>
    <TD>
      <DIV><SPAN>Copyright © Software AG 2008-2018. All rights reserved. </SPAN>
      </DIV></TD>
    <TD>&nbsp;</TD>
  </TR>
  </TBODY>
</TABLE>
</FORM>
</BODY>
</HTML>
