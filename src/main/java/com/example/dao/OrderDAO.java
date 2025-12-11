package com.example.dao;

import com.example.model.Order;
import com.example.model.OrderItem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class OrderDAO {
    private static final String JDBC_URL = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "87609215Bb@";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("无法加载MySQL驱动: " + e.getMessage());
        }
    }

    public void saveOrder(Order order) throws SQLException {
        String orderSql = "INSERT INTO orders(order_id, user_name, address, total_amount, order_time) VALUES(?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items(order_id, medicine_id, quantity, current_price) VALUES(?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
             PreparedStatement orderStmt = conn.prepareStatement(orderSql);
             PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
            conn.setAutoCommit(false);

            orderStmt.setString(1, order.getOrderId());
            orderStmt.setString(2, order.getUserName());
            orderStmt.setString(3, order.getAddress());
            orderStmt.setDouble(4, order.getTotalAmount());
            orderStmt.setTimestamp(5, order.getOrderTime());
            orderStmt.executeUpdate();

            for (OrderItem item : order.getItems()) {
                itemStmt.setString(1, order.getOrderId());
                itemStmt.setInt(2, item.getMedicineId());
                itemStmt.setInt(3, item.getQuantity());
                itemStmt.setDouble(4, item.getCurrentPrice());
                itemStmt.addBatch();
            }
            itemStmt.executeBatch();

            conn.commit();
        }
    }
}
