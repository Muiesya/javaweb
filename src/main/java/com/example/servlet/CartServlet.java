package com.example.servlet;

import com.example.dao.MedicineDAO;
import com.example.dao.OrderDAO;
import com.example.model.Medicine;
import com.example.model.Order;
import com.example.model.OrderItem;
import com.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "CartServlet", urlPatterns = "/cart")
public class CartServlet extends HttpServlet {
    private final MedicineDAO medicineDAO = new MedicineDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            handleAddToCart(request, response);
            return;
        }
        HttpSession session = request.getSession();
        request.setAttribute("cartItems", getCart(session));
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            handleAddToCart(request, response);
        } else if ("checkout".equalsIgnoreCase(action)) {
            handleCheckout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
        }
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String quantityStr = request.getParameter("quantity");
        int medicineId;
        int quantity;
        try {
            medicineId = Integer.parseInt(idStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "参数错误，无法加入购物车。");
            request.getRequestDispatcher("/mall.jsp").forward(request, response);
            return;
        }
        if (quantity <= 0) {
            quantity = 1;
        }

        Medicine medicine;
        try {
            medicine = medicineDAO.findById(medicineId);
        } catch (SQLException e) {
            getServletContext().log("查询药材失败", e);
            request.setAttribute("error", "读取药材信息失败，稍后再试。");
            request.getRequestDispatcher("/mall.jsp").forward(request, response);
            return;
        }
        if (medicine == null) {
            request.setAttribute("error", "未找到指定的药材。");
            request.getRequestDispatcher("/mall.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        List<OrderItem> cart = getCart(session);
        boolean merged = false;
        for (OrderItem item : cart) {
            if (item.getMedicineId() == medicineId) {
                item.setQuantity(item.getQuantity() + quantity);
                merged = true;
                break;
            }
        }
        if (!merged) {
            cart.add(new OrderItem(0, null, medicineId, medicine.getName(), quantity, medicine.getPrice()));
        }
        session.setAttribute("shoppingCart", cart);
        response.sendRedirect(request.getContextPath() + "/mall.jsp");
    }

    private void handleCheckout(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        List<OrderItem> cart = getCart(session);
        if (cart.isEmpty()) {
            request.setAttribute("cartError", "购物车为空，无法结算。");
            request.setAttribute("cartItems", cart);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }

        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("cartError", "请填写收货地址。");
            request.setAttribute("cartItems", cart);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }

        String userName = "游客";
        Object userObj = session.getAttribute("currentUser");
        if (userObj instanceof User) {
            User user = (User) userObj;
            userName = user.getDisplayName() + " (" + user.getUsername() + ")";
        }

        double total = 0;
        for (OrderItem item : cart) {
            total += item.getSubTotal();
        }

        String orderId = generateOrderId();
        Order order = new Order(orderId, userName, address.trim(), total, new Timestamp(System.currentTimeMillis()), new ArrayList<>(cart));

        try {
            orderDAO.saveOrder(order);
        } catch (SQLException e) {
            // 为了让示例在无数据库环境下也能跑通，这里记录错误但继续显示成功页面
            getServletContext().log("保存订单失败，使用演示流程继续", e);
            request.setAttribute("orderWarning", "订单已生成用于演示，未写入数据库: " + e.getMessage());
        }

        session.removeAttribute("shoppingCart");
        request.setAttribute("orderId", orderId);
        request.setAttribute("totalAmount", total);
        request.getRequestDispatcher("/order_success.jsp").forward(request, response);
    }

    @SuppressWarnings("unchecked")
    private List<OrderItem> getCart(HttpSession session) {
        Object cartObj = session.getAttribute("shoppingCart");
        if (cartObj instanceof List) {
            return (List<OrderItem>) cartObj;
        }
        List<OrderItem> newCart = new ArrayList<>();
        session.setAttribute("shoppingCart", newCart);
        return newCart;
    }

    private String generateOrderId() {
        return "ORD-" + UUID.randomUUID().toString().replace("-", "").substring(0, 12).toUpperCase();
    }
}
