<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>中药材列表</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        input[type="number"] { width: 70px; }
        .actions { display: flex; justify-content: center; gap: 12px; }
        .cart-link { margin-top: 16px; display: inline-block; }
    </style>
</head>
<body>
<h1>中药材列表</h1>
<table>
    <thead>
    <tr>
        <th>编号</th>
        <th>名称</th>
        <th>单价(元)</th>
        <th>数量</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
            String username = "root";
            String password = "87609215Bb@";
            conn = DriverManager.getConnection(url, username, password);
            stmt = conn.createStatement();
            String sql = "SELECT id, code, name, IFNULL(price, 0) AS price FROM medicine";
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                int id = rs.getInt("id");
                String code = rs.getString("code");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
    %>
    <tr>
        <form action="cart" method="post">
            <td><input type="hidden" name="id" value="<%= id %>"><%= code %></td>
            <td><input type="hidden" name="fallbackName" value="<%= name %>"><%= name %></td>
            <td><input type="hidden" name="fallbackPrice" value="<%= price %>"><%= String.format("%.2f", price) %></td>
            <td><input type="number" name="quantity" value="1" min="1"></td>
            <td><button type="submit">加入购物车</button></td>
        </form>
    </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>无法读取数据库中的药材数据：" + e.getMessage() + "</td></tr>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    </tbody>
</table>
<div class="cart-link">
    <a href="cart">查看购物车</a>
</div>
</body>
</html>
