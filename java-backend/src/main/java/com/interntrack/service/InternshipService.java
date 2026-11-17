package com.interntrack.service;

import com.interntrack.dto.AssessmentResponseDto;
import com.interntrack.model.*;
import com.interntrack.repository.InternshipAssessmentRepository;
import com.interntrack.repository.InternshipRepository;
import com.interntrack.repository.InternshipReviewRepository;
import com.interntrack.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class InternshipService {

    private final InternshipRepository internshipRepository;
    private final InternshipAssessmentRepository assessmentRepository;
    private final InternshipReviewRepository reviewRepository;
    private final AssessmentService assessmentService;
    private final NotificationService notificationService;
    private final UserRepository userRepository;

    public InternshipService(InternshipRepository internshipRepository,
                             InternshipAssessmentRepository assessmentRepository,
                             InternshipReviewRepository reviewRepository,
                             AssessmentService assessmentService,
                             NotificationService notificationService,
                             UserRepository userRepository) {
        this.internshipRepository = internshipRepository;
        this.assessmentRepository = assessmentRepository;
        this.reviewRepository = reviewRepository;
        this.assessmentService = assessmentService;
        this.notificationService = notificationService;
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public Optional<Internship> findById(Long id) {
        return internshipRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public List<Internship> findByCompany(User company) {
        return internshipRepository.findByCompanyOrderByCreatedAtDesc(company);
    }

    @Transactional(readOnly = true)
    public List<Internship> findByReviewStatus(ReviewStatus status) {
        return internshipRepository.findByReviewStatusOrderByCreatedAtDesc(status);
    }

    @Transactional(readOnly = true)
    public List<Internship> findAll() {
        return internshipRepository.findAll();
    }

    @Transactional(readOnly = true)
    public long countByStatus(ReviewStatus status) {
        return internshipRepository.countByReviewStatus(status);
    }

    @Transactional(readOnly = true)
    public long countByCompanyAndStatus(User company, ReviewStatus status) {
        return internshipRepository.countByCompanyAndReviewStatus(company, status);
    }

    @Transactional(readOnly = true)
    public long countByCompany(User company) {
        return internshipRepository.countByCompany(company);
    }

    @Transactional
    public Internship createInternship(Internship internship, User company) {
        internship.setCompany(company);
        internship.setReviewStatus(ReviewStatus.PENDING_REVIEW);
        Internship saved = internshipRepository.save(internship);

        // Run Python Completeness Assessment
        runAndSaveAssessment(saved);

        // Notify faculty members about new listing pending review
        List<User> facultyList = userRepository.findByRoleAndActive(Role.FACULTY, true);
        for (User faculty : facultyList) {
            notificationService.sendNotification(
                    faculty,
                    "New internship '" + saved.getTitle() + "' posted by " + company.getName() + " awaits faculty review.",
                    "INTERNSHIP_SUBMITTED"
            );
        }

        return saved;
    }

    @Transactional
    public Internship updateInternship(Long internshipId, Internship updated, User company) {
        Internship existing = internshipRepository.findById(internshipId)
                .orElseThrow(() -> new IllegalArgumentException("Internship not found: " + internshipId));

        if (!existing.getCompany().getId().equals(company.getId())) {
            throw new SecurityException("Unauthorized attempt to modify another company's internship.");
        }

        existing.setTitle(updated.getTitle());
        existing.setDescription(updated.getDescription());
        existing.setRequiredSkills(updated.getRequiredSkills());
        existing.setEligibility(updated.getEligibility());
        existing.setDepartmentPreference(updated.getDepartmentPreference());
        existing.setDuration(updated.getDuration());
        existing.setStipend(updated.getStipend());
        existing.setLocation(updated.getLocation());
        existing.setWorkMode(updated.getWorkMode());
        existing.setVacancies(updated.getVacancies());
        existing.setDeadline(updated.getDeadline());
        existing.setMentorshipDetails(updated.getMentorshipDetails());

        // Always re-route through faculty review upon modification
        existing.setReviewStatus(ReviewStatus.PENDING_REVIEW);
        existing.setUpdatedAt(LocalDateTime.now());

        Internship saved = internshipRepository.save(existing);
        runAndSaveAssessment(saved);

        return saved;
    }

    @Transactional
    public void runAndSaveAssessment(Internship internship) {
        AssessmentResponseDto dto = assessmentService.assessInternship(internship);

        InternshipAssessment assessment = assessmentRepository.findByInternship(internship)
                .orElseGet(() -> {
                    InternshipAssessment a = new InternshipAssessment();
                    a.setInternship(internship);
                    return a;
                });

        assessment.setScore(dto.getScore());
        assessment.setMissingDetails(String.join("; ", dto.getMissingDetails()));
        assessment.setWarnings(String.join("; ", dto.getWarnings()));
        assessment.setRecommendation(dto.getRecommendation());
        assessment.setAssessmentStatus(dto.getStatus());
        assessment.setAssessedAt(LocalDateTime.now());

        assessmentRepository.save(assessment);
    }

    @Transactional
    public void reviewInternship(Long internshipId, User faculty, String decision, String reason) {
        Internship internship = internshipRepository.findById(internshipId)
                .orElseThrow(() -> new IllegalArgumentException("Internship not found: " + internshipId));

        ReviewStatus newStatus = "APPROVED".equalsIgnoreCase(decision) ? ReviewStatus.APPROVED : ReviewStatus.REJECTED;
        internship.setReviewStatus(newStatus);
        internship.setUpdatedAt(LocalDateTime.now());
        internshipRepository.save(internship);

        // Record faculty review history
        InternshipReview review = new InternshipReview(internship, faculty, newStatus.name(), reason);
        reviewRepository.save(review);

        // Send in-app notification to company
        String notifyMsg = newStatus == ReviewStatus.APPROVED
                ? "Your internship listing '" + internship.getTitle() + "' was approved by faculty (" + faculty.getName() + ") and is now active for student applications!"
                : "Your internship listing '" + internship.getTitle() + "' was rejected by faculty (" + faculty.getName() + "). Reason: " + reason;

        notificationService.sendNotification(internship.getCompany(), notifyMsg, "REVIEW_DECISION");
    }

    @Transactional(readOnly = true)
    public List<Internship> searchApprovedInternships(String title, String companyName, String skills,
                                                      String location, WorkMode workMode, String dept) {
        String cleanTitle = (title != null && !title.trim().isEmpty()) ? title.trim() : null;
        String cleanComp = (companyName != null && !companyName.trim().isEmpty()) ? companyName.trim() : null;
        String cleanSkills = (skills != null && !skills.trim().isEmpty()) ? skills.trim() : null;
        String cleanLoc = (location != null && !location.trim().isEmpty()) ? location.trim() : null;
        String cleanDept = (dept != null && !dept.trim().isEmpty()) ? dept.trim() : null;

        return internshipRepository.searchApprovedInternships(
                ReviewStatus.APPROVED, cleanTitle, cleanComp, cleanSkills, cleanLoc, workMode, cleanDept
        );
    }
}
