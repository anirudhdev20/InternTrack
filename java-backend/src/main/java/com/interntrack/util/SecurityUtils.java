package com.interntrack.util;

import com.interntrack.model.User;
import com.interntrack.security.CustomUserDetails;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class SecurityUtils {

    public static User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            return ((CustomUserDetails) authentication.getPrincipal()).getUser();
        }
        return null;
    }

    public static Long getAuthenticatedUserId() {
        User user = getAuthenticatedUser();
        return user != null ? user.getId() : null;
    }
}
