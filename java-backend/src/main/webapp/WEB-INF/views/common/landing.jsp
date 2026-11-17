<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="InternTrack - Centralized College Internship Management System" />
<jsp:include page="header.jsp" />

<!-- Hero Section -->
<header class="hero-section text-center text-lg-start">
    <div class="container py-4">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="badge bg-primary bg-opacity-25 text-primary-emphasis px-3 py-2 rounded-pill fw-semibold mb-3 border border-primary border-opacity-25">
                    <i class="bi bi-shield-check me-1"></i> Faculty-Supervised Academic Internship Ecosystem
                </span>
                <h1 class="hero-title text-white">
                    Connecting Students, Companies & Faculty Seamlessly.
                </h1>
                <p class="hero-subtitle">
                    InternTrack centralizes academic internships. Companies post high-impact roles, AI-assisted Python microservices evaluate listing completeness, and college faculty quality-control every opportunity before students apply.
                </p>
                <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start pt-2">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg px-4 shadow">
                        <i class="bi bi-rocket-takeoff-fill me-2"></i> Join InternTrack
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-lg px-4">
                        <i class="bi bi-box-arrow-in-right me-2"></i> Portal Login
                    </a>
                </div>
            </div>
            <div class="col-lg-5 mt-5 mt-lg-0 text-center">
                <div class="p-4 bg-white bg-opacity-10 rounded-4 border border-white border-opacity-10 backdrop-blur shadow-lg">
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="p-3 bg-dark bg-opacity-50 rounded-3 text-start">
                                <i class="bi bi-mortarboard fs-2 text-info mb-2 d-block"></i>
                                <h3 class="h2 text-white mb-0">${totalStudents}+</h3>
                                <span class="small text-light">Enrolled Students</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-3 bg-dark bg-opacity-50 rounded-3 text-start">
                                <i class="bi bi-building fs-2 text-warning mb-2 d-block"></i>
                                <h3 class="h2 text-white mb-0">${totalCompanies}+</h3>
                                <span class="small text-light">Partner Companies</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-3 bg-dark bg-opacity-50 rounded-3 text-start">
                                <i class="bi bi-briefcase fs-2 text-success mb-2 d-block"></i>
                                <h3 class="h2 text-white mb-0">${totalInternships}+</h3>
                                <span class="small text-light">Verified Opportunities</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="p-3 bg-dark bg-opacity-50 rounded-3 text-start">
                                <i class="bi bi-cpu fs-2 text-primary mb-2 d-block"></i>
                                <h3 class="h2 text-white mb-0">100%</h3>
                                <span class="small text-light">Python Assessed</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- How It Works Section -->
<section id="how-it-works" class="py-5 bg-white">
    <div class="container py-4">
        <div class="text-center max-w-700 mx-auto mb-5">
            <span class="text-primary fw-bold text-uppercase small tracking-wide">Structured Workflow</span>
            <h2 class="fw-bold mt-1 text-dark">How InternTrack Works</h2>
            <p class="text-muted">A distinct quality-control workflow ensuring accredited, worthwhile internships for students.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-3">
                <div class="feature-box text-center">
                    <div class="feature-icon-circle bg-primary bg-opacity-10 text-primary mx-auto">
                        <i class="bi bi-pencil-square"></i>
                    </div>
                    <h5 class="fw-bold">1. Company Posts</h5>
                    <p class="text-muted small">Companies register and draft internship specifications with skills, stipend, and mentorship details.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-box text-center">
                    <div class="feature-icon-circle bg-info bg-opacity-10 text-info mx-auto">
                        <i class="bi bi-robot"></i>
                    </div>
                    <h5 class="fw-bold">2. Python Assesses</h5>
                    <p class="text-muted small">Our rule-based Python microservice computes a 100-point completeness score and flags missing details.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-box text-center">
                    <div class="feature-icon-circle bg-warning bg-opacity-10 text-warning mx-auto">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h5 class="fw-bold">3. Faculty Approves</h5>
                    <p class="text-muted small">Faculty reviews the proposal alongside Python insights, either approving or giving constructive rejection feedback.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="feature-box text-center">
                    <div class="feature-icon-circle bg-success bg-opacity-10 text-success mx-auto">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                    <h5 class="fw-bold">4. Students Apply</h5>
                    <p class="text-muted small">Approved listings become live. Students apply, companies interview and select, and faculty verifies completion.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Beneficiary Role Sections -->
