package com.interntrack.service;

import com.interntrack.model.*;
import com.interntrack.repository.ApplicationRepository;
import com.interntrack.repository.InternshipProgressRepository;
import com.interntrack.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ProgressService {

    private final InternshipProgressRepository progressRepository;
    private final ApplicationRepository applicationRepository;
    private final NotificationService notificationService;
    private final UserRepository userRepository;

    public ProgressService(InternshipProgressRepository progressRepository,
                           ApplicationRepository applicationRepository,
                           NotificationService notificationService,
                           UserRepository userRepository) {
        this.progressRepository = progressRepository;
        this.applicationRepository = applicationRepository;
        this.notificationService = notificationService;
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public Optional<InternshipProgress> findByApplicationId(Long applicationId) {
        return progressRepository.findByApplicationId(applicationId);
    }

    @Transactional(readOnly = true)
    public List<InternshipProgress> findAll() {
        return progressRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<InternshipProgress> findByStatus(CompletionStatus status) {
        return progressRepository.findByCompletionStatus(status);
    }

    @Transactional(readOnly = true)
    public long countByStatus(CompletionStatus status) {
        return progressRepository.countByCompletionStatus(status);
    }

    @Transactional
    public InternshipProgress submitProgress(Long applicationId, User student, String description, String certificatePath) {
        Application application = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException("Application not found: " + applicationId));

        if (!application.getStudent().getId().equals(student.getId())) {
            throw new SecurityException("Unauthorized attempt to submit progress for another student.");
        }

        if (application.getStatus() != ApplicationStatus.SELECTED) {
            throw new IllegalStateException("Progress and completion submissions are only permitted for selected internships.");
        }

        InternshipProgress progress = progressRepository.findByApplication(application)
                .orElseGet(() -> new InternshipProgress(application));

        progress.setProgressDescription(description);
        if (certificatePath != null && !certificatePath.isEmpty()) {
            progress.setCertificatePath(certificatePath);
            progress.setCompletionStatus(CompletionStatus.SUBMITTED);
            progress.setSubmittedAt(LocalDateTime.now());
        } else if (progress.getCompletionStatus() == CompletionStatus.NOT_STARTED) {
            progress.setCompletionStatus(CompletionStatus.IN_PROGRESS);
        }

        InternshipProgress saved = progressRepository.save(progress);

        // Notify faculty if certificate was submitted
        if (certificatePath != null && !certificatePath.isEmpty()) {
            List<User> facultyList = userRepository.findByRoleAndActive(Role.FACULTY, true);
            for (User fac : facultyList) {
                notificationService.sendNotification(
                        fac,
                        "Student " + student.getName() + " submitted an internship completion certificate for verification.",
                        "COMPLETION_SUBMITTED"
                );
            }
        }

        return saved;
    }

    @Transactional
    public void verifyCompletion(Long progressId, User faculty, boolean approved, String remarks) {
        InternshipProgress progress = progressRepository.findById(progressId)
                .orElseThrow(() -> new IllegalArgumentException("Progress record not found: " + progressId));

        progress.setVerifiedBy(faculty);
        progress.setVerifiedAt(LocalDateTime.now());
        progress.setCompletionStatus(approved ? CompletionStatus.VERIFIED : CompletionStatus.COMPLETION_REJECTED);
        progressRepository.save(progress);

        // Notify student
        String noteMsg = approved
                ? "Congratulations! Your internship completion certificate for '" + progress.getApplication().getInternship().getTitle() + "' has been verified by faculty " + faculty.getName() + "."
                : "Your internship completion certificate for '" + progress.getApplication().getInternship().getTitle() + "' was not approved by faculty " + faculty.getName() + (remarks != null ? ". Reason: " + remarks : "");

        notificationService.sendNotification(progress.getApplication().getStudent(), noteMsg, "COMPLETION_VERIFICATION");
    }
}
