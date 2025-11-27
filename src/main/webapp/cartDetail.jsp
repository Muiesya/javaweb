<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.CartItem" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车详情</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        .summary { margin-top: 12px; font-weight: bold; }
        .back-link { margin-top: 16px; display: inline-block; }
    </style>
</head>
<body>
<h1>购物车详情</h1>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
%>
<p>购物车为空，<a href="herbList.jsp">去挑选中药材</a>。</p>
<%
    } else {
        double total = 0;
        for (CartItem item : cart) {
            total += item.getSubtotal();
        }
%>
<table>
    <thead>
    <tr>
        <th>编号</th>
        <th>名称</th>
        <th>单价(元)</th>
        <th>数量</th>
        <th>小计(元)</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (CartItem item : cart) {
    %>
    <tr>
        <td><%= item.getId() %></td>
        <td><%= item.getName() %></td>
        <td><%= String.format("%.2f", item.getPrice()) %></td>
        <td><%= item.getQuantity() %></td>
        <td><%= String.format("%.2f", item.getSubtotal()) %></td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<div class="summary">总金额：<%= String.format("%.2f", total) %> 元</div>
<div class="back-link"><a href="herbList.jsp">继续选购</a></div>
<%
    }
%>
</body>
</html>
