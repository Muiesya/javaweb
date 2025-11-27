package com.example.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Ensures all requests/responses use UTF-8 to support Chinese characters.
 */
public class EncodingFilter implements Filter {
    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) {
        String configEncoding = filterConfig.getInitParameter("encoding");
        if (configEncoding != null && !configEncoding.isEmpty()) {
            encoding = configEncoding;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);
        if (response instanceof HttpServletResponse) {
            ((HttpServletResponse) response).setHeader("Content-Type", "text/html; charset=" + encoding);
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // no-op
    }
}
