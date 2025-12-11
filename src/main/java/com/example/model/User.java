package com.example.model;

import java.io.Serializable;

/**
 * Simple user model stored in session after login.
 */
public class User implements Serializable {
    private final String username;
    private final String displayName;
    private final String role;

    public User(String username, String displayName, String role) {
        this.username = username;
        this.displayName = displayName;
        this.role = role;
    }

    public String getUsername() {
        return username;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getRole() {
        return role;
    }
}
