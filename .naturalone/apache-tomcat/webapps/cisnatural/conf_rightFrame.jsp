<%@ page language="java"%>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>

<%-- Copyright (c) Software AG, Darmstadt --%>

<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>

<!DOCTYPE html>
<html>
  <f:view>
    <f:loadBundle basename="com.softwareag.nwo.conftool.conftool" var="msg"/>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

  <link rel="stylesheet" type="text/css" href="conf_nwostyle.css"/>
  <title>${msg.confTool}</title>
</head>
<body>
<table width="100%">
<tbody>
  <tr>
    <td width="5%"></td>
    <td width="90%">
      <table width="100%">
      <tboby>
	<tr>
        <td height=10 class=WelBoxl><span class=WelT1>Configuration Tool Management</span></td>
	</tr>
        <tr height=10></tr>
        <tr>
          <td class=WelBox2><span class=WelT2Bold>Session Configuration</span></td>
        </tr>
        <tr>
          <td class=WelBox3><span class=WelT3>Show the sessions already defined. You are able to manage any session or create a new one.</span></td>
        </tr>
        <tr height=10></tr>
        <tr>
          <td class=WelBox2><span class=WelT2Bold>Logging Configuration</span></td>
        </tr>
        <tr>
          <td class=WelBox3><span class=WelT3>Manage the logging configuration. Define the log levels for the different modules.</span></td>
        </tr>
        <tr height=10></tr>
        <tr>
          <td class=WelBox2><span class=WelT2Bold>Natural Web I/O Interface Client Logon</span></td>
        </tr>
        <tr>
          <td class=WelBox3><span class=WelT3>Connect to a Natural Web I/O Interface server, using a Natural Web I/O Interface client logon page.</span></td>
        </tr>
        <tr>
        <tr height=10></tr>
        <tr>
          <td class=WelBox2><span class=WelT2Bold>Natural for Ajax Logon</span></td>
        </tr>
        <tr>
          <td class=WelBox3><span class=Title3>Connect to a Natural Web I/O Interface server, using a Natural for Ajax logon page.</span></td>
        </tr>
        <tr height=10></tr>
        <tr>
          <td class=WelBox2><span class=WelT2Bold>Logout</span></td>
        </tr>
        <tr>
          <td class=WelBox3><span class=WelT3>Close the current configuration tool session.</span></td>
        </tr>
      </tbody>
      </table>
    </td>
    <td width="5%"></td>
  </tr>
  <tr height=20>
    <td width="5%"></td>
    <td width="90%"></td>
    <td width="5%"></td>
  </tr>
  <tr>
    <td width="5%"></td>
    <td width="90%">
      <table>
      <tboby>
        <tr>
          <td height=10 class=WelBoxl><span class=WelT1>Natural Online Resources</span></td>
        </tr>
        <tr height=10></tr>
        <tr>
          <td class=WelBox2><span class=WelT2Bold>Natural Information</span></td>
        </tr>
        <tr>
          <td class=WelBox3><span class=WelT3>
          Use the most productive development environment in the market to deliver new applications faster.</span>
          <a class=WelT3 href="http://www.softwareag.com/natural">Visit the Natural pages.</a>
          </td>
        </tr>
        <tr height=10></tr>
        <tr>
          <td class=WelBox2><span class=WelT2Bold>Developer Community</span></td>
        </tr>
        <tr>
          <td class=WelBox3><span class=WelT3>Stay connected with your peers - developers, consultants, integrators and business
             analysts from around the world - by joining the Adabas and Natural Developer Network.</span>
          <a class=WelT3 href="http://communities.softwareag.com">Visit the Developer Community pages.</a>
          </td>
        </tr>
      </tbody>
      </table>
    </td>
    <td width="5%"></td>
  </tr>
</tbody>
</table>
</body>
</f:view>
</html>



