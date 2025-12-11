package com.example.model;

public class Medicine {
    private int id;
    private String code;
    private String name;
    private String alias;
    private double price;
    private int stock;
    private String growthEnvironment;

    public Medicine() {
    }

    public Medicine(int id, String code, String name, String alias, double price, int stock, String growthEnvironment) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.alias = alias;
        this.price = price;
        this.stock = stock;
        this.growthEnvironment = growthEnvironment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getGrowthEnvironment() {
        return growthEnvironment;
    }

    public void setGrowthEnvironment(String growthEnvironment) {
        this.growthEnvironment = growthEnvironment;
    }
}
