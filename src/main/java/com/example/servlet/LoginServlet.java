package com.example.servlet;

import com.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class LoginServlet extends HttpServlet {
    private static final Map<String, String> USER_PASSWORDS = new HashMap<>();
    private static final Map<String, String> USER_ROLES = new HashMap<>();
    private static final Map<String, String> DISPLAY_NAMES = new HashMap<>();
    private static final Random RANDOM = new SecureRandom();

    static {
        USER_PASSWORDS.put("admin", "admin123");
        USER_ROLES.put("admin", "admin");
        DISPLAY_NAMES.put("admin", "系统管理员");

        USER_PASSWORDS.put("user", "user123");
        USER_ROLES.put("user", "user");
        DISPLAY_NAMES.put("user", "普通用户");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String captcha = generateCaptcha();
        req.getSession(true).setAttribute("captcha", captcha);
        req.setAttribute("captcha", captcha);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String account = req.getParameter("account");
        String password = req.getParameter("password");
        String captcha = req.getParameter("captcha");
        HttpSession session = req.getSession(true);
        String expectedCaptcha = (String) session.getAttribute("captcha");

        if (isEmpty(account) || isEmpty(password) || isEmpty(captcha)) {
            forwardWithError(req, resp, "账号、密码和验证码都不能为空。");
            return;
        }

        if (expectedCaptcha == null || !expectedCaptcha.equalsIgnoreCase(captcha.trim())) {
            forwardWithError(req, resp, "验证码错误，请重新输入。");
            return;
        }

        String storedPassword = USER_PASSWORDS.get(account);
        if (storedPassword == null || !storedPassword.equals(password)) {
            forwardWithError(req, resp, "账号或密码不正确。");
            return;
        }

        String role = USER_ROLES.getOrDefault(account, "user");
        String displayName = DISPLAY_NAMES.getOrDefault(account, account);
        User currentUser = new User(account, displayName, role);

        // refresh captcha for next page load
        session.setAttribute("captcha", generateCaptcha());
        session.setAttribute("currentUser", currentUser);

        if ("admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin.jsp");
        } else {
            resp.sendRedirect(req.getContextPath() + "/user.jsp");
        }
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String message) throws ServletException, IOException {
        String captcha = generateCaptcha();
        req.getSession(true).setAttribute("captcha", captcha);
        req.setAttribute("captcha", captcha);
        req.setAttribute("error", message);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String generateCaptcha() {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder builder = new StringBuilder(5);
        for (int i = 0; i < 5; i++) {
            int idx = RANDOM.nextInt(chars.length());
            builder.append(chars.charAt(idx));
        }
        return builder.toString();
    }
}
