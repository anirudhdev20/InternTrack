package com.interntrack.service;

import com.interntrack.model.*;
import com.interntrack.repository.CompanyProfileRepository;
import com.interntrack.repository.DepartmentRepository;
import com.interntrack.repository.StudentProfileRepository;
import com.interntrack.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;
    private final StudentProfileRepository studentProfileRepository;
    private final CompanyProfileRepository companyProfileRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository,
                       DepartmentRepository departmentRepository,
                       StudentProfileRepository studentProfileRepository,
                       CompanyProfileRepository companyProfileRepository,
                       PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.departmentRepository = departmentRepository;
        this.studentProfileRepository = studentProfileRepository;
        this.companyProfileRepository = companyProfileRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Transactional(readOnly = true)
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Transactional(readOnly = true)
    public List<User> findByRole(Role role) {
        return userRepository.findByRole(role);
    }

    @Transactional(readOnly = true)
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Transactional(readOnly = true)
    public long countByRole(Role role) {
        return userRepository.countByRole(role);
    }

    @Transactional
    public User registerStudent(String name, String email, String password, Long departmentId,
                                String academicYear, String phone, String skills) {
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("An account with email " + email + " already exists.");
        }

        Department dept = null;
        if (departmentId != null) {
            dept = departmentRepository.findById(departmentId).orElse(null);
        }

        User student = new User(name, email, passwordEncoder.encode(password), Role.STUDENT, dept);
        User savedUser = userRepository.save(student);

        StudentProfile profile = new StudentProfile(savedUser, academicYear, skills, phone, null);
        studentProfileRepository.save(profile);

        return savedUser;
    }

    @Transactional
    public User registerCompany(String name, String email, String password,
                                String companyName, String website, String description, String contactNumber) {
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("An account with email " + email + " already exists.");
        }

        User company = new User(name, email, passwordEncoder.encode(password), Role.COMPANY, null);
        User savedUser = userRepository.save(company);

        CompanyProfile profile = new CompanyProfile(savedUser, companyName, website, description, contactNumber);
        companyProfileRepository.save(profile);

        return savedUser;
    }

    @Transactional
    public void updateStudentProfile(Long userId, String academicYear, String skills, String phone, String resumePath) {
        StudentProfile profile = studentProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    User u = userRepository.findById(userId).orElseThrow();
                    StudentProfile sp = new StudentProfile();
                    sp.setUser(u);
                    return sp;
                });

        if (academicYear != null) profile.setAcademicYear(academicYear);
        if (skills != null) profile.setSkills(skills);
        if (phone != null) profile.setPhone(phone);
        if (resumePath != null) profile.setResumePath(resumePath);

        studentProfileRepository.save(profile);
    }

    @Transactional
    public void updateCompanyProfile(Long userId, String companyName, String website, String description, String contactNumber) {
        CompanyProfile profile = companyProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    User u = userRepository.findById(userId).orElseThrow();
                    CompanyProfile cp = new CompanyProfile();
                    cp.setUser(u);
                    return cp;
                });

        if (companyName != null) profile.setCompanyName(companyName);
        if (website != null) profile.setWebsite(website);
        if (description != null) profile.setDescription(description);
        if (contactNumber != null) profile.setContactNumber(contactNumber);

        companyProfileRepository.save(profile);
    }

    @Transactional
    public boolean toggleUserStatus(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));
        user.setActive(!user.isActive());
        userRepository.save(user);
        return user.isActive();
    }
}
