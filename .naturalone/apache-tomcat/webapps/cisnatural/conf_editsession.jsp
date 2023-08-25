<%@ page language="java" %>
<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>

<%-- Copyright (c) Software AG, Darmstadt --%>

<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<script language=javascript>
window.history.forward(1);

function convertToUpperCase(source)
{
  var ucase = document.forms['editSession'].elements['editSession:ucase'];
  if (ucase.checked)
  {
    var userId = document.getElementById("editSession:userId");
    userId.value = userId.value.toUpperCase();
  }
}

function checkType(source)
{
  var chosenCols = document.getElementById('editSession:type');
  if (chosenCols.options[chosenCols.selectedIndex].value == "MF-NSC")
  {
    var radio = document.forms['editSession'].elements['editSession:ucase'];
    radio[0].checked = true;
    convertToUpperCase(source);
  }
}

function setServerCreds(source) {
	var javaEEAuthentication = document.getElementById("editSession:javaEEAuth");
	var serverCredentials = document.getElementById("editSession:serverCredentials");
	if (javaEEAuthentication.checked==true){
	  serverCredentials.checked = true;
	  serverCredentials.disabled = true;
	  disableUserInput(source);
	}
	else {
		serverCredentials.disabled = false;
	}
}


function disableUserInput (source) {
	var serverCredentials = document.getElementById("editSession:serverCredentials");
	var userID = document.getElementById('editSession:userId');
	var userIDText = document.getElementById('editSession:userIdText');
	var pwd = document.getElementById('editSession:pwd');
	var checked = serverCredentials.checked;

 	userID.disabled = checked;
 	userIDText.disabled = checked;
 	pwd.disabled = checked;
}

</script>

