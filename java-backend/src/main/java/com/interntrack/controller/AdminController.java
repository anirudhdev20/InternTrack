package com.interntrack.controller;

import com.interntrack.model.*;
import com.interntrack.service.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserService userService;
    private final DepartmentService departmentService;
    private final InternshipService internshipService;
    private final ApplicationService applicationService;
    private final AssessmentService assessmentService;

    public AdminController(UserService userService,
                           DepartmentService departmentService,
                           InternshipService internshipService,
                           ApplicationService applicationService,
                           AssessmentService assessmentService) {
        this.userService = userService;
        this.departmentService = departmentService;
        this.internshipService = internshipService;
        this.applicationService = applicationService;
        this.assessmentService = assessmentService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        long totalUsers = userService.findAll().size();
        long totalStudents = userService.countByRole(Role.STUDENT);
        long totalCompanies = userService.countByRole(Role.COMPANY);
        long totalFaculty = userService.countByRole(Role.FACULTY);
        long totalInternships = internshipService.findAll().size();
        long totalApplications = applicationService.findAll().size();
        boolean pythonHealthy = assessmentService.isServiceHealthy();

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalStudents", totalStudents);
        model.addAttribute("totalCompanies", totalCompanies);
        model.addAttribute("totalFaculty", totalFaculty);
        model.addAttribute("totalInternships", totalInternships);
        model.addAttribute("totalApplications", totalApplications);
        model.addAttribute("pythonHealthy", pythonHealthy);

        List<User> recentUsers = userService.findAll();
        if (recentUsers.size() > 8) {
            recentUsers = recentUsers.subList(recentUsers.size() - 8, recentUsers.size());
        }
        model.addAttribute("recentUsers", recentUsers);

        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String userList(@RequestParam(value = "role", required = false) String roleStr, Model model) {
        List<User> users;
        if (roleStr != null && !roleStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleStr)) {
            try {
                Role role = Role.valueOf(roleStr.toUpperCase());
                users = userService.findByRole(role);
            } catch (Exception e) {
                users = userService.findAll();
            }
        } else {
            users = userService.findAll();
        }

        model.addAttribute("users", users);
        model.addAttribute("selectedRole", roleStr);
        return "admin/users";
    }

    @PostMapping("/users/{id}/toggle")
    public String toggleUserStatus(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            boolean active = userService.toggleUserStatus(id);
            redirectAttributes.addFlashAttribute("successMessage",
                    "User account " + (active ? "activated" : "deactivated") + " successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error toggling account: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/departments")
    public String manageDepartments(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        return "admin/departments";
    }

    @PostMapping("/departments")
    public String createDepartment(@RequestParam("departmentName") String departmentName,
                                   RedirectAttributes redirectAttributes) {
        try {
            departmentService.save(departmentName);
            redirectAttributes.addFlashAttribute("successMessage", "Department created successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/departments";
    }

    @GetMapping("/internships")
    public String viewAllInternships(Model model) {
        model.addAttribute("internships", internshipService.findAll());
        return "admin/internships";
    }

    @GetMapping("/applications")
    public String viewAllApplications(Model model) {
        model.addAttribute("applications", applicationService.findAll());
        return "admin/applications";
    }
}
