package com.interntrack.model;

import jakarta.persistence.*;

@Entity
@Table(name = "student_profiles")
public class StudentProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "academic_year", length = 50)
    private String academicYear;

    @Column(columnDefinition = "TEXT")
    private String skills;

    @Column(length = 25)
    private String phone;

    @Column(name = "resume_path", length = 255)
    private String resumePath;

    public StudentProfile() {
    }

    public StudentProfile(User user, String academicYear, String skills, String phone, String resumePath) {
        this.user = user;
        this.academicYear = academicYear;
        this.skills = skills;
        this.phone = phone;
        this.resumePath = resumePath;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(String academicYear) {
        this.academicYear = academicYear;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getResumePath() {
        return resumePath;
    }

    public void setResumePath(String resumePath) {
        this.resumePath = resumePath;
    }
}
