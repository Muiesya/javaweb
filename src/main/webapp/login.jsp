<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    String captchaValue = (String) request.getAttribute("captcha");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户登陆</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        .container { width: 400px; margin: 60px auto; padding: 24px; background: #fff; border: 1px solid #ddd; border-radius: 4px; }
        .field { margin-bottom: 16px; }
        label { display: block; margin-bottom: 6px; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; box-sizing: border-box; }
        .error { color: #d93025; margin-bottom: 12px; }
        .captcha-box { display: flex; align-items: center; gap: 8px; }
        .captcha-text { font-weight: bold; background: #eef3ff; padding: 8px 12px; border: 1px dashed #4a63e7; letter-spacing: 2px; }
        button { padding: 8px 16px; background: #4a63e7; color: #fff; border: none; border-radius: 3px; cursor: pointer; }
        button:hover { background: #394fd2; }
    </style>
    <script>
        function validateForm() {
            const account = document.getElementById('account').value.trim();
            const password = document.getElementById('password').value.trim();
            const captcha = document.getElementById('captcha').value.trim();
            if (!account || !password || !captcha) {
                alert('账号、密码、验证码均不能为空');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="container">
    <h2>登陆</h2>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>
    <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return validateForm()">
        <div class="field">
            <label for="account">账号</label>
            <input type="text" id="account" name="account" value="${param.account}" required>
        </div>
        <div class="field">
            <label for="password">密码</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="field">
            <label for="captcha">验证码</label>
            <div class="captcha-box">
                <input type="text" id="captcha" name="captcha" maxlength="5" required>
                <div class="captcha-text"><%= captchaValue == null ? "" : captchaValue %></div>
                <button type="button" onclick="window.location.reload()">刷新</button>
            </div>
        </div>
        <button type="submit">登陆</button>
    </form>
</div>
</body>
</html>
