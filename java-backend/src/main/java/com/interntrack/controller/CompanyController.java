package com.interntrack.controller;

import com.interntrack.model.*;
import com.interntrack.service.ApplicationService;
import com.interntrack.service.DepartmentService;
import com.interntrack.service.InternshipService;
import com.interntrack.service.UserService;
import com.interntrack.util.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/company")
public class CompanyController {

    private final UserService userService;
    private final InternshipService internshipService;
    private final ApplicationService applicationService;
    private final DepartmentService departmentService;

    public CompanyController(UserService userService,
                             InternshipService internshipService,
                             ApplicationService applicationService,
                             DepartmentService departmentService) {
        this.userService = userService;
        this.internshipService = internshipService;
        this.applicationService = applicationService;
        this.departmentService = departmentService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        long totalPosted = internshipService.countByCompany(company);
        long pendingReviews = internshipService.countByCompanyAndStatus(company, ReviewStatus.PENDING_REVIEW);
        long approved = internshipService.countByCompanyAndStatus(company, ReviewStatus.APPROVED);
        long rejected = internshipService.countByCompanyAndStatus(company, ReviewStatus.REJECTED);

        long totalApplicants = applicationService.countByCompanyId(company.getId());
        long shortlisted = applicationService.countByCompanyIdAndStatus(company.getId(), ApplicationStatus.SHORTLISTED);
        long selected = applicationService.countByCompanyIdAndStatus(company.getId(), ApplicationStatus.SELECTED);

        model.addAttribute("company", company);
        model.addAttribute("totalPosted", totalPosted);
        model.addAttribute("pendingReviews", pendingReviews);
        model.addAttribute("approved", approved);
        model.addAttribute("rejected", rejected);
        model.addAttribute("totalApplicants", totalApplicants);
        model.addAttribute("shortlisted", shortlisted);
        model.addAttribute("selected", selected);

        List<Application> recentApplicants = applicationService.findByCompanyId(company.getId());
        model.addAttribute("recentApplicants", recentApplicants);

        return "company/dashboard";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        User fullUser = userService.findById(company.getId()).orElse(company);
        model.addAttribute("user", fullUser);
        model.addAttribute("profile", fullUser.getCompanyProfile());

        return "company/profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@RequestParam("companyName") String companyName,
                                @RequestParam("website") String website,
                                @RequestParam("description") String description,
                                @RequestParam("contactNumber") String contactNumber,
                                RedirectAttributes redirectAttributes) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        try {
            userService.updateCompanyProfile(company.getId(), companyName, website, description, contactNumber);
            redirectAttributes.addFlashAttribute("successMessage", "Company profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating profile: " + e.getMessage());
        }

        return "redirect:/company/profile";
    }

    @GetMapping("/internships")
    public String myInternships(Model model) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        List<Internship> internships = internshipService.findByCompany(company);
        model.addAttribute("internships", internships);

        return "company/internships";
    }

    @GetMapping("/internships/create")
    public String createInternshipForm(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        return "company/internship-create";
    }

    @PostMapping("/internships/create")
    public String handleCreateInternship(@ModelAttribute Internship internship,
                                         @RequestParam("deadlineStr") String deadlineStr,
                                         RedirectAttributes redirectAttributes) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        try {
            if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
                internship.setDeadline(LocalDate.parse(deadlineStr.trim()));
            }

            Internship saved = internshipService.createInternship(internship, company);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Internship '" + saved.getTitle() + "' submitted successfully! Completeness was assessed by the Python service and the listing is now pending faculty review.");
            return "redirect:/company/internships";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to create internship: " + e.getMessage());
            return "redirect:/company/internships/create";
        }
    }

    @GetMapping("/internships/edit/{id}")
    public String editInternshipForm(@PathVariable("id") Long id, Model model) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        Internship internship = internshipService.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Internship not found: " + id));

        if (!internship.getCompany().getId().equals(company.getId())) {
            throw new SecurityException("Unauthorized access to modify another company's listing.");
        }

        model.addAttribute("internship", internship);
        model.addAttribute("departments", departmentService.findAll());

        return "company/internship-edit";
    }

    @PostMapping("/internships/edit/{id}")
    public String handleEditInternship(@PathVariable("id") Long id,
                                       @ModelAttribute Internship updated,
                                       @RequestParam(value = "deadlineStr", required = false) String deadlineStr,
                                       RedirectAttributes redirectAttributes) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        try {
            if (deadlineStr != null && !deadlineStr.trim().isEmpty()) {
                updated.setDeadline(LocalDate.parse(deadlineStr.trim()));
            }

            internshipService.updateInternship(id, updated, company);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Internship revised and resubmitted successfully! The Python assessment was updated and the listing is awaiting faculty re-evaluation.");
            return "redirect:/company/internships";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating listing: " + e.getMessage());
            return "redirect:/company/internships/edit/" + id;
        }
    }

    @GetMapping("/applicants")
    public String viewApplicants(@RequestParam(value = "internshipId", required = false) Long internshipId,
                                 Model model) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        List<Internship> myInternships = internshipService.findByCompany(company);
        List<Application> applications;

        if (internshipId != null) {
            applications = applicationService.findByCompanyIdAndInternshipId(company.getId(), internshipId);
        } else {
            applications = applicationService.findByCompanyId(company.getId());
        }

        model.addAttribute("myInternships", myInternships);
        model.addAttribute("selectedInternshipId", internshipId);
        model.addAttribute("applications", applications);

        return "company/applicants";
    }

    @PostMapping("/applicants/{id}/status")
    public String updateApplicantStatus(@PathVariable("id") Long applicationId,
                                        @RequestParam("newStatus") ApplicationStatus newStatus,
                                        @RequestParam(value = "remarks", required = false) String remarks,
                                        RedirectAttributes redirectAttributes) {
        User company = SecurityUtils.getAuthenticatedUser();
        if (company == null) return "redirect:/login";

        try {
            applicationService.updateStatus(applicationId, newStatus, company, remarks);
            redirectAttributes.addFlashAttribute("successMessage", "Applicant status updated to " + newStatus.name() + ".");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating applicant status: " + e.getMessage());
        }

        return "redirect:/company/applicants";
    }
}
