<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<html>
<head>
    <title>中药材详情</title>  
</head>
<body>
    <h1>中药详情</h1>
    <% 
        int id=Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String url = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8"; 
            String username = "root";
            String password = "87609215Bb@";
            conn = DriverManager.getConnection(url, username, password);
            String sql = "SELECT * FROM medicine WHERE id = ?";            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
    %>
    <table border="1">
    <tr><td>编号</td><td><%= rs.getString("code") %></td></tr> 
    <tr><td>中药名</td><td><%= rs.getString("name") %></td></tr>
    <tr><td>别名</td><td><%= rs.getString("alias") %></td></tr>
    <tr><td>来源</td><td><%= rs.getString("origin") %></td></tr>
    <tr><td>生长环境分布</td><td><%= rs.getString("growth_environment") %></td></tr>            
    <tr><td>性味</td><td><%= rs.getString("taste_and_property") %></td></tr>            
    <tr><td>主治功能</td><td><%= rs.getString("main_function") %></td></tr>            
    <tr><td>用法用量</td><td><%= rs.getString("dosage_and_usage") %></td></tr>
    </table>
    <%
            }else{
                out.println("未找到该中药材信息。");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <br><a href="medicine_list.jsp">返回列表</a>
</body>
</html>
