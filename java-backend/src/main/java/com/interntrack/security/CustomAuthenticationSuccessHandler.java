package com.interntrack.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Collection;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        for (GrantedAuthority authority : authorities) {
            String role = authority.getAuthority();
            if ("ROLE_STUDENT".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
                return;
            } else if ("ROLE_COMPANY".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/company/dashboard");
                return;
            } else if ("ROLE_FACULTY".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
                return;
            } else if ("ROLE_ADMIN".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/");
    }
}
