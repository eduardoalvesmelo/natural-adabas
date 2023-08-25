<%-- Copyright (c) Software AG, Darmstadt --%>

<!DOCTYPE html>

<html>
<body>
<%
session.invalidate();
response.sendRedirect(request.getContextPath() + "/conf_index.jsp");
%>
</body>
</html>