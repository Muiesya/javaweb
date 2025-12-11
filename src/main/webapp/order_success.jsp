<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>下单成功</title>
</head>
<body>
<h2>下单成功！</h2>
<p>订单号：<strong><%= request.getAttribute("orderId") %></strong></p>
<p>应付总额：￥<%= request.getAttribute("totalAmount") %></p>
<% if (request.getAttribute("orderWarning") != null) { %>
    <p style="color: #d35400;">提示：<%= request.getAttribute("orderWarning") %></p>
<% } %>
<p><a href="<%=request.getContextPath()%>/mall.jsp">返回商城继续选购</a></p>
</body>
</html>
