package com.interntrack.service;

import com.interntrack.model.*;
import com.interntrack.repository.ApplicationRepository;
import com.interntrack.repository.ApplicationStatusHistoryRepository;
import com.interntrack.repository.InternshipProgressRepository;
import com.interntrack.repository.InternshipRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ApplicationService {

    private final ApplicationRepository applicationRepository;
    private final ApplicationStatusHistoryRepository historyRepository;
    private final InternshipProgressRepository progressRepository;
    private final InternshipRepository internshipRepository;
    private final NotificationService notificationService;

    public ApplicationService(ApplicationRepository applicationRepository,
                              ApplicationStatusHistoryRepository historyRepository,
                              InternshipProgressRepository progressRepository,
                              InternshipRepository internshipRepository,
                              NotificationService notificationService) {
        this.applicationRepository = applicationRepository;
        this.historyRepository = historyRepository;
        this.progressRepository = progressRepository;
        this.internshipRepository = internshipRepository;
        this.notificationService = notificationService;
    }

    @Transactional(readOnly = true)
    public Optional<Application> findById(Long id) {
        return applicationRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public List<Application> findByStudent(User student) {
        return applicationRepository.findByStudentOrderByAppliedAtDesc(student);
    }

    @Transactional(readOnly = true)
    public List<Application> findByCompanyId(Long companyId) {
        return applicationRepository.findByCompanyId(companyId);
    }

    @Transactional(readOnly = true)
    public List<Application> findByCompanyIdAndInternshipId(Long companyId, Long internshipId) {
        return applicationRepository.findByCompanyIdAndInternshipId(companyId, internshipId);
    }

    @Transactional(readOnly = true)
    public List<Application> findAll() {
        return applicationRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Application> findByDepartmentId(Long deptId) {
        return applicationRepository.findByDepartmentId(deptId);
    }

    @Transactional(readOnly = true)
    public List<Application> findByStatus(ApplicationStatus status) {
        return applicationRepository.findByStatusOrder(status);
    }

    @Transactional(readOnly = true)
    public long countByStatus(ApplicationStatus status) {
        return applicationRepository.countByStatus(status);
    }

    @Transactional(readOnly = true)
    public long countByStudent(User student) {
        return applicationRepository.countByStudent(student);
    }

    @Transactional(readOnly = true)
    public long countByStudentAndStatus(User student, ApplicationStatus status) {
        return applicationRepository.countByStudentAndStatus(student, status);
    }

    @Transactional(readOnly = true)
    public long countByCompanyId(Long companyId) {
        return applicationRepository.countByCompanyId(companyId);
    }

    @Transactional(readOnly = true)
    public long countByCompanyIdAndStatus(Long companyId, ApplicationStatus status) {
        return applicationRepository.countByCompanyIdAndStatus(companyId, status);
    }

    @Transactional
    public Application apply(Long internshipId, User student) {
        Internship internship = internshipRepository.findById(internshipId)
                .orElseThrow(() -> new IllegalArgumentException("Internship not found: " + internshipId));

        if (internship.getReviewStatus() != ReviewStatus.APPROVED) {
            throw new IllegalStateException("Cannot apply to an internship that is not faculty-approved.");
        }

        if (applicationRepository.existsByStudentAndInternship(student, internship)) {
            throw new IllegalStateException("You have already submitted an application for this internship.");
        }

        Application application = new Application(internship, student);
        application.setStatus(ApplicationStatus.APPLIED);
        Application saved = applicationRepository.save(application);

        // Record initial history
        ApplicationStatusHistory history = new ApplicationStatusHistory(
                saved, null, ApplicationStatus.APPLIED.name(), student, "Student submitted application."
        );
        historyRepository.save(history);

        // Notify Company
        notificationService.sendNotification(
                internship.getCompany(),
                "New application received from " + student.getName() + " for '" + internship.getTitle() + "'.",
                "NEW_APPLICATION"
        );

        return saved;
    }

    @Transactional
    public void updateStatus(Long applicationId, ApplicationStatus newStatus, User company, String remarks) {
        Application application = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException("Application not found: " + applicationId));

        // Security check: ensure the company owns this internship
        if (!application.getInternship().getCompany().getId().equals(company.getId())) {
            throw new SecurityException("Unauthorized attempt to modify an applicant for another company's listing.");
        }

        String oldStatus = application.getStatus().name();
        application.setStatus(newStatus);
        application.setUpdatedAt(LocalDateTime.now());
        applicationRepository.save(application);

        // Record history
        ApplicationStatusHistory history = new ApplicationStatusHistory(
                application, oldStatus, newStatus.name(), company, remarks
        );
        historyRepository.save(history);

        // If selected, automatically initialize internship progress record if not present
        if (newStatus == ApplicationStatus.SELECTED) {
            progressRepository.findByApplication(application).orElseGet(() -> {
                InternshipProgress p = new InternshipProgress(application);
                return progressRepository.save(p);
            });
        }

        // Notify Student
        String noteMsg = "Update on your application for '" + application.getInternship().getTitle() + "': "
                + "Status changed to " + newStatus.name() + (remarks != null && !remarks.isEmpty() ? ". Note: " + remarks : "");
        notificationService.sendNotification(application.getStudent(), noteMsg, "APPLICATION_STATUS_UPDATE");
    }

    @Transactional(readOnly = true)
    public List<ApplicationStatusHistory> getStatusHistory(Long applicationId) {
        return historyRepository.findByApplicationIdOrderByUpdatedAtDesc(applicationId);
    }
}
