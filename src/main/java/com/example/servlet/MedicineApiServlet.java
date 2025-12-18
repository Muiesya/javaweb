package com.example.servlet;

import com.example.dao.MedicineDAO;
import com.example.model.Medicine;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "MedicineApiServlet", urlPatterns = "/api/medicine")
public class MedicineApiServlet extends HttpServlet {
    private final MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String op = req.getParameter("op");
        if (op == null || op.isEmpty() || "search".equalsIgnoreCase(op)) {
            handleSearch(req, resp);
            return;
        }
        if ("check".equalsIgnoreCase(op)) {
            handleCheck(req, resp);
            return;
        }
        writeError(resp, "不支持的操作");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String op = req.getParameter("op");
        if ("delete".equalsIgnoreCase(op)) {
            handleDelete(req, resp);
            return;
        }
        writeError(resp, "不支持的操作");
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        try (PrintWriter writer = resp.getWriter()) {
            List<Medicine> medicines = medicineDAO.search(keyword);
            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,\"data\":");
            json.append("[");
            for (int i = 0; i < medicines.size(); i++) {
                Medicine m = medicines.get(i);
                if (i > 0) {
                    json.append(',');
                }
                json.append('{')
                        .append("\"id\":").append(m.getId()).append(',')
                        .append("\"code\":\"").append(escape(m.getCode())).append("\",")
                        .append("\"name\":\"").append(escape(m.getName())).append("\",")
                        .append("\"alias\":\"").append(escape(m.getAlias())).append("\",")
                        .append("\"price\":").append(m.getPrice()).append(',')
                        .append("\"stock\":").append(m.getStock()).append(',')
                        .append("\"mainFunction\":\"").append(escape(m.getMainFunction())).append("\"")
                        .append('}');
            }
            json.append("]}");
            writer.write(json.toString());
        } catch (SQLException e) {
            getServletContext().log("搜索药材失败", e);
            writeError(resp, "搜索失败: " + e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        try (PrintWriter writer = resp.getWriter()) {
            int id = Integer.parseInt(idStr);
            boolean success = medicineDAO.deleteById(id);
            writer.write("{\"success\":" + success + "}");
        } catch (NumberFormatException e) {
            writeError(resp, "无效的ID");
        } catch (SQLException e) {
            getServletContext().log("删除药材失败", e);
            writeError(resp, "删除失败: " + e.getMessage());
        }
    }

    private void handleCheck(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            writeError(resp, "缺少药材编号");
            return;
        }
        try (PrintWriter writer = resp.getWriter()) {
            boolean exists = medicineDAO.existsByCode(code.trim());
            writer.write("{\"success\":true,\"exists\":" + exists + "}");
        } catch (SQLException e) {
            getServletContext().log("检查药材编号失败", e);
            writeError(resp, "检查失败: " + e.getMessage());
        }
    }

    private void writeError(HttpServletResponse resp, String message) throws IOException {
        try (PrintWriter writer = resp.getWriter()) {
            writer.write("{\"success\":false,\"message\":\"");
            writer.write(escape(message));
            writer.write("\"}");
        }
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
