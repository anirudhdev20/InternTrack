-- ========================================================
-- InternTrack: College-Integrated Internship Management System
-- Sample Seed Data Script (MySQL 8.x)
-- Default Password for all demo accounts: password123
-- BCrypt Hash: $2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C
-- ========================================================

USE interntrack;

-- 1. Insert Departments
INSERT INTO departments (id, department_name) VALUES
(1, 'Computer Science and Engineering'),
(2, 'Information Technology'),
(3, 'Electronics and Communication Engineering'),
(4, 'Mechanical Engineering'),
(5, 'Civil Engineering')
ON DUPLICATE KEY UPDATE department_name = VALUES(department_name);

-- 2. Insert Users (Admin, Faculty, Companies, Students)
-- Password for all users is: password123
INSERT INTO users (id, name, email, password, role, department_id, active) VALUES
-- Admin
(1, 'System Administrator', 'admin@interntrack.edu', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'ADMIN', 1, TRUE),

-- Faculty Members
(2, 'Dr. Sarah Jenkins', 'faculty.cse@interntrack.edu', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'FACULTY', 1, TRUE),
(3, 'Prof. Robert Miller', 'faculty.it@interntrack.edu', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'FACULTY', 2, TRUE),

-- Companies
(4, 'TechNova Solutions', 'hr@technova.com', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'COMPANY', NULL, TRUE),
(5, 'Apex Cloud Labs', 'careers@apexcloud.io', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'COMPANY', NULL, TRUE),
(6, 'CyberShield Systems', 'talent@cybershield.org', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'COMPANY', NULL, TRUE),

-- Students
(7, 'Alex Rivera', 'alex.rivera@student.edu', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'STUDENT', 1, TRUE),
(8, 'Priya Sharma', 'priya.sharma@student.edu', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'STUDENT', 1, TRUE),
(9, 'David Chen', 'david.chen@student.edu', '$2a$10$MuHaR7BtjjmvB3c9BmhB1.LgQ9QEy7ubwCqUEqJmOhUSoURB1hx6C', 'STUDENT', 2, TRUE)
ON DUPLICATE KEY UPDATE name = VALUES(name), role = VALUES(role), active = VALUES(active);

-- 3. Company Profiles
INSERT INTO company_profiles (id, user_id, company_name, website, description, contact_number) VALUES
(1, 4, 'TechNova Solutions', 'https://technova.example.com', 'Leading enterprise software consultancy specializing in enterprise Java, cloud computing, and full-stack web applications.', '+1-555-019-2831'),
(2, 5, 'Apex Cloud Labs', 'https://apexcloud.example.io', 'Next-generation DevOps, Kubernetes orchestration, and cloud infrastructure management platform.', '+1-555-014-9982'),
(3, 6, 'CyberShield Systems', 'https://cybershield.example.org', 'Information security, penetration testing, and secure software development lifecycles firm.', '+1-555-018-4412')
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name), website = VALUES(website);

-- 4. Student Profiles
INSERT INTO student_profiles (id, user_id, academic_year, skills, phone, resume_path) VALUES
(1, 7, 'Final Year (4th Year)', 'Java, Spring Boot, MySQL, REST API, HTML5, Bootstrap, Git', '+1-555-012-3344', NULL),
(2, 8, '3rd Year', 'Python, Flask, React, JavaScript, SQL, Docker', '+1-555-017-8899', NULL),
(3, 9, 'Final Year (4th Year)', 'Java, Hibernate, Cloud Computing, Linux, Spring Security', '+1-555-016-5522', NULL)
ON DUPLICATE KEY UPDATE skills = VALUES(skills), academic_year = VALUES(academic_year);

-- 5. Internships
INSERT INTO internships (id, company_id, title, description, required_skills, eligibility, department_preference, duration, stipend, location, work_mode, vacancies, deadline, mentorship_details, review_status) VALUES
-- Approved Internship 1
(1, 4, 'Java Full Stack Developer Intern', 
 'Join our core platform engineering team to build enterprise microservices using Spring Boot, Hibernate, and MySQL. You will participate in sprint planning, code reviews, and API testing.', 
 'Java 17, Spring Boot, MySQL, REST APIs, Git', 
 'B.Tech CSE/IT 3rd or 4th Year with min 7.0 CGPA', 
 'Computer Science and Engineering', 
 '3 Months', 
 '$800/month', 
 'Calicut / Bangalore', 
 'HYBRID', 
 3, 
 DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), 
 '1-on-1 mentorship by Senior Tech Lead with weekly 1-hour code review sessions.', 
 'APPROVED'),

-- Approved Internship 2
(2, 5, 'Cloud Infrastructure & DevOps Intern', 
 'Learn and implement CI/CD automation pipelines, Docker containers, Kubernetes deployments, and cloud monitoring across AWS environments.', 
 'Linux, Docker, Python/Bash scripting, AWS basics, Git', 
 'B.Tech CSE, IT, ECE with interest in cloud technologies', 
 'Information Technology', 
 '6 Months', 
 '$1000/month', 
 'Remote', 
 'REMOTE', 
 2, 
 DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY), 
 'Dedicated DevOps Engineer mentor with daily standups and bi-weekly architecture walkthroughs.', 
 'APPROVED'),

