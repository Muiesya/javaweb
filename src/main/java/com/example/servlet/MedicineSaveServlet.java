package com.example.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;

@MultipartConfig
@WebServlet(name = "MedicineSaveServlet", urlPatterns = "/medicine/save")
public class MedicineSaveServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "87609215Bb@";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("id");
        boolean updating = idStr != null && !idStr.trim().isEmpty();
        Integer id = null;
        if (updating) {
            try {
                id = Integer.valueOf(idStr);
            } catch (NumberFormatException e) {
                redirectWithError(req, resp, "无效的ID", null);
                return;
            }
        }

        String code = req.getParameter("code");
        String name = req.getParameter("name");
        String alias = req.getParameter("alias");
        String origin = req.getParameter("origin");
        String growthEnvironment = req.getParameter("growth_environment");
        String tasteAndProperty = req.getParameter("taste_and_property");
        String mainFunction = req.getParameter("main_function");
        String dosageAndUsage = req.getParameter("dosage_and_usage");
        double price = parseDouble(req.getParameter("price"), 0);
        int stock = parseInt(req.getParameter("stock"), 0);
        String existingPhoto = req.getParameter("existingPhoto");
        boolean removePhoto = "on".equalsIgnoreCase(req.getParameter("removePhoto"));

        String photoPath = existingPhoto;
        Part photoPart = null;
        try {
            photoPart = req.getPart("photo");
        } catch (IllegalStateException ex) {
            redirectWithError(req, resp, "上传文件过大或请求不合法", id);
            return;
        }
        if (photoPart != null && photoPart.getSize() > 0) {
            photoPath = storePhoto(photoPart, req);
        }
        if (removePhoto) {
            photoPath = null;
        }

        String sqlInsert = "INSERT INTO medicine(code, name, alias, origin, growth_environment, taste_and_property, main_function, dosage_and_usage, price, stock, photo_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlUpdate = "UPDATE medicine SET code=?, name=?, alias=?, origin=?, growth_environment=?, taste_and_property=?, main_function=?, dosage_and_usage=?, price=?, stock=?, photo_path=? WHERE id=?";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            if (updating) {
                try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                    bindParams(ps, code, name, alias, origin, growthEnvironment, tasteAndProperty, mainFunction, dosageAndUsage, price, stock, photoPath);
                    ps.setInt(12, id);
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                    bindParams(ps, code, name, alias, origin, growthEnvironment, tasteAndProperty, mainFunction, dosageAndUsage, price, stock, photoPath);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            id = rs.getInt(1);
                        }
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            redirectWithError(req, resp, "保存失败：" + e.getMessage(), id);
            return;
        }

        String redirectId = id == null ? "" : ("&id=" + id);
        resp.sendRedirect(req.getContextPath() + "/medicine_edit.jsp?message=" + urlEncode("保存成功") + redirectId);
    }

    private void bindParams(PreparedStatement ps, String code, String name, String alias, String origin, String growthEnvironment, String tasteAndProperty, String mainFunction, String dosageAndUsage, double price, int stock, String photoPath) throws SQLException {
        ps.setString(1, code);
        ps.setString(2, name);
        ps.setString(3, alias);
        ps.setString(4, origin);
        ps.setString(5, growthEnvironment);
        ps.setString(6, tasteAndProperty);
        ps.setString(7, mainFunction);
        ps.setString(8, dosageAndUsage);
        ps.setDouble(9, price);
        ps.setInt(10, stock);
        ps.setString(11, photoPath);
    }

    private String storePhoto(Part photoPart, HttpServletRequest req) throws IOException {
        String submitted = photoPart.getSubmittedFileName();
        String ext = "";
        if (submitted != null && submitted.contains(".")) {
            ext = submitted.substring(submitted.lastIndexOf("."));
        }
        String filename = UUID.randomUUID() + ext;
        String uploadDir = req.getServletContext().getRealPath("/uploads/medicine");
        if (uploadDir == null) {
            uploadDir = System.getProperty("java.io.tmpdir");
        }
        Path dir = Paths.get(uploadDir);
        if (!Files.exists(dir)) {
            Files.createDirectories(dir);
        }
        Path target = dir.resolve(filename);
        photoPart.write(target.toString());
        return "/uploads/medicine/" + filename;
    }

    private void redirectWithError(HttpServletRequest req, HttpServletResponse resp, String msg, Integer id) throws IOException {
        String redirectId = id == null ? "" : ("&id=" + id);
        resp.sendRedirect(req.getContextPath() + "/medicine_edit.jsp?error=" + urlEncode(msg) + redirectId);
    }

    private String urlEncode(String val) {
        try {
            return URLEncoder.encode(val, "UTF-8");
        } catch (Exception e) {
            return val;
        }
    }

    private double parseDouble(String input, double defaultVal) {
        try {
            return Double.parseDouble(input);
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private int parseInt(String input, int defaultVal) {
        try {
            return Integer.parseInt(input);
        } catch (Exception e) {
            return defaultVal;
        }
    }
}
