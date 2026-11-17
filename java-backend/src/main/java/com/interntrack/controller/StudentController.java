package com.interntrack.controller;

import com.interntrack.model.*;
import com.interntrack.service.*;
import com.interntrack.util.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentController {

    private final UserService userService;
    private final InternshipService internshipService;
    private final ApplicationService applicationService;
    private final ProgressService progressService;
    private final FileStorageService fileStorageService;
    private final DepartmentService departmentService;

    public StudentController(UserService userService,
                             InternshipService internshipService,
                             ApplicationService applicationService,
                             ProgressService progressService,
                             FileStorageService fileStorageService,
                             DepartmentService departmentService) {
        this.userService = userService;
        this.internshipService = internshipService;
        this.applicationService = applicationService;
        this.progressService = progressService;
        this.fileStorageService = fileStorageService;
        this.departmentService = departmentService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        User student = SecurityUtils.getAuthenticatedUser();
        if (student == null) return "redirect:/login";

        long availableInternships = internshipService.countByStatus(ReviewStatus.APPROVED);
        long totalApplied = applicationService.countByStudent(student);
        long underReview = applicationService.countByStudentAndStatus(student, ApplicationStatus.UNDER_REVIEW);
        long shortlisted = applicationService.countByStudentAndStatus(student, ApplicationStatus.SHORTLISTED);
        long selected = applicationService.countByStudentAndStatus(student, ApplicationStatus.SELECTED);
        long rejected = applicationService.countByStudentAndStatus(student, ApplicationStatus.REJECTED);

        model.addAttribute("student", student);
        model.addAttribute("availableInternships", availableInternships);
        model.addAttribute("totalApplied", totalApplied);
        model.addAttribute("underReview", underReview);
        model.addAttribute("shortlisted", shortlisted);
        model.addAttribute("selected", selected);
        model.addAttribute("rejected", rejected);

        List<Application> recentApplications = applicationService.findByStudent(student);
        model.addAttribute("recentApplications", recentApplications);

        return "student/dashboard";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        User student = SecurityUtils.getAuthenticatedUser();
        if (student == null) return "redirect:/login";

        User fullUser = userService.findById(student.getId()).orElse(student);
        model.addAttribute("user", fullUser);
        model.addAttribute("profile", fullUser.getStudentProfile());
        model.addAttribute("departments", departmentService.findAll());

        return "student/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@RequestParam("academicYear") String academicYear,
                                @RequestParam("skills") String skills,
                                @RequestParam("phone") String phone,
                                @RequestParam(value = "resumeFile", required = false) MultipartFile resumeFile,
                                RedirectAttributes redirectAttributes) {
        User student = SecurityUtils.getAuthenticatedUser();
        if (student == null) return "redirect:/login";

        try {
            String resumePath = null;
            if (resumeFile != null && !resumeFile.isEmpty()) {
                resumePath = fileStorageService.storeFile(resumeFile, "resumes");
            }

            userService.updateStudentProfile(student.getId(), academicYear, skills, phone, resumePath);
            redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update profile: " + e.getMessage());
        }

        return "redirect:/student/profile";
    }

    @GetMapping("/internships")
    public String browseInternships(@RequestParam(value = "title", required = false) String title,
                                    @RequestParam(value = "company", required = false) String company,
                                    @RequestParam(value = "skills", required = false) String skills,
                                    @RequestParam(value = "location", required = false) String location,
                                    @RequestParam(value = "workMode", required = false) String workModeStr,
                                    @RequestParam(value = "department", required = false) String department,
                                    Model model) {
        WorkMode workMode = null;
        if (workModeStr != null && !workModeStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(workModeStr)) {
            try {
                workMode = WorkMode.valueOf(workModeStr.toUpperCase());
            } catch (Exception ignored) {
            }
        }

        List<Internship> internships = internshipService.searchApprovedInternships(
                title, company, skills, location, workMode, department
        );

        model.addAttribute("internships", internships);
        model.addAttribute("titleQuery", title);
        model.addAttribute("companyQuery", company);
        model.addAttribute("skillsQuery", skills);
        model.addAttribute("locationQuery", location);
        model.addAttribute("workModeQuery", workModeStr);
        model.addAttribute("deptQuery", department);
        model.addAttribute("departments", departmentService.findAll());

        return "student/internships";
    }

    @GetMapping("/internships/{id}")
    public String viewInternship(@PathVariable("id") Long id, Model model) {
        User student = SecurityUtils.getAuthenticatedUser();
        Internship internship = internshipService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Internship not found: " + id));

        boolean alreadyApplied = false;
        if (student != null) {
            List<Application> apps = applicationService.findByStudent(student);
            alreadyApplied = apps.stream().anyMatch(a -> a.getInternship().getId().equals(id));
        }

        model.addAttribute("internship", internship);
        model.addAttribute("alreadyApplied", alreadyApplied);

        return "student/internship-details";
    }

    @PostMapping("/apply/{id}")
    public String apply(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        User student = SecurityUtils.getAuthenticatedUser();
        if (student == null) return "redirect:/login";

        try {
            applicationService.apply(id, student);
            redirectAttributes.addFlashAttribute("successMessage", "Application submitted successfully! You can track your progress on the dashboard.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/student/applications";
    }

    @GetMapping("/applications")
    public String myApplications(Model model) {
        User student = SecurityUtils.getAuthenticatedUser();
        if (student == null) return "redirect:/login";

        List<Application> applications = applicationService.findByStudent(student);
        model.addAttribute("applications", applications);

        return "student/applications";
    }

    @GetMapping("/progress")
    public String progressView(Model model) {
        User student = SecurityUtils.getAuthenticatedUser();
        if (student == null) return "redirect:/login";

        List<Application> applications = applicationService.findByStudent(student);
        // Filter only selected applications for progress reporting
        List<Application> selectedApplications = applications.stream()
                .filter(a -> a.getStatus() == ApplicationStatus.SELECTED)
                .toList();

        model.addAttribute("selectedApplications", selectedApplications);
        return "student/progress";
    }

    @PostMapping("/progress")
    public String submitProgress(@RequestParam("applicationId") Long applicationId,
                                 @RequestParam("progressDescription") String description,
                                 @RequestParam(value = "certificateFile", required = false) MultipartFile certificateFile,
                                 RedirectAttributes redirectAttributes) {
        User student = SecurityUtils.getAuthenticatedUser();
        if (student == null) return "redirect:/login";

        try {
            String certPath = null;
            if (certificateFile != null && !certificateFile.isEmpty()) {
                certPath = fileStorageService.storeFile(certificateFile, "certificates");
            }

            progressService.submitProgress(applicationId, student, description, certPath);
            redirectAttributes.addFlashAttribute("successMessage", "Internship progress and completion record submitted successfully for faculty verification!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error submitting progress: " + e.getMessage());
        }

        return "redirect:/student/progress";
    }
}