<html>
  <f:view>
    <f:loadBundle basename="com.softwareag.nwo.conftool.conftool" var="msg"/>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <link rel="stylesheet" type="text/css" href="conf_nwostyle.css"/>
      <title>${msg.confTool}</title>
    </head>

    <body bgcolor="white" onload="checkType(this); disableUserInput(this); setServerCreds(this)">

    <h:form id="editSession">
      <h:inputHidden id="idNumber" value="#{nwoSessionBean.idNumber}"/>

     <h:outputText styleClass="TitlePage" value="#{msg.defSession}" />

     <br/><br/>

      <h:panelGrid columns="3">
        <h:outputLabel value="#{msg.name}"  styleClass="outputLabel" for="name"/>
        <h:inputText id="name" value="#{nwoSessionBean.id}" size="50" maxlength="100" styleClass="inputText"
                     required="true" title="#{msg.titleName}">
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="name"/>
        
        <h:outputLabel value="#{msg.applicationName}"  styleClass="outputLabel" for="applicationName"/>
        <h:inputText id="applicationName" value="#{nwoSessionBean.applicationName}" size="50" maxlength="100" styleClass="inputText"
                     required="false" title="#{msg.titleApplicationName}">
        </h:inputText>        
        <h:outputText value="" />

        <h:outputLabel value="#{msg.type}" styleClass="outputLabel" for="type"/>
        <h:selectOneMenu id="type" value="#{nwoSessionBean.type}"
                         valueChangeListener="#{nwoSessionBean.changeType}" styleClass="inputText"
                         title="#{msg.titleType}" onblur="checkType(this);">
          <f:selectItems value="#{nwoSessionBean.typeList}"/>
        </h:selectOneMenu>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.styleselect}" styleClass="outputLabel" for="styleselect"/>
        <h:selectOneRadio id="styleselect" value="#{nwoSessionBean.styleselect}" styleClass="inputText"
            title="#{msg.titleStyleselect}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.stylesheet}" styleClass="outputLabel" for="stylesheet"/>
        <h:selectOneMenu id="stylesheet" value="#{nwoSessionBean.stylesheet}"
                         valueChangeListener="#{nwoSessionBean.changeStylesheet}" styleClass="inputText"
                         title="#{msg.titleStylesheet}">
          <f:selectItems value="#{nwoSessionBean.stylesheetList}"/>
        </h:selectOneMenu>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.server}" styleClass="outputLabel" for="server"/>
        <h:inputText id="server" value="#{nwoSessionBean.server}" styleClass="inputText"
          size="50" maxlength="100" title="#{msg.titleServer}">
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="server"/>

        <h:outputLabel value="#{msg.port}" styleClass="outputLabel" for="port"/>
        <h:inputText id="port" value="#{nwoSessionBean.port}" styleClass="inputText"
               size="5" maxlength="6" title="#{msg.titlePort}">
            <f:validateLongRange minimum="1" maximum="65535"/>
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="port"/>

        <h:outputLabel value="#{msg.useSSL}" styleClass="outputLabel" for="useSSL"/>
        <h:selectOneRadio id="useSSL" value="#{nwoSessionBean.useSSL}" styleClass="inputText"
            title="#{msg.titleUseSSL}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
          <!--f:selectItem itemValue="sslnat635" itemLabel="Yes (Natural 6.3.5 compatible)"/-->

        </h:selectOneRadio>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.javaEEAuth}" styleClass="outputLabel" for="javaEEAuth" />
        <h:selectBooleanCheckbox id="javaEEAuth" onclick="setServerCreds(this)" value="#{nwoSessionBean.javaEEAuthentication}" styleClass="outputLabel"  >
        	</h:selectBooleanCheckbox>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.forwardCred}" styleClass="outputLabel" for="serverCredentials" />
        <h:selectBooleanCheckbox id="serverCredentials" onclick="disableUserInput(this)" value="#{nwoSessionBean.webServerAuthentication}" styleClass="outputLabel"  >
        	</h:selectBooleanCheckbox>
        <h:outputText value="" />

        <h:outputLabel id="userIdText" value="#{msg.userId}" styleClass="outputLabel" for="userId" />
        <h:inputText id="userId" value="#{nwoSessionBean.userId}" styleClass="inputText" size="32" maxlength="32"
          onblur="convertToUpperCase(this)" title="#{msg.titleUserId}">
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="userId" />

        <h:outputLabel value="#{msg.ucase}" styleClass="outputLabel" for="ucase"/>
        <h:selectBooleanCheckbox id="ucase" value="#{nwoSessionBean.ucase}" styleClass="outputLabel"  >
        	</h:selectBooleanCheckbox>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.pwd}" styleClass="outputLabel" for="pwd"/>
        <h:inputSecret id="pwd" value="#{nwoSessionBean.pwd}" redisplay="false" styleClass="inputText" size="32" maxlength="32"
                       title="#{msg.titlePwd}">
        </h:inputSecret>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="pwd" />


        <h:outputLabel value="#{msg.saveUserCredentials}" styleClass="outputLabel" for="saveUserCredentials"/>
        <h:selectOneRadio id="saveUserCredentials" value="#{nwoSessionBean.saveUserCredentials}" styleClass="inputText"
            title="#{msg.titleSaveUserCredentials}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.shareSessionUser}" styleClass="outputLabel" for="shareSessionUser"/>
        <h:selectOneRadio id="shareSessionUser" value="#{nwoSessionBean.shareSessionUser}" styleClass="inputText"
            title="#{msg.titleShareSessionUser}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.naturalProgram}" styleClass="outputLabel" for="naturalProgram"/>
        <h:inputText id="naturalProgram" value="#{nwoSessionBean.naturalProgram}" styleClass="inputText"
          size="25" maxlength="1024" title="#{msg.titleNaturalProgram}">
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="naturalProgram"/>

        <h:outputLabel value="#{msg.naturalParameter}" styleClass="outputLabel" for="naturalParameter"/>
        <h:inputText id="naturalParameter" value="#{nwoSessionBean.naturalParameter}" styleClass="inputText"
          size="50" maxlength="1024" title="#{msg.titleNaturalParameter}">
        </h:inputText>
        <h:outputText value="" />

				<!-- Disconnect behavior -->
        <h:outputLabel value="#{msg.disconnectBehavior}" styleClass="outputLabel" for="disconnectBehavior"/>
        <h:selectOneMenu id="disconnectBehavior" value="#{nwoSessionBean.disconnectBehavior}"
                         valueChangeListener="#{nwoSessionBean.changeDisconnectBehavior}" styleClass="inputText"
                         title="#{msg.titleDisconnectBehavior}">
                             <f:selectItems value="#{nwoSessionBean.disconnectBehaviorList}"/>
        </h:selectOneMenu>
        <h:outputText value="" />

			   <!-- Language -->
        <h:outputLabel value="#{msg.language}" styleClass="outputLabel" for="language"/>
        <h:selectOneMenu id="language" value="#{nwoSessionBean.language}"
                         valueChangeListener="#{nwoSessionBean.changeLanguage}" styleClass="inputText"
                         title="#{msg.titleLanguage}">
          <f:selectItems value="#{nwoSessionBean.languageList}"/>
        </h:selectOneMenu>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.doubleClick}" styleClass="outputLabel" for="doubleClick"/>
        <h:selectOneMenu id="doubleClick" value="#{nwoSessionBean.doubleClick}"
                         valueChangeListener="#{nwoSessionBean.changeDoubleClick}" styleClass="inputText"
                         title="#{msg.titleDoubleClick}">
          <f:selectItems value="#{nwoSessionBean.doubleClickList}"/>
        </h:selectOneMenu>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.pfkeysDisplay}" styleClass="outputLabel" for="pfKeysDisplay"/>
        <h:selectOneMenu id="pfKeysDisplay" value="#{nwoSessionBean.pfKeysDisplay}"
                         valueChangeListener="#{nwoSessionBean.changePfKeysDisplay}" styleClass="inputText"
                         title="#{msg.titlePfKeysDisplay}">
                             <f:selectItems value="#{nwoSessionBean.pfKeysDisplayList}"/>
        </h:selectOneMenu>
        <h:outputText value="" />


        <h:outputLabel value="#{msg.screenRows}" styleClass="outputLabel" for="screenRows"/>
        <h:inputText id="screenRows" value="#{nwoSessionBean.screenRows}" styleClass="inputText"
             size="5" maxlength="10" title="#{msg.titleScreenRows}">
            <f:validateLongRange minimum="24"/>
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="screenRows"/>

        <h:outputLabel value="#{msg.screenColumns}" styleClass="outputLabel" for="screenColumns"/>
        <h:inputText id="screenColumns" value="#{nwoSessionBean.screenColumns}"  styleClass="inputText"
            size="5" maxlength="10" title="#{msg.titleScreenColumns}">
            <f:validateLongRange minimum="80"/>
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="screenColumns"/>

        <h:outputLabel value="#{msg.showFKeyNumbers}" styleClass="outputLabel" for="showFKeyNumbers"/>
        <h:selectOneRadio id="showFKeyNumbers" value="#{nwoSessionBean.showFKeyNumbers}" styleClass="inputText"
            title="#{msg.titleShowFKeyNumbers}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.trace}" styleClass="outputLabel" for="trace"/>
        <h:selectOneRadio id="trace" value="#{nwoSessionBean.trace}" styleClass="inputText"
                          title="#{msg.titleTrace}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />

        <!--h:message showSummary="true" showDetail="false" styleClass="showError" for="screenColumns"/-->

        <!-- check numeric input -->
        <h:outputLabel value="#{msg.checkNumFields}" styleClass="outputLabel" for="checkNumFields"/>
        <h:selectOneRadio id="checkNumFields" value="#{nwoSessionBean.checkNumFields}" styleClass="inputText"
            title="#{msg.titleCheckNumFields}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />


        <!-- Auto skip -->
        <h:outputLabel value="#{msg.autoSkip}" styleClass="outputLabel" for="autoSkip"/>
        <h:selectOneRadio id="autoSkip" value="#{nwoSessionBean.autoSkip}" styleClass="inputText"
            title="#{msg.titleAutoSkip}">
          <f:selectItem itemValue="true" itemLabel="Yes"/>
          <f:selectItem itemValue="false" itemLabel="No"/>
        </h:selectOneRadio>
        <h:outputText value="" />

        <!-- Timeout -->
        <h:outputLabel value="#{msg.timeout}" styleClass="outputLabel" for="natTimeout"/>
        <h:inputText id="natTimeout" value="#{nwoSessionBean.natTimeout}"  size="5"
                     maxlength="10" styleClass="inputText" title="#{msg.titleTimeout}">
            <f:validateLongRange minimum="0"/>
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="natTimeout"/>


        <h:outputLabel value="#{msg.convertFrom}" styleClass="outputLabel" for="convertFrom"/>
        <h:inputText id="convertFrom" value="#{nwoSessionBean.convertFrom}" styleClass="inputText"
          size="50" maxlength="1024" title="#{msg.convertFromTitle}">
        </h:inputText>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.convertTo}" styleClass="outputLabel" for="convertTo"/>
        <h:inputText id="convertTo" value="#{nwoSessionBean.convertTo}" styleClass="inputText"
          size="50" maxlength="1024" title="#{msg.convertToTitle}">
        </h:inputText>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.fillerCharacter}" styleClass="outputLabel" for="fillerCharacter"/>
        <h:inputText id="fillerCharacter" value="#{nwoSessionBean.fillerCharacter}" styleClass="inputText"
          size="1" maxlength="1" title="#{msg.fillerCharacterTitle}">
        </h:inputText>
        <h:outputText value="" />

      </h:panelGrid>

      <br/><br/>

      <h:panelGrid columns="2">
        <h:commandButton value="#{msg.OK}" action="#{nwoSessionBean.saveNwoSession}"
                         title="#{msg.titleOK}" styleClass="submitButtonColor"  style="width: 100px"/>
        <h:commandButton value="#{msg.cancel}" action="cancelSession" immediate="true"
                         title="#{msg.titleCancel}" styleClass="submitButtonColor"  style="width: 100px"/>
      </h:panelGrid>
    </h:form>

    </body>
  </f:view>
</html>