<section id="roles" class="py-5 bg-light border-top border-bottom">
    <div class="container py-4">
        <div class="text-center mb-5">
            <span class="text-primary fw-bold text-uppercase small tracking-wide">Ecosystem Benefits</span>
            <h2 class="fw-bold mt-1 text-dark">Tailored for Every Academic Stakeholder</h2>
        </div>

        <div class="row g-4">
            <!-- Student Benefits -->
            <div class="col-lg-4">
                <div class="card h-100 border-0 shadow-sm p-4 rounded-4">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="bg-primary text-white rounded-3 p-3">
                            <i class="bi bi-person-workspace fs-3"></i>
                        </div>
                        <h4 class="fw-bold mb-0">For Students</h4>
                    </div>
                    <ul class="list-unstyled text-secondary d-flex flex-column gap-2 mb-4">
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Browse verified, faculty-screened roles</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> One-click application with resume upload</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Real-time status tracker (Shortlisted, Interview, Selected)</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Submit completion certificates for college credits</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/register/student" class="btn btn-outline-primary mt-auto">
                        Student Registration &rarr;
                    </a>
                </div>
            </div>

            <!-- Company Benefits -->
            <div class="col-lg-4">
                <div class="card h-100 border-0 shadow-sm p-4 rounded-4">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="bg-warning text-white rounded-3 p-3">
                            <i class="bi bi-building fs-3"></i>
                        </div>
                        <h4 class="fw-bold mb-0">For Companies</h4>
                    </div>
                    <ul class="list-unstyled text-secondary d-flex flex-column gap-2 mb-4">
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Access top engineering talent directly</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Automated completeness quality scoring</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Integrated applicant management workflow</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Shortlist, schedule interviews, and select candidates</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/register/company" class="btn btn-outline-warning text-dark mt-auto">
                        Company Registration &rarr;
                    </a>
                </div>
            </div>

            <!-- Faculty Benefits -->
            <div class="col-lg-4">
                <div class="card h-100 border-0 shadow-sm p-4 rounded-4">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="bg-info text-white rounded-3 p-3">
                            <i class="bi bi-mortarboard-fill fs-3"></i>
                        </div>
                        <h4 class="fw-bold mb-0">For Faculty</h4>
                    </div>
                    <ul class="list-unstyled text-secondary d-flex flex-column gap-2 mb-4">
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Intermediary quality-control oversight</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Python-assisted inspection report for listings</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Monitor student participation by department</li>
                        <li><i class="bi bi-check-circle-fill text-success me-2"></i> Verify completion certificates for academic compliance</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-info text-dark mt-auto">
                        Faculty Login &rarr;
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Demo Credentials Section -->
<section class="py-5 bg-white">
    <div class="container py-3">
        <div class="bg-light p-4 rounded-4 border">
            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-key-fill text-primary me-2"></i>Quick Demo Test Credentials</h5>
            <p class="text-muted small mb-3">All accounts below are pre-seeded in the database with default password: <code>password123</code></p>
            <div class="row g-3">
                <div class="col-md-3">
                    <div class="p-3 bg-white rounded border">
                        <span class="badge bg-secondary mb-1">ADMIN</span>
                        <div class="fw-semibold small">admin@interntrack.edu</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="p-3 bg-white rounded border">
                        <span class="badge bg-info text-dark mb-1">FACULTY</span>
                        <div class="fw-semibold small">faculty.cse@interntrack.edu</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="p-3 bg-white rounded border">
                        <span class="badge bg-warning text-dark mb-1">COMPANY</span>
                        <div class="fw-semibold small">hr@technova.com</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="p-3 bg-white rounded border">
                        <span class="badge bg-primary mb-1">STUDENT</span>
                        <div class="fw-semibold small">alex.rivera@student.edu</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp" />
