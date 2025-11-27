package com.example.servlet;

import com.example.model.CartItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = "/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String fallbackName = request.getParameter("fallbackName");
        String fallbackPriceStr = request.getParameter("fallbackPrice");
        String quantityStr = request.getParameter("quantity");

        int herbId;
        try {
            herbId = Integer.parseInt(id);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的药材编号");
            return;
        }

        double price = 0;
        int quantity = 0;

        try {
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "数量格式不正确");
            return;
        }

        if (fallbackPriceStr != null) {
            try {
                price = Double.parseDouble(fallbackPriceStr);
            } catch (NumberFormatException ignored) {
                price = 0;
            }
        }

        String name = fallbackName != null ? fallbackName : "";

        // 从数据库读取药材的最新名称和价格信息
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8",
                "root",
                "87609215Bb@"
        );
             PreparedStatement pstmt = conn.prepareStatement("SELECT name, price FROM medicine WHERE id = ?")) {
            pstmt.setInt(1, herbId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String dbName = rs.getString("name");
                    if (dbName != null) {
                        name = dbName;
                    }
                    try {
                        price = rs.getDouble("price");
                    } catch (SQLException ignored) {
                        // 如果字段不存在或读取失败则保持回退价格
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (name == null || name.isEmpty()) {
            name = request.getParameter("name");
        }

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        boolean found = false;
        for (CartItem item : cart) {
            if (item.getId().equals(id)) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }

        if (!found) {
            cart.add(new CartItem(id, name, price, quantity));
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cartDetail.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("cart") == null) {
            session.setAttribute("cart", new ArrayList<CartItem>());
        }
        request.getRequestDispatcher("cartDetail.jsp").forward(request, response);
    }
}
