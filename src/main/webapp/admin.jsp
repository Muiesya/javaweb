<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    com.example.model.User currentUser = (com.example.model.User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员主页</title>
</head>
<body>
<h2>管理员中心</h2>
<% if (currentUser != null) { %>
    <p>欢迎，<%= currentUser.getDisplayName() %>（账号：<%= currentUser.getUsername() %>）。</p>
    <p>当前角色：<%= currentUser.getRole() %></p>
<% } else { %>
    <p>未获取到用户信息，请重新登陆。</p>
<% } %>
<p><a href="${pageContext.request.contextPath}/login">返回登陆页</a></p>
</body>
</html>
