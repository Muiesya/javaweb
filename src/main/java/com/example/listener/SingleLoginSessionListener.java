package com.example.listener;

import com.example.model.User;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeEvent;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Ensures a single active session per username. When the same user logs in
 * again, the previous session is invalidated automatically.
 */
public class SingleLoginSessionListener implements HttpSessionAttributeListener, HttpSessionListener {
    private static final Map<String, HttpSession> SESSION_BY_USER = new ConcurrentHashMap<>();

    @Override
    public void attributeAdded(HttpSessionAttributeEvent event) {
        handleUserChange(event);
    }

    @Override
    public void attributeReplaced(HttpSessionAttributeEvent event) {
        handleUserChange(event);
    }

    @Override
    public void attributeRemoved(HttpSessionAttributeEvent event) {
        if ("currentUser".equals(event.getName())) {
            User removed = (User) event.getValue();
            if (removed != null) {
                SESSION_BY_USER.remove(removed.getUsername());
            }
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        SESSION_BY_USER.entrySet().removeIf(entry -> entry.getValue().getId().equals(session.getId()));
    }

    private void handleUserChange(HttpSessionAttributeEvent event) {
        if (!"currentUser".equals(event.getName())) {
            return;
        }
        User user = (User) event.getValue();
        if (user == null) {
            return;
        }
        HttpSession newSession = event.getSession();
        HttpSession oldSession = SESSION_BY_USER.put(user.getUsername(), newSession);
        if (oldSession != null && !oldSession.getId().equals(newSession.getId())) {
            try {
                oldSession.invalidate();
            } catch (IllegalStateException ignored) {
                // session may already be invalidated
            }
        }
    }
}
