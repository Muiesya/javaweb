<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>中药材信息维护</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
    String jdbcUrl = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    String user = "root";
    String password = "87609215Bb@";

    String message = request.getParameter("message");
    String error = request.getParameter("error");
    String idParam = request.getParameter("id");
    Integer id = null;
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            id = Integer.valueOf(idParam);
        } catch (Exception e) {
            error = "无效的编号参数";
        }
    }

    String code = "";
    String name = "";
    String alias = "";
    String origin = "";
    String growthEnv = "";
    String taste = "";
    String mainFunction = "";
    String dosage = "";
    Double price = 0d;
    Integer stock = 0;
    String photoPath = null;

    if (error == null && id != null) {
        String selectSql = "SELECT * FROM medicine WHERE id=?";
        try (Connection conn = DriverManager.getConnection(jdbcUrl, user, password);
             PreparedStatement psmt = conn.prepareStatement(selectSql)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            psmt.setInt(1, id);
            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    code = rs.getString("code");
                    name = rs.getString("name");
                    alias = rs.getString("alias");
                    origin = rs.getString("origin");
                    growthEnv = rs.getString("growth_environment");
                    taste = rs.getString("taste_and_property");
                    mainFunction = rs.getString("main_function");
                    dosage = rs.getString("dosage_and_usage");
                    try { price = rs.getDouble("price"); } catch (Exception ignored) { }
                    try { stock = rs.getInt("stock"); } catch (Exception ignored) { }
                    photoPath = rs.getString("photo_path");
                } else {
                    error = "未找到相关药材";
                }
            }
        } catch (Exception e) {
            error = "查询失败：" + e.getMessage();
        }
    }
%>

<h1><%= id == null ? "新增药材" : "修改药材" %></h1>
<% if (message != null) { %>
<p style="color: green;"><%= message %></p>
<% } %>
<% if (error != null) { %>
<p style="color: red;"><%= error %></p>
<% } %>

<form method="post" id="editForm" action="<%=request.getContextPath()%>/medicine/save" enctype="multipart/form-data">
    <% if (id != null) { %>
    <input type="hidden" name="id" value="<%= id %>">
    <% } %>
    <input type="hidden" name="existingPhoto" value="<%= photoPath == null ? "" : photoPath %>">
    <table>
        <tr><td>编号:</td><td><input type="text" name="code" id="codeInput" value="<%= code %>"> <span id="codeMsg" style="color:#d00;"></span></td></tr>
        <tr><td>中药名:</td><td><input type="text" name="name" value="<%= name %>"></td></tr>
        <tr><td>别名:</td><td><input type="text" name="alias" value="<%= alias %>"></td></tr>
        <tr><td>来源:</td><td><input type="text" name="origin" value="<%= origin %>"></td></tr>
        <tr><td>生长环境分布:</td><td><input type="text" name="growth_environment" value="<%= growthEnv %>"></td></tr>
        <tr><td>性味:</td><td><input type="text" name="taste_and_property" value="<%= taste %>"></td></tr>
        <tr><td>主治功能:</td><td><input type="text" name="main_function" value="<%= mainFunction %>"></td></tr>
        <tr><td>用法用量:</td><td><input type="text" name="dosage_and_usage" value="<%= dosage %>"></td></tr>
        <tr><td>单价:</td><td><input type="number" step="0.01" name="price" value="<%= price %>"></td></tr>
        <tr><td>库存:</td><td><input type="number" name="stock" value="<%= stock %>"></td></tr>
        <tr>
            <td>药材图片:</td>
            <td>
                <% if (photoPath != null && !photoPath.isEmpty()) { %>
                    <div style="margin-bottom:6px;">
                        <img src="<%= request.getContextPath() + photoPath %>" alt="药材图片" style="height:80px;">
                    </div>
                <% } %>
                <input type="file" name="photo" accept="image/*">
                <label><input type="checkbox" name="removePhoto"> 移除已有图片</label>
            </td>
        </tr>
    </table>
    <input type="submit" value="提交保存">
</form>
<br><a href="medicine_list.jsp">返回列表</a>
<script>
    (function() {
        const ctx = '<%=request.getContextPath()%>';
        const codeInput = document.getElementById('codeInput');
        const codeMsg = document.getElementById('codeMsg');
        let codeValid = true;
        const originalCode = '<%= code %>';

        codeInput.addEventListener('blur', () => {
            const val = codeInput.value.trim();
            if (!val) {
                codeMsg.textContent = '编号不能为空';
                codeValid = false;
                return;
            }
            fetch(ctx + '/api/medicine?op=check&code=' + encodeURIComponent(val))
                .then(resp => resp.json())
                .then(data => {
                    if (!data.success) {
                        codeMsg.textContent = data.message || '检查失败';
                        codeValid = false;
                        return;
                    }
                    const exists = data.exists;
                    if (exists && originalCode !== val) {
                        codeMsg.textContent = '编号已存在，请更换';
                        codeValid = false;
                    } else {
                        codeMsg.textContent = '';
                        codeValid = true;
                    }
                })
                .catch(err => {
                    codeMsg.textContent = '检查出错: ' + err;
                    codeValid = false;
                });
        });

        document.getElementById('editForm').addEventListener('submit', (e) => {
            if (!codeValid) {
                e.preventDefault();
                alert('请先通过编号唯一性校验');
            }
        });
    })();
</script>
</body>
</html>
