<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<html>
<head>
    <title>修改药材信息</title>
</head>
<body>
    <h1>修改药材信息</h1>
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        if (request.getMethod().equalsIgnoreCase("POST")) {
            // 获取表单提交的数据并更新数据库
            String code = request.getParameter("code");
            String name = request.getParameter("name");
            String alias = request.getParameter("alias");
            String origin = request.getParameter("origin");
            String growth_environment = request.getParameter("growth_environment");
            String taste_and_property = request.getParameter("taste_and_property");
            String main_function = request.getParameter("main_function");
            String dosage_and_usage = request.getParameter("dosage_and_usage");

            try {
                conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8", "root", "87609215Bb@");
                String updateSql = "UPDATE medicine SET code=?, name=?, alias=?, origin=?, growth_environment=?, taste_and_property=?, main_function=?, dosage_and_usage=? WHERE id=?";
                psmt = conn.prepareStatement(updateSql);
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
                out.println("更新成功！<br>");
                out.println("<a href='medicine_list.jsp'>返回列表</a>");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            // 获取当前药材信息并填充到表单
            try {
                conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8", "root", "87609215Bb@");
                String selectSql = "SELECT * FROM medicine WHERE id=?";
                psmt = conn.prepareStatement(selectSql);
                psmt.setInt(1, id);
                rs = psmt.executeQuery();

                if (rs.next()) {
    %>
    <form method="post">
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
                    out.println("未找到相关药材");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <br><a href="medicine_list.jsp">返回列表</a>
</body>
</html>
