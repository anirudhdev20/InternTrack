package com.interntrack.controller;

import com.interntrack.model.*;
import com.interntrack.service.*;
import com.interntrack.util.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/faculty")
public class FacultyController {

    private final UserService userService;
    private final InternshipService internshipService;
    private final ApplicationService applicationService;
    private final ProgressService progressService;
    private final DepartmentService departmentService;

    public FacultyController(UserService userService,
                             InternshipService internshipService,
                             ApplicationService applicationService,
                             ProgressService progressService,
                             DepartmentService departmentService) {
        this.userService = userService;
        this.internshipService = internshipService;
        this.applicationService = applicationService;
        this.progressService = progressService;
        this.departmentService = departmentService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        User faculty = SecurityUtils.getAuthenticatedUser();
        if (faculty == null) return "redirect:/login";

        long totalStudents = userService.countByRole(Role.STUDENT);
        long totalCompanies = userService.countByRole(Role.COMPANY);
        long totalListings = internshipService.findAll().size();
        long pendingReviews = internshipService.countByStatus(ReviewStatus.PENDING_REVIEW);
        long approvedListings = internshipService.countByStatus(ReviewStatus.APPROVED);
        long rejectedListings = internshipService.countByStatus(ReviewStatus.REJECTED);

        long totalApplications = applicationService.findAll().size();
        long selectedStudents = applicationService.countByStatus(ApplicationStatus.SELECTED);
        long ongoingInternships = progressService.countByStatus(CompletionStatus.IN_PROGRESS) +
                                  progressService.countByStatus(CompletionStatus.SUBMITTED);
        long completedInternships = progressService.countByStatus(CompletionStatus.VERIFIED);

        model.addAttribute("faculty", faculty);
        model.addAttribute("totalStudents", totalStudents);
        model.addAttribute("totalCompanies", totalCompanies);
        model.addAttribute("totalListings", totalListings);
        model.addAttribute("pendingReviews", pendingReviews);
        model.addAttribute("approvedListings", approvedListings);
        model.addAttribute("rejectedListings", rejectedListings);
        model.addAttribute("totalApplications", totalApplications);
        model.addAttribute("selectedStudents", selectedStudents);
        model.addAttribute("ongoingInternships", ongoingInternships);
        model.addAttribute("completedInternships", completedInternships);

        List<Internship> pendingQueue = internshipService.findByReviewStatus(ReviewStatus.PENDING_REVIEW);
        model.addAttribute("pendingQueue", pendingQueue);

        return "faculty/dashboard";
    }

    @GetMapping("/reviews")
    public String reviewQueue(Model model) {
        List<Internship> pending = internshipService.findByReviewStatus(ReviewStatus.PENDING_REVIEW);
        model.addAttribute("pendingListings", pending);
        return "faculty/reviews";
    }

    @GetMapping("/reviews/{id}")
    public String reviewDetail(@PathVariable("id") Long id, Model model) {
        Internship internship = internshipService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Internship not found: " + id));

        model.addAttribute("internship", internship);
        model.addAttribute("assessment", internship.getAssessment());

        return "faculty/review-detail";
    }

    @PostMapping("/reviews/{id}/decide")
    public String decideReview(@PathVariable("id") Long id,
                               @RequestParam("decision") String decision,
                               @RequestParam(value = "reason", required = false) String reason,
                               RedirectAttributes redirectAttributes) {
        User faculty = SecurityUtils.getAuthenticatedUser();
        if (faculty == null) return "redirect:/login";

        if ("REJECTED".equalsIgnoreCase(decision) && (reason == null || reason.trim().isEmpty())) {
            redirectAttributes.addFlashAttribute("errorMessage", "A rejection reason must be provided so the company can make revisions.");
            return "redirect:/faculty/reviews/" + id;
        }

        try {
            internshipService.reviewInternship(id, faculty, decision, reason);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Internship decision '" + decision + "' recorded successfully!");
            return "redirect:/faculty/reviews";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error saving decision: " + e.getMessage());
            return "redirect:/faculty/reviews/" + id;
        }
    }

    @GetMapping("/reviews/history")
    public String reviewHistory(Model model) {
        List<Internship> all = internshipService.findAll();
        List<Internship> reviewed = all.stream()
                .filter(i -> i.getReviewStatus() == ReviewStatus.APPROVED || i.getReviewStatus() == ReviewStatus.REJECTED)
                .toList();
        model.addAttribute("reviewedListings", reviewed);
        return "faculty/review-history";
    }

    @GetMapping("/students")
    public String monitorStudents(@RequestParam(value = "departmentId", required = false) Long departmentId,
                                  @RequestParam(value = "academicYear", required = false) String academicYear,
                                  Model model) {
        List<User> students = userService.findByRole(Role.STUDENT);

        if (departmentId != null) {
            students = students.stream()
                    .filter(s -> s.getDepartment() != null && s.getDepartment().getId().equals(departmentId))
                    .toList();
        }

        if (academicYear != null && !academicYear.trim().isEmpty()) {
            students = students.stream()
                    .filter(s -> s.getStudentProfile() != null && academicYear.equalsIgnoreCase(s.getStudentProfile().getAcademicYear()))
                    .toList();
        }

        model.addAttribute("students", students);
        model.addAttribute("departments", departmentService.findAll());
        model.addAttribute("selectedDeptId", departmentId);
        model.addAttribute("selectedYear", academicYear);

        return "faculty/students";
    }

    @GetMapping("/progress")
    public String progressMonitoring(Model model) {
        List<InternshipProgress> allProgress = progressService.findAll();
        model.addAttribute("progressList", allProgress);
        return "faculty/progress";
    }

    @PostMapping("/progress/{id}/verify")
    public String verifyCompletion(@PathVariable("id") Long progressId,
                                   @RequestParam("approved") boolean approved,
                                   @RequestParam(value = "remarks", required = false) String remarks,
                                   RedirectAttributes redirectAttributes) {
        User faculty = SecurityUtils.getAuthenticatedUser();
        if (faculty == null) return "redirect:/login";

        try {
            progressService.verifyCompletion(progressId, faculty, approved, remarks);
            redirectAttributes.addFlashAttribute("successMessage",
                    approved ? "Internship certificate verified successfully!" : "Internship certificate marked as rejected.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error verifying certificate: " + e.getMessage());
        }

        return "redirect:/faculty/progress";
    }

    @GetMapping("/reports")
    public String reports(Model model) {
        List<Application> allApps = applicationService.findAll();
        List<Internship> allInternships = internshipService.findAll();
        List<Department> departments = departmentService.findAll();

        // Department-wise application count
        Map<String, Long> deptApplications = departments.stream().collect(Collectors.toMap(
                Department::getDepartmentName,
                d -> allApps.stream().filter(a -> a.getStudent().getDepartment() != null && a.getStudent().getDepartment().getId().equals(d.getId())).count()
        ));

        // Company-wise postings
        Map<String, Long> companyPostings = allInternships.stream().collect(Collectors.groupingBy(
                i -> i.getCompany().getName(),
                Collectors.counting()
        ));

        // Recruitment distribution
        Map<String, Long> statusDistribution = allApps.stream().collect(Collectors.groupingBy(
                a -> a.getStatus().name(),
                Collectors.counting()
        ));

        model.addAttribute("deptApplications", deptApplications);
        model.addAttribute("companyPostings", companyPostings);
        model.addAttribute("statusDistribution", statusDistribution);
        model.addAttribute("allApps", allApps);

        return "faculty/reports";
    }
}
