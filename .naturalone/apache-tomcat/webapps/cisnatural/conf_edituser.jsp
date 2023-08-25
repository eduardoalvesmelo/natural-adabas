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

</script>
<html>
  <f:view>
    <f:loadBundle basename="com.softwareag.nwo.conftool.conftool" var="msg"/>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <link rel="stylesheet" type="text/css" href="conf_nwostyle.css"/>
      <title>${msg.confTool}</title>
    </head>

    <body bgcolor="white">

    <h:form id="editUser">
      <h:inputHidden id="idNumber" value="#{nwoUserBean.idNumber}"/>


     <h:outputText styleClass="TitlePage" value="#{msg.defUser}" />

     <br/><br/>

      <h:panelGrid columns="3">

        <h:outputLabel value="#{msg.userId}" styleClass="outputLabel" for="userId"/>
        <h:inputText id="userId" value="#{nwoUserBean.userName}" styleClass="inputText" size="32" maxlength="32"
          title="#{msg.titleUserId}">
        </h:inputText>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="userId" />

        <h:outputLabel value="#{msg.pwd}" styleClass="outputLabel" for="pwd"/>
        <h:inputSecret id="pwd" value="#{nwoUserBean.pwd}" redisplay="false" styleClass="inputText" size="32" maxlength="32"
                       title="#{msg.titlePwd}">
        </h:inputSecret>
        <h:message showSummary="true" showDetail="false" styleClass="showError" for="pwd" />


      </h:panelGrid>

      <br/><br/>

      <h:panelGrid columns="2">
        <h:commandButton value="#{msg.OK}" action="#{nwoUserBean.saveNwoUser}"
                         title="#{msg.titleOK}" styleClass="submitButtonColor"  style="width: 100px"/>
        <h:commandButton value="#{msg.cancel}" action="cancelUser" immediate="true"
                         title="#{msg.titleCancel}" styleClass="submitButtonColor"  style="width: 100px"/>
      </h:panelGrid>
    </h:form>

    </body>
  </f:view>
</html>