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
    </head>  
    <body>
      <h:form id="leftFrame" >
        <table width="100%" height="600" class="tableWhite" cellSpacing="0" cellPadding="0" border="0" ID="Table1">
        <tbody>
          <tr>
            <td width="100%" height="100%">
              <table width="100%" height="100%" ID="Table2">
              <tbody>
                <tr>
                  <td class="vtDataTD1" valign=top>
                    <table cellSpacing="0" cellPadding="0" width="100%" height="100%" border="0" ID="Table3">
                    <tbody>
                      <tr><td valign=middle height="20">
                        <h:outputLink id="home" value="conf_rightFrame.jsp" target="basefrm" styleClass="outputText">
                          <f:verbatim>Home</f:verbatim>
                        </h:outputLink>                      
                      </td></tr>
                      <tr><td valign=middle height="20">
                        <h:outputLink id="listSessions" value="conf_listSessions.jsp" target="basefrm" styleClass="outputText">
                          <f:verbatim>Session Configuration</f:verbatim>
                        </h:outputLink>                      
                      </td></tr>
                      <tr><td valign=middle height="20">
                        <h:outputLink id="loggingConf" value="conf_loggerconf.jsp" target="basefrm" styleClass="outputText">
                          <f:verbatim>Logging Configuration</f:verbatim>
                        </h:outputLink>                      
                      </td></tr>
                      <tr>
                      <td valign=middle height="20">
                        <h:outputLink id="natwebio" value="#{facesContext.externalContext.context.contextPath}/natural.jsp" target="basefrm" styleClass="outputText">
                          <f:verbatim>Natural Web I/O Interface Logon</f:verbatim>
                        </h:outputLink>                      
                      </td>
                      </tr>
                      <tr>
                      <td valign=middle height="20">
                        <h:outputLink id="natajax" value="#{facesContext.externalContext.context.contextPath}/servlet/StartCISPage?PAGEURL=/cisnatural/NatLogon.html" target="basefrm" styleClass="outputText">
                          <f:verbatim>Natural for Ajax Logon</f:verbatim>
                        </h:outputLink>                      
                      </td>
                      </tr>
                      <tr>
                      <td valign=middle height="20">
                        <h:commandLink id="logout" action="logout" actionListener="#{nwoSettings.logoutSession}" target="_top" styleClass="outputText"> 
                          <f:verbatim>Logout</f:verbatim>
                        </h:commandLink>
                      </td>
                      </tr>
                    </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
              </table>
            </td>
          </tr>
        </tbody>
        </table>
      </h:form>
    </body>
  </f:view>
</html>
