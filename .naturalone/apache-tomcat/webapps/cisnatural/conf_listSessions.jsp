<%@ page language="java"%>
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
      <h:form id="listSessions">
        <h:outputText value="#{msg.sessionsConfiguration}" styleClass="TitlePage"/>
        <br/><br/>
        <h:panelGrid columns="1">
        <h:commandButton id="saveConfiguration" value="#{msg.saveConfiguration}" action="saveSessions"
                         actionListener="#{nwoSettings.saveNwoSessions}" 
                         title="#{msg.titleSaveConfiguration}" styleClass="submitButtonColor"
                         style="width: 150px"/>

		 <h:message showSummary="true" showDetail="false" infoStyle="display:none" styleClass="showError" for="saveConfiguration"/>
		 <h:message showSummary="true" showDetail="false" errorStyle="display:none" styleClass="showInfo" for="saveConfiguration"/>
        </h:panelGrid>
        <br/><br/>
        <h:outputText value="#{msg.globalSettings}" styleClass="Title1"/>
        <br/><br/>
        <h:panelGrid columns="3" border="0">
        <h:outputLabel for="lastActivityTimeout" value="#{msg.lastActivityTimeout}" styleClass="outputLabel"/>
        <h:inputText id="lastActivityTimeout" value="#{nwoSettings.global.lastActivityTimeout}" styleClass="inputText"
           size="10" maxlength="10" title="#{msg.titleLastActivityTimeout}">
          <f:validateLongRange minimum="0" maximum="43200"/>
        </h:inputText>
        <h:message showSummary="true" showDetail="false"
                   styleClass="showError"
                   id="errors1"
                   for="lastActivityTimeout"/>

        <h:outputLabel for="browseFile" value="#{msg.traceDir}" styleClass="outputLabel"/>
        <%--<input type="file" id="BrowseFile">--%>
        <h:inputText id="browseFile" value="#{nwoSettings.global.traceDir}" styleClass="inputText"
          size="70" maxlength="1024" title="#{msg.titleTraceDir}"/>
				<h:outputText value=""/>

        <h:outputLabel value="#{msg.trustFileName}" styleClass="outputLabel" for="trustFileName" />
        <h:inputText id="trustFileName" value="#{nwoSettings.global.trustFileName}" styleClass="inputText"
          size="70" maxlength="1024" title="#{msg.titleTrustFileName}"/>
       <h:outputText value=""/>

        <h:outputLabel value="#{msg.trustFilePassword}" styleClass="outputLabel" for="trustFilePassword" />
        <h:inputSecret id="trustFilePassword" redisplay="true" value="#{nwoSettings.global.trustFilePassword}" styleClass="inputText"
          size="70" maxlength="1024" title="#{msg.titleTrustFilePassword}"/>
       <h:outputText value=""/>

        <h:outputLabel value="#{msg.ssoLogonPage}" styleClass="outputLabel" for="serverCredentials" />
        <h:selectBooleanCheckbox id="serverCredentials" value="#{nwoSettings.global.useSSOLogin}" styleClass="outputLabel"  >
        	</h:selectBooleanCheckbox>
        <h:outputText value="" />

        <h:outputLabel value="#{msg.useSamlLogin}" styleClass="outputLabel" for="useSamlLogin" />
        <h:selectBooleanCheckbox id="useSamlLogin" value="#{nwoSettings.global.useSamlLogin}" styleClass="outputLabel"  >
        	</h:selectBooleanCheckbox>
        <h:outputText value="" />

        </h:panelGrid>

        <br/><br/>

        <h:outputText value="#{msg.nwoSessions}" styleClass="Title1"/>
        <br/><br/>
        <h:dataTable id="nwoSessions"  value="#{nwoSettings.nwoSessions}"  var="nwoSession"
          headerClass="headerId, headerServer, headerPort, headerPrg, headerPar, headerEdit, headerDuplicate, headerDel"
          columnClasses="idCol, serverCol, portCol, prgCol, parCol, editCol, delCol, delCol"
          cellspacing="5" cellpadding="false" border="0">
          <h:column> <f:facet name="header"> <h:outputText value="#{msg.headerName}" styleClass="headerCol"/> </f:facet>
                     <h:outputText value="#{nwoSession.id}" styleClass="outputText"/>
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.headerServer}" styleClass="headerCol"/> </f:facet>
                     <h:outputText value="#{nwoSession.server}"  styleClass="outputText"/>
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.headerPort}" styleClass="headerCol"/> </f:facet>
                     <h:outputText value="#{nwoSession.port}" styleClass="outputText" />
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.headerPrg}" styleClass="headerCol"/> </f:facet>
                     <h:outputText value="#{nwoSession.naturalProgram}"  styleClass="outputText"/>
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.headerPar}" styleClass="headerCol"/> </f:facet>
                     <h:outputText value="#{nwoSession.naturalParameter}"  styleClass="outputText"/>
          </h:column>

          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.edit}" styleClass="headerCol"/> </f:facet>
                     <h:commandLink id="Edit" action="editSession" actionListener="#{nwoSessionBean.selectNwoSession}">
                     <h:outputText value="#{msg.edit}"  styleClass="outputText"/> <f:param id="editId"  name="id"  value="#{nwoSession.idNumber}" />
                     </h:commandLink>
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.duplicate}" styleClass="headerCol"/> </f:facet>
                     <h:commandLink id="Duplicate" action="listSessions" actionListener="#{nwoSessionBean.duplicateNwoSession}">
                     <h:outputText value="#{msg.duplicate}"  styleClass="outputText"/> <f:param id="duplicateId"  name="id"  value="#{nwoSession.idNumber}" />
                     </h:commandLink>
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.delete}" styleClass="headerCol"/> </f:facet>
                     <h:commandLink id="Delete" action="listSessions" actionListener="#{nwoSessionBean.deleteNwoSession}">
                     <h:outputText value="#{msg.delete}"  styleClass="outputText"/> <f:param id="deleteId"  name="id"  value="#{nwoSession.idNumber}" />
                     </h:commandLink>
          </h:column>
        </h:dataTable>

        <%--
        <h:commandLink id="Add" action="editSession" actionListener="#{nwoSessionBean.initNwoSession}">
          <h:outputText value="#{msg.addSession}" styleClass="outputText"/>
        </h:commandLink>

        <h:commandLink id="SaveSessions" action="saveSessions" actionListener="#{nwoSettings.saveNwoSessions}">
          <h:outputText value="#{msg.saveSessions}" styleClass="outputText"/>
        </h:commandLink>
        --%>

        <h:panelGrid columns="1">
        <h:commandButton id="AddSession" value="#{msg.addSession}" action="editSession"
                         actionListener="#{nwoSessionBean.initNwoSession}"
                         title="#{msg.titleAddSession}" styleClass="submitButtonColor"
                         style="width: 150px"/>
        </h:panelGrid>

        <br/><br/>
        <h:outputLabel for="nwoUsers" value="#{msg.nwoUsers}" styleClass="Title1"/>
        <br/><br/>
        <h:dataTable id="nwoUsers"  value="#{nwoSettings.nwoUsers}"  var="nwoUser"
          headerClass="headerId, headerEdit, headerDuplicate, headerDel"
          columnClasses="idCol, editCol, delCol, editCol"
          cellspacing="4" cellpadding="false" border="0">
          <h:column> <f:facet name="header"> <h:outputText value="#{msg.headerUserName}" styleClass="headerCol"/> </f:facet>
                     <h:outputText value="#{nwoUser.userName}" styleClass="outputText"/>
          </h:column>

          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.edit}" styleClass="headerCol"/> </f:facet>
                     <h:commandLink id="Edit" action="editUser" actionListener="#{nwoUserBean.selectNwoUser}">
                     <h:outputText value="#{msg.edit}"  styleClass="outputText"/> <f:param id="editId"  name="id"  value="#{nwoUser.idNumber}" />
                     </h:commandLink>
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.duplicate}" styleClass="headerCol"/> </f:facet>
                     <h:commandLink id="Duplicate" action="listUsers" actionListener="#{nwoUserBean.duplicateNwoUser}">
                     <h:outputText value="#{msg.duplicate}"  styleClass="outputText"/> <f:param id="duplicateId"  name="id"  value="#{nwoUser.idNumber}" />
                     </h:commandLink>
          </h:column>
          <h:column> <f:facet name="header"> <h:outputText  value="#{msg.delete}" styleClass="headerCol"/> </f:facet>
                     <h:commandLink id="Delete" action="listUsers" actionListener="#{nwoUserBean.deleteNwoUser}">
                     <h:outputText value="#{msg.delete}"  styleClass="outputText"/> <f:param id="deleteId"  name="id"  value="#{nwoUser.idNumber}" />
                     </h:commandLink>
          </h:column>
        </h:dataTable>

        <h:panelGrid columns="1">
        <h:commandButton id="AddUser" value="#{msg.addUser}" action="editUser"
                         actionListener="#{nwoUserBean.initNwoUser}"
                         title="#{msg.titleAddUser}" styleClass="submitButtonColor"
                         style="width: 150px"/>

        </h:panelGrid>
      </h:form>
    </body>
  </f:view>
</html>
