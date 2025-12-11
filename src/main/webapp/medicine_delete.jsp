<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<html>
<head>
    <title>删除药材信息</title>
</head>
<body>
    <% int id=Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement psmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai", "root", "87609215Bb@");
            String delsql = "DELETE FROM medicine WHERE id = ?";
            psmt = conn.prepareStatement(delsql);
            psmt.setInt(1, id);
            int rows = psmt.executeUpdate();
            if (rows > 0) {
                out.println("删除成功！<br>");
            } else {
                out.println("未找到该药材信息，删除失败。<br>");
            }
            out.println("<a href='medicine_list.jsp'>返回列表</a>");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { 
                if (psmt != null) psmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>