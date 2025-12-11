package com.example.dao;

import com.example.model.Medicine;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO {
    private static final String JDBC_URL = "jdbc:mysql://127.0.0.1:3306/DBcm?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "87609215Bb@";

    private static final List<Medicine> SAMPLE_MEDICINES = new ArrayList<>();

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // 为了让示例在无数据库环境下也能运行，这里仅记录而不抛出致命错误
            System.err.println("警告: 未找到 MySQL 驱动，使用演示数据。" + e.getMessage());
        }

        Medicine demo1 = new Medicine();
        demo1.setId(1);
        demo1.setCode("M001");
        demo1.setName("人参");
        demo1.setAlias("参");
        demo1.setPrice(199.0);
        demo1.setStock(50);
        demo1.setGrowthEnvironment("东北山林");
        SAMPLE_MEDICINES.add(demo1);

        Medicine demo2 = new Medicine();
        demo2.setId(2);
        demo2.setCode("M002");
        demo2.setName("枸杞");
        demo2.setAlias("宁夏枸杞");
        demo2.setPrice(39.9);
        demo2.setStock(200);
        demo2.setGrowthEnvironment("宁夏");
        SAMPLE_MEDICINES.add(demo2);
    }

    public List<Medicine> findAll() throws SQLException {
        String sql = "SELECT id, code, name, alias, price, stock, growth_environment FROM medicine ORDER BY id DESC";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Medicine> list = new ArrayList<>();
            while (rs.next()) {
                Medicine medicine = mapRow(rs);
                list.add(medicine);
            }
            return list;
        } catch (SQLException e) {
            System.err.println("读取数据库失败，返回演示药材数据: " + e.getMessage());
            return new ArrayList<>(SAMPLE_MEDICINES);
        }
    }

    public Medicine findById(int id) throws SQLException {
        String sql = "SELECT id, code, name, alias, price, stock, growth_environment FROM medicine WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            for (Medicine medicine : SAMPLE_MEDICINES) {
                if (medicine.getId() == id) {
                    return medicine;
                }
            }
            System.err.println("读取数据库失败且未找到演示药材: " + e.getMessage());
        }
        return null;
    }

    private Medicine mapRow(ResultSet rs) throws SQLException {
        Medicine medicine = new Medicine();
        medicine.setId(rs.getInt("id"));
        medicine.setCode(rs.getString("code"));
        medicine.setName(rs.getString("name"));
        medicine.setAlias(rs.getString("alias"));
        try {
            medicine.setPrice(rs.getDouble("price"));
        } catch (SQLException ignored) {
            medicine.setPrice(0);
        }
        try {
            medicine.setStock(rs.getInt("stock"));
        } catch (SQLException ignored) {
            medicine.setStock(0);
        }
        try {
            medicine.setGrowthEnvironment(rs.getString("growth_environment"));
        } catch (SQLException ignored) {
            medicine.setGrowthEnvironment(null);
        }
        return medicine;
    }
}
