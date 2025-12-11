<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>中药材信息管理</title>
</head>
<body>
<h1>中药材信息</h1>
<p><a href="index.jsp">返回首页</a> | <a href="medicine_edit.jsp">新增中药材</a></p>
<table border="1" cellspacing="0" cellpadding="6">
    <thead>
    <tr>
        <th>编号</th>
        <th>中药名</th>
        <th>别名</th>
        <th>详情</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
        String jdbcUrl = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
        String dbUser = "root";
        String dbPwd = "87609215Bb@"; // 请根据实际密码调整

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            out.println("<tr><td colspan='5'>加载数据库驱动失败: " + e.getMessage() + "</td></tr>");
        }

        boolean hasData = false;
        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPwd);
             PreparedStatement ps = conn.prepareStatement("SELECT id, code, name, alias FROM medicine ORDER BY id DESC");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                hasData = true;
    %>
    <tr>
        <td><%= rs.getString("code") %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("alias") %></td>
        <td><a href="medicine_detail.jsp?id=<%= rs.getInt("id") %>">查看详情</a></td>
        <td>
            <a href="medicine_edit.jsp?id=<%= rs.getInt("id") %>">修改</a> |
            <a href="medicine_delete.jsp?id=<%= rs.getInt("id") %>" onclick="return confirm('确认删除吗?')">删除</a>
        </td>
    </tr>
    <%
            }

            if (!hasData) {
                out.println("<tr><td colspan='5'>当前没有任何中药材记录。</td></tr>");
            }
        } catch (SQLException e) {
            out.println("<tr><td colspan='5'>查询数据失败: " + e.getMessage() + "</td></tr>");
        }
    %>
    </tbody>
</table>
</body>
</html>
