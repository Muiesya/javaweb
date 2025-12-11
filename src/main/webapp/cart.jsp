<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.OrderItem" %>
<%
    List<OrderItem> cart = (List<OrderItem>) session.getAttribute("shoppingCart");
    if (cart == null) {
        cart = new java.util.ArrayList<>();
    }
    double total = 0;
    for (OrderItem item : cart) {
        total += item.getSubTotal();
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>购物车</title>
</head>
<body>
<h2>购物车</h2>
<p><a href="<%=request.getContextPath()%>/mall.jsp">继续选购</a></p>

<% if (cart.isEmpty()) { %>
    <p>购物车为空。</p>
<% } else { %>
    <table border="1" cellspacing="0" cellpadding="6">
        <thead>
        <tr>
            <th>药材</th>
            <th>单价</th>
            <th>数量</th>
            <th>小计</th>
        </tr>
        </thead>
        <tbody>
        <% for (OrderItem item : cart) { %>
            <tr>
                <td><%= item.getMedicineName() %></td>
                <td>￥<%= item.getCurrentPrice() %></td>
                <td><%= item.getQuantity() %></td>
                <td>￥<%= String.format("%.2f", item.getSubTotal()) %></td>
            </tr>
        <% } %>
        <tr>
            <td colspan="3" style="text-align: right;">总金额：</td>
            <td>￥<%= String.format("%.2f", total) %></td>
        </tr>
        </tbody>
    </table>
<% } %>

<% if (request.getAttribute("cartError") != null) { %>
    <p style="color:red;"><%= request.getAttribute("cartError") %></p>
<% } %>

<form action="<%=request.getContextPath()%>/cart" method="post">
    <input type="hidden" name="action" value="checkout" />
    <p>
        <label>收货地址：<input type="text" name="address" style="width:300px" required></label>
    </p>
    <button type="submit" <%= cart.isEmpty() ? "disabled" : "" %>>结算</button>
</form>
</body>
</html>
