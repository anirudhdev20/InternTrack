package com.interntrack.controller;

import com.interntrack.model.Role;
import com.interntrack.model.User;
import com.interntrack.service.DepartmentService;
import com.interntrack.service.InternshipService;
import com.interntrack.service.NotificationService;
import com.interntrack.service.UserService;
import com.interntrack.util.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class HomeController {

    private final UserService userService;
    private final DepartmentService departmentService;
    private final InternshipService internshipService;
    private final NotificationService notificationService;

    public HomeController(UserService userService,
                          DepartmentService departmentService,
                          InternshipService internshipService,
                          NotificationService notificationService) {
        this.userService = userService;
        this.departmentService = departmentService;
        this.internshipService = internshipService;
        this.notificationService = notificationService;
    }

    @GetMapping({"/", "/home"})
    public String home(Model model) {
        model.addAttribute("totalStudents", userService.countByRole(Role.STUDENT));
        model.addAttribute("totalCompanies", userService.countByRole(Role.COMPANY));
        model.addAttribute("totalInternships", internshipService.findAll().size());
        return "common/landing";
    }

    @GetMapping("/login")
    public String login(@RequestParam(value = "error", required = false) String error,
                        @RequestParam(value = "logout", required = false) String logout,
                        Model model) {
        if (error != null) {
            model.addAttribute("errorMessage", "Invalid email or password, or account is deactivated.");
        }
        if (logout != null) {
            model.addAttribute("successMessage", "You have been logged out successfully.");
        }
        return "common/login";
    }

    @GetMapping("/register")
    public String registerChoice() {
        return "common/register-choice";
    }

    @GetMapping("/register/student")
    public String studentRegisterForm(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        return "common/register-student";
    }

    @PostMapping("/register/student")
    public String handleStudentRegister(@RequestParam("name") String name,
                                        @RequestParam("email") String email,
                                        @RequestParam("password") String password,
                                        @RequestParam(value = "departmentId", required = false) Long departmentId,
                                        @RequestParam("academicYear") String academicYear,
                                        @RequestParam(value = "phone", required = false) String phone,
                                        @RequestParam(value = "skills", required = false) String skills,
                                        RedirectAttributes redirectAttributes) {
        try {
            userService.registerStudent(name, email, password, departmentId, academicYear, phone, skills);
            redirectAttributes.addFlashAttribute("successMessage", "Student registration successful! You can now log in.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/register/student";
        }
    }

    @GetMapping("/register/company")
    public String companyRegisterForm() {
        return "common/register-company";
    }

    @PostMapping("/register/company")
    public String handleCompanyRegister(@RequestParam("name") String name,
                                        @RequestParam("email") String email,
                                        @RequestParam("password") String password,
                                        @RequestParam("companyName") String companyName,
                                        @RequestParam(value = "website", required = false) String website,
                                        @RequestParam(value = "description", required = false) String description,
                                        @RequestParam(value = "contactNumber", required = false) String contactNumber,
                                        RedirectAttributes redirectAttributes) {
        try {
            userService.registerCompany(name, email, password, companyName, website, description, contactNumber);
            redirectAttributes.addFlashAttribute("successMessage", "Company registration successful! You can now log in.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/register/company";
        }
    }

    @GetMapping("/notifications")
    public String notifications(Model model) {
        User user = SecurityUtils.getAuthenticatedUser();
        if (user != null) {
            model.addAttribute("notifications", notificationService.getNotificationsForUser(user.getId()));
            notificationService.markAllAsRead(user.getId());
        }
        return "common/notifications";
    }

    @GetMapping("/error/access-denied")
    public String accessDenied() {
        return "common/access-denied";
    }
}
