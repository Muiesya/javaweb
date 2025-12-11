package com.example.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private String orderId;
    private String userName;
    private String address;
    private double totalAmount;
    private Timestamp orderTime;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {
    }

    public Order(String orderId, String userName, String address, double totalAmount, Timestamp orderTime, List<OrderItem> items) {
        this.orderId = orderId;
        this.userName = userName;
        this.address = address;
        this.totalAmount = totalAmount;
        this.orderTime = orderTime;
        if (items != null) {
            this.items = items;
        }
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Timestamp getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(Timestamp orderTime) {
        this.orderTime = orderTime;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
}
