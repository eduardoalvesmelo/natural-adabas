<%@ page language="java" %>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>

<%-- Copyright (c) Software AG, Darmstadt --%>

<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>

<!DOCTYPE html>
<script language=javascript>
window.history.forward(1);
</script>

<html>
  <f:view>
    <f:loadBundle basename="com.softwareag.nwo.conftool.conftool" var="msg"/>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <link rel="stylesheet" type="text/css" href="conf_nwostyle.css"/>
      <title>${msg.confTool}</title>
    </head>

    <body bgcolor="white" >

    <h:form id="loggingConf">
     <h:outputText value="#{msg.loggerConf}" styleClass="TitlePage"/>
     <br/><br/>

         <h:commandButton id="saveConfiguration" value="#{msg.saveConfiguration}" action="saveLogger" actionListener="#{nwoLoggerBean.saveLogger}"
                       title="#{msg.titleSaveConfiguration}" styleClass="submitButtonColor" style="width: 150px"/>
					   <p>
		 <h:message showSummary="true" showDetail="false" infoStyle="display:none" styleClass="showError" for="saveConfiguration"/>
		 <h:message showSummary="true" showDetail="false" errorStyle="display:none" styleClass="showInfo" for="saveConfiguration"/>
					   
      <p><h:outputText value="#{msg.logFileDescription}" styleClass="Title2"/>
        <ul class="Title2">
        <li>"/" : The local pathname separator</li>
        <li>"%t": The system temporary directory </li>
        <li>"%h": The value of the "user.home" system property</li>
        <li>"%g": The generation number to distinguish rotated logs</li>
        <li>"%u": A unique number to resolve conflicts</li>
        <li>"%%": Translates to a single percent sign "%" </li>
        </ul>
      </p>

      <h:panelGrid columns="3">

        <h:outputLabel value="#{msg.logPattern}" styleClass="outputLabel" for="filePattern"/>
        <h:inputText id="filePattern" value="#{nwoLoggerBean.filePattern}" size="50" maxlength="100" styleClass="inputText"
          required="true" title="#{msg.titleLogPattern}">
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="filePattern"/>

        <h:outputLabel value="#{msg.logFormatter}" styleClass="outputLabel" for="fileFormatter"/>
        <h:selectOneMenu id="fileFormatter" value="#{nwoLoggerBean.fileFormatter}"
                            valueChangeListener="#{nwoLoggerBean.changeFileFormatter}" styleClass="inputText"
                            title="#{msg.titleLogFormatter}">
          <f:selectItems value="#{nwoLoggerBean.fileFormatterList}"/>
        </h:selectOneMenu>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.logLimit}" styleClass="outputLabel" for="fileLimit"/>
        <h:inputText id="fileLimit" value="#{nwoLoggerBean.fileLimit}" size="5" maxlength="6" styleClass="inputText"
                     title="#{msg.titleLogLimit}">
          <f:validateLongRange minimum="0"/>
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="fileLimit"/>

        <h:outputLabel value="#{msg.logCount}" styleClass="outputLabel" for="fileCount"/>
        <h:inputText id="fileCount" value="#{nwoLoggerBean.fileCount}" size="5" maxlength="6" styleClass="inputText"
                     title="#{msg.titleLogCount}">
          <f:validateLongRange minimum="1"/>
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="fileCount"/>

        <h:outputLabel value="#{msg.logEnabled}" styleClass="outputLabel" for="fileEnabled"/>
        <h:selectOneRadio id="fileEnabled" value="#{nwoLoggerBean.fileEnabled}" styleClass="inputText"
          title="#{msg.titleLogEnabled}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.logAppend}" styleClass="outputLabel" for="fileAppend"/>
        <h:selectOneRadio id="fileAppend" value="#{nwoLoggerBean.fileAppend}" styleClass="inputText"
          title="#{msg.titleLogAppend}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
      </h:panelGrid>

      <p><h:outputText value="#{msg.logLevelDescription}" styleClass="Title2"/>
        <ul class="Title2">
        <li>SEVERE: Events that interfere with normal program execution</li>
        <li>WARNING: Warnings, including exceptions</li>
        <li>INFO: Messages related to server configuration or server status, excluding errors</li>
        <li>CONFIG: Messages related to server configuration</li>
        <li>FINE: Minimal verbosity</li>
        <li>FINER: Moderate verbosity</li>
        <li>FINEST: Maximum verbosity</li>
        </ul>
      </p>
      <h:panelGrid columns="2">
        <h:outputLabel value="#{msg.logCommunication}" styleClass="outputLabel" for="communication"/>
        <h:selectOneMenu id="communication" value="#{nwoLoggerBean.communication}"
                         valueChangeListener="#{nwoLoggerBean.changeCommunication}" styleClass="inputText"
                         title="#{msg.titleLogCommunication}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>

        <h:outputLabel value="#{msg.logResAdapter}" styleClass="outputLabel" for="resAdapter"/>
        <h:selectOneMenu id="resAdapter" value="#{nwoLoggerBean.resAdapter}"
                         valueChangeListener="#{nwoLoggerBean.changeResAdapter}" styleClass="inputText"
                         title="#{msg.titleLogResAdapter}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>


			  <h:outputLabel value="#{msg.logNatConnect}" styleClass="outputLabel" for="connectModule"/>
        <h:selectOneMenu id="connectModule" value="#{nwoLoggerBean.connectModule}"
                         valueChangeListener="#{nwoLoggerBean.changeConnectModule}" styleClass="inputText"
                         title="#{msg.titleLogNatConnect}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>



        <h:outputLabel value="#{msg.logConfFile}" styleClass="outputLabel" for="confFile"/>
        <h:selectOneMenu id="confFile" value="#{nwoLoggerBean.confFile}"
                         valueChangeListener="#{nwoLoggerBean.changeConfFile}" styleClass="inputText"
                         title="#{msg.titleLogConfFile}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>

        <h:outputLabel value="#{msg.logLogging}" styleClass="outputLabel" for="logging"/>
        <h:selectOneMenu id="logging" value="#{nwoLoggerBean.logging}"
                         valueChangeListener="#{nwoLoggerBean.changeLogging}" styleClass="inputText"
                         title="#{msg.titleLogLogging}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>

        <h:outputLabel value="#{msg.logUtilities}" styleClass="outputLabel" for="utilities"/>
        <h:selectOneMenu id="utilities" value="#{nwoLoggerBean.utilities}"
                         valueChangeListener="#{nwoLoggerBean.changeUtilities}" styleClass="inputText"
                         title="#{msg.titleLogUtilities}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>

        <h:outputLabel value="#{msg.logWebIOPages}" styleClass="outputLabel" for="webIOPages"/>
        <h:selectOneMenu id="webIOPages" value="#{nwoLoggerBean.webIOPages}"
                         valueChangeListener="#{nwoLoggerBean.changeWebIOPages}" styleClass="inputText"
                         title="#{msg.titleLogWebIOPages}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>

        <h:outputLabel value="#{msg.logNJXAdapter}" styleClass="outputLabel" for="njxAdapter"/>
        <h:selectOneMenu id="njxAdapter" value="#{nwoLoggerBean.njxAdapter}"
                         valueChangeListener="#{nwoLoggerBean.changeNjxAdapter}" styleClass="inputText"
                         title="#{msg.titleLogNJXAdapter}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>

        <h:outputLabel value="#{msg.logNJXSDOGraph}" styleClass="outputLabel" for="njxSDOGraph"/>
        <h:selectOneMenu id="njxSDOGraph" value="#{nwoLoggerBean.njxSDOGraph}"
                         valueChangeListener="#{nwoLoggerBean.changeNjxSDOGraph}" styleClass="inputText"
                         title="#{msg.titleLogNJXSDOGraph}">
          <f:selectItems value="#{nwoLoggerBean.levelList}"/>
        </h:selectOneMenu>

      </h:panelGrid>

      <br/><br/>

    </h:form>

    </body>
  </f:view>
</html>
