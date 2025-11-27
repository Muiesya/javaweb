<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<html>
<head>
    <title>中药材信息管理</title>
</head>
<body>
    <h1>中药材信息</h1>
    <table border="1">
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
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
                    String username = "root";
                    String password = "87609215Bb@"; // 替换为你的数据库密码
                    conn = DriverManager.getConnection(url, username, password);
                    stmt = conn.createStatement();
                    String sql = "SELECT * FROM medicine";
                    rs = stmt.executeQuery(sql);
                    
                    while (rs.next()) {
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
                } catch (Exception e) {
                    out.println("错误: " + e.getMessage());
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
</body>
</html>
