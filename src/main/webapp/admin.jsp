<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员主页</title>
</head>
<body>
<h2>管理员中心</h2>
<c:choose>
    <c:when test="${not empty sessionScope.currentUser}">
        <p>欢迎，${sessionScope.currentUser.displayName}（账号：${sessionScope.currentUser.username}）。</p>
        <p>当前角色：${sessionScope.currentUser.role}</p>
    </c:when>
    <c:otherwise>
        <p>未获取到用户信息，请重新登陆。</p>
    </c:otherwise>
</c:choose>
<p><a href="${pageContext.request.contextPath}/login">返回登陆页</a></p>
</body>
</html>
