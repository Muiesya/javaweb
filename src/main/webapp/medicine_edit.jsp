<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<html>
<head>
    <title>修改药材信息</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    String message = null;
    String error = null;
    Integer id = null;
    try {
        id = Integer.valueOf(request.getParameter("id"));
    } catch (Exception e) {
        error = "缺少或无效的编号参数";
    }

    String jdbcUrl = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    String user = "root";
    String password = "87609215Bb@";

    if (error == null && request.getMethod().equalsIgnoreCase("POST")) {
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String alias = request.getParameter("alias");
        String origin = request.getParameter("origin");
        String growth_environment = request.getParameter("growth_environment");
        String taste_and_property = request.getParameter("taste_and_property");
        String main_function = request.getParameter("main_function");
        String dosage_and_usage = request.getParameter("dosage_and_usage");

        String updateSql = "UPDATE medicine SET code=?, name=?, alias=?, origin=?, growth_environment=?, taste_and_property=?, main_function=?, dosage_and_usage=? WHERE id=?";
        try (Connection conn = DriverManager.getConnection(jdbcUrl, user, password);
             PreparedStatement psmt = conn.prepareStatement(updateSql)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            psmt.setString(1, code);
            psmt.setString(2, name);
            psmt.setString(3, alias);
            psmt.setString(4, origin);
            psmt.setString(5, growth_environment);
            psmt.setString(6, taste_and_property);
            psmt.setString(7, main_function);
            psmt.setString(8, dosage_and_usage);
            psmt.setInt(9, id);
            psmt.executeUpdate();
            message = "更新成功！";
        } catch (Exception e) {
            error = "更新失败：" + e.getMessage();
        }
    }

    ResultSet rs = null;
    if (error == null && id != null) {
        String selectSql = "SELECT * FROM medicine WHERE id=?";
        try (Connection conn = DriverManager.getConnection(jdbcUrl, user, password);
             PreparedStatement psmt = conn.prepareStatement(selectSql)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            psmt.setInt(1, id);
            rs = psmt.executeQuery();

            if (rs.next()) {
%>
    <h1>修改药材信息</h1>
    <% if (message != null) { %>
        <p style="color: green;"><%= message %></p>
    <% } %>
    <% if (error != null) { %>
        <p style="color: red;"><%= error %></p>
    <% } %>
    <form method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <table>
            <tr><td>编号:</td><td><input type="text" name="code" value="<%= rs.getString("code") %>"></td></tr>
            <tr><td>中药名:</td><td><input type="text" name="name" value="<%= rs.getString("name") %>"></td></tr>
            <tr><td>别名:</td><td><input type="text" name="alias" value="<%= rs.getString("alias") %>"></td></tr>
            <tr><td>来源:</td><td><input type="text" name="origin" value="<%= rs.getString("origin") %>"></td></tr>
            <tr><td>生长环境分布:</td><td><input type="text" name="growth_environment" value="<%= rs.getString("growth_environment") %>"></td></tr>
            <tr><td>性味:</td><td><input type="text" name="taste_and_property" value="<%= rs.getString("taste_and_property") %>"></td></tr>
            <tr><td>主治功能:</td><td><input type="text" name="main_function" value="<%= rs.getString("main_function") %>"></td></tr>
            <tr><td>用法用量:</td><td><input type="text" name="dosage_and_usage" value="<%= rs.getString("dosage_and_usage") %>"></td></tr>
        </table>
        <input type="submit" value="提交修改">
    </form>
<%
            } else {
                error = "未找到相关药材";
            }
        } catch (Exception e) {
            error = "查询失败：" + e.getMessage();
        }
    }

    if (error != null && (rs == null || rs.isClosed())) {
%>
    <p style="color: red;"><%= error %></p>
<%
    }
%>
    <br><a href="medicine_list.jsp">返回列表</a>
</body>
</html>
