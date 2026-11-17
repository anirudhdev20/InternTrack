package com.interntrack.config;

import com.interntrack.model.*;
import com.interntrack.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;
    private final StudentProfileRepository studentProfileRepository;
    private final CompanyProfileRepository companyProfileRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UserRepository userRepository,
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

    @Override
    @Transactional
    public void run(String... args) {
        // Ensure default departments exist
        Department cse = departmentRepository.findByDepartmentName("Computer Science and Engineering")
                .orElseGet(() -> departmentRepository.save(new Department("Computer Science and Engineering")));
        Department it = departmentRepository.findByDepartmentName("Information Technology")
                .orElseGet(() -> departmentRepository.save(new Department("Information Technology")));
        departmentRepository.findByDepartmentName("Electronics and Communication Engineering")
                .orElseGet(() -> departmentRepository.save(new Department("Electronics and Communication Engineering")));

        // Update all existing demo users to have the verified BCrypt hash for "password123"
        String standardEncoded = passwordEncoder.encode("password123");

        userRepository.findByEmail("admin@interntrack.edu").ifPresentOrElse(user -> {
            user.setPassword(standardEncoded);
            userRepository.save(user);
        }, () -> {
            User admin = new User("System Administrator", "admin@interntrack.edu", standardEncoded, Role.ADMIN, cse);
            userRepository.save(admin);
        });

        userRepository.findByEmail("faculty.cse@interntrack.edu").ifPresentOrElse(user -> {
            user.setPassword(standardEncoded);
            userRepository.save(user);
        }, () -> {
            User fac = new User("Dr. Sarah Jenkins", "faculty.cse@interntrack.edu", standardEncoded, Role.FACULTY, cse);
            userRepository.save(fac);
        });

        userRepository.findByEmail("faculty.it@interntrack.edu").ifPresentOrElse(user -> {
            user.setPassword(standardEncoded);
            userRepository.save(user);
        }, () -> {
            User fac = new User("Prof. Robert Miller", "faculty.it@interntrack.edu", standardEncoded, Role.FACULTY, it);
            userRepository.save(fac);
        });

        userRepository.findByEmail("hr@technova.com").ifPresentOrElse(user -> {
            user.setPassword(standardEncoded);
            userRepository.save(user);
        }, () -> {
            User comp = new User("TechNova Solutions", "hr@technova.com", standardEncoded, Role.COMPANY, null);
            User saved = userRepository.save(comp);
            companyProfileRepository.save(new CompanyProfile(saved, "TechNova Solutions", "https://technova.example.com", "Enterprise Java & Cloud Solutions", "+1-555-019-2831"));
        });

        userRepository.findByEmail("alex.rivera@student.edu").ifPresentOrElse(user -> {
            user.setPassword(standardEncoded);
            userRepository.save(user);
        }, () -> {
            User std = new User("Alex Rivera", "alex.rivera@student.edu", standardEncoded, Role.STUDENT, cse);
            User saved = userRepository.save(std);
            studentProfileRepository.save(new StudentProfile(saved, "Final Year (4th Year)", "Java, Spring Boot, MySQL", "+1-555-012-3344", null));
        });

        log.info("InternTrack DataInitializer completed: demo accounts verified with standard credentials (password123).");
    }
}