-- Pending Review Internship 3 (Awaiting Faculty Review)
(3, 6, 'Security Operations & Vulnerability Analyst Intern', 
 'Assist our cybersecurity incident response team in log analysis, vulnerability scanning with OWASP ZAP, and writing remediation guidelines for web services.', 
 'Network Security, Linux, OWASP Top 10, Python, Cryptography basics', 
 'B.Tech CSE/IT pre-final or final year students', 
 'Computer Science and Engineering', 
 '2 Months', 
 '$750/month', 
 'Kochi / Technopark', 
 'ON_SITE', 
 1, 
 DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 
 'Senior Security Analyst will supervise daily triage and review pentest reports.', 
 'PENDING_REVIEW'),

-- Rejected Internship 4 (Example of faculty rejection for missing details)
(4, 4, 'Generic Software Helper', 
 'Help with office computers and typing documents.', 
 'Basic computers', 
 'Any student', 
 'All Departments', 
 '1 Month', 
 'Unpaid', 
 'Office', 
 'ON_SITE', 
 1, 
 DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), 
 '', 
 'REJECTED')
ON DUPLICATE KEY UPDATE title = VALUES(title), review_status = VALUES(review_status);

-- 6. Python Completeness Assessments for the Internships
INSERT INTO internship_assessments (id, internship_id, score, missing_details, warnings, recommendation, assessment_status) VALUES
(1, 1, 95, 'None', 'None', 'Ready for faculty review - High quality listing with complete specifications.', 'SUCCESS'),
(2, 2, 90, 'None', 'Ensure candidates have adequate hardware for remote work.', 'Ready for faculty review - Complete specifications.', 'SUCCESS'),
(3, 3, 85, 'Mentorship schedule details', 'Specific hours of daily supervision not explicitly quantified.', 'Ready for faculty review - Good listing with minor mentorship detail recommendations.', 'SUCCESS'),
(4, 4, 30, 'Technical skills required; Mentorship details; Specific project responsibilities', 'Stipend is unpaid and job role lacks technical learning outcomes.', 'Needs revision before faculty approval.', 'SUCCESS')
ON DUPLICATE KEY UPDATE score = VALUES(score), recommendation = VALUES(recommendation);

-- 7. Faculty Review Records
INSERT INTO internship_reviews (id, internship_id, faculty_id, decision, reason) VALUES
(1, 1, 2, 'APPROVED', 'Curriculum aligned with Advanced Java and Enterprise Web Development. Excellent mentorship program.'),
(2, 2, 3, 'APPROVED', 'Valuable exposure to cloud native technologies and containerization.'),
(3, 4, 2, 'REJECTED', 'Role lacks technical substance, does not meet academic internship criteria, and offers neither stipend nor defined mentorship.')
ON DUPLICATE KEY UPDATE decision = VALUES(decision), reason = VALUES(reason);

-- 8. Applications
INSERT INTO applications (id, internship_id, student_id, status) VALUES
(1, 1, 7, 'SELECTED'),
(2, 2, 7, 'APPLIED'),
(3, 1, 8, 'SHORTLISTED')
ON DUPLICATE KEY UPDATE status = VALUES(status);

-- 9. Application Status History
INSERT INTO application_status_history (id, application_id, old_status, new_status, updated_by, remarks) VALUES
(1, 1, 'APPLIED', 'SHORTLISTED', 4, 'Strong candidate profile and relevant Java projects.'),
(2, 1, 'SHORTLISTED', 'INTERVIEW_SCHEDULED', 4, 'Technical interview scheduled for 25th of this month via Google Meet.'),
(3, 1, 'INTERVIEW_SCHEDULED', 'SELECTED', 4, 'Candidate performed exceptionally in live coding assessment.'),
(4, 3, 'APPLIED', 'SHORTLISTED', 4, 'Resume shortlisted for initial technical screening.')
ON DUPLICATE KEY UPDATE new_status = VALUES(new_status);

-- 10. Internship Progress & Completion (For Selected Student Alex Rivera)
INSERT INTO internship_progress (id, application_id, progress_description, completion_status, certificate_path, submitted_at, verified_by, verified_at) VALUES
(1, 1, 'Completed sprint 1 & 2: developed user authentication module using Spring Security and JWT, written JUnit tests with 85% coverage.', 'IN_PROGRESS', NULL, CURRENT_TIMESTAMP, NULL, NULL)
ON DUPLICATE KEY UPDATE completion_status = VALUES(completion_status);

-- 11. Initial Notifications
INSERT INTO notifications (id, user_id, message, notification_type, is_read) VALUES
(1, 7, 'Congratulations! TechNova Solutions has selected you for Java Full Stack Developer Intern.', 'SELECTION', FALSE),
(2, 8, 'TechNova Solutions has shortlisted your application for Java Full Stack Developer Intern.', 'SHORTLIST', FALSE),
(3, 4, 'New application received from David Chen for Java Full Stack Developer Intern.', 'NEW_APPLICATION', FALSE),
(4, 2, 'New internship listing "Security Operations & Vulnerability Analyst Intern" requires faculty review.', 'REVIEW_REQUEST', FALSE)
ON DUPLICATE KEY UPDATE message = VALUES(message);
