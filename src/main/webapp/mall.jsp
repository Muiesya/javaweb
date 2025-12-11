<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.dao.MedicineDAO" %>
<%@ page import="com.example.model.Medicine" %>
<%
    MedicineDAO medicineDAO = new MedicineDAO();
    List<Medicine> medicines = null;
    String loadError = null;
    try {
        medicines = medicineDAO.findAll();
    } catch (Exception e) {
        loadError = "加载药材列表失败: " + e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>选购大厅</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 12px; }
        .card { border: 1px solid #ccc; padding: 12px; border-radius: 6px; }
        .card h3 { margin: 0 0 8px 0; }
        .topbar { margin-bottom: 16px; }
    </style>
</head>
<body>
<div class="topbar">
    <strong>中药材选购大厅</strong>
    <span style="margin-left: 16px;"><a href="<%=request.getContextPath()%>/cart.jsp">购物车</a></span>
    <span style="margin-left: 16px;"><a href="<%=request.getContextPath()%>/login">返回登录</a></span>
</div>

<% if (loadError != null) { %>
    <p style="color:red;"><%= loadError %></p>
<% } %>

<% if (medicines == null || medicines.isEmpty()) { %>
    <p>暂无药材可选，请稍后再试。</p>
<% } else { %>
    <div class="grid">
        <% for (Medicine medicine : medicines) { %>
            <div class="card">
                <h3><%= medicine.getName() %></h3>
                <p>别名：<%= medicine.getAlias() == null ? "-" : medicine.getAlias() %></p>
                <p>单价：￥<%= medicine.getPrice() %></p>
                <p>库存：<%= medicine.getStock() %></p>
                <form action="<%=request.getContextPath()%>/cart" method="post">
                    <input type="hidden" name="action" value="add" />
                    <input type="hidden" name="id" value="<%= medicine.getId() %>" />
                    <label>数量：<input type="number" name="quantity" value="1" min="1" style="width:80px;"></label>
                    <button type="submit">加入购物车</button>
                </form>
            </div>
        <% } %>
    </div>
<% } %>

<% if (request.getAttribute("error") != null) { %>
    <p style="color:red; margin-top:16px;"><%= request.getAttribute("error") %></p>
<% } %>
</body>
</html>
