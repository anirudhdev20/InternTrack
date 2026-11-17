package com.interntrack.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "internship_assessments")
public class InternshipAssessment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "internship_id", nullable = false)
    private Internship internship;

    @Column(nullable = false)
    private int score;

    @Column(name = "missing_details", columnDefinition = "TEXT")
    private String missingDetails;

    @Column(columnDefinition = "TEXT")
    private String warnings;

    @Column(length = 255)
    private String recommendation;

    @Column(name = "assessment_status", length = 30)
    private String assessmentStatus = "SUCCESS";

    @Column(name = "assessed_at")
    private LocalDateTime assessedAt = LocalDateTime.now();

    public InternshipAssessment() {
    }

    public InternshipAssessment(Internship internship, int score, String missingDetails, String warnings, String recommendation, String assessmentStatus) {
        this.internship = internship;
        this.score = score;
        this.missingDetails = missingDetails;
        this.warnings = warnings;
        this.recommendation = recommendation;
        this.assessmentStatus = assessmentStatus;
        this.assessedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Internship getInternship() {
        return internship;
    }

    public void setInternship(Internship internship) {
        this.internship = internship;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getMissingDetails() {
        return missingDetails;
    }

    public void setMissingDetails(String missingDetails) {
        this.missingDetails = missingDetails;
    }

    public String getWarnings() {
        return warnings;
    }

    public void setWarnings(String warnings) {
        this.warnings = warnings;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public String getAssessmentStatus() {
        return assessmentStatus;
    }

    public void setAssessmentStatus(String assessmentStatus) {
        this.assessmentStatus = assessmentStatus;
    }

    public LocalDateTime getAssessedAt() {
        return assessedAt;
    }

    public void setAssessedAt(LocalDateTime assessedAt) {
        this.assessedAt = assessedAt;
    }
}
