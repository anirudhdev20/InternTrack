<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile - InternTrack" />
<c:set var="activePage" value="profile" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1">Student Profile</h2>
                <p class="text-muted small mb-0">Maintain your academic credentials, technical skills, and resume</p>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-1"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card card-custom p-4">
                        <form action="${pageContext.request.contextPath}/student/profile" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-muted">Full Name</label>
                                    <input type="text" class="form-control bg-light" value="${user.name}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-muted">College Email</label>
                                    <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-muted">Department</label>
                                    <input type="text" class="form-control bg-light" value="${user.department != null ? user.department.departmentName : 'Unassigned'}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small">Academic Year *</label>
                                    <select class="form-select" name="academicYear" required>
                                        <option value="1st Year" ${profile.academicYear == '1st Year' ? 'selected' : ''}>1st Year</option>
                                        <option value="2nd Year" ${profile.academicYear == '2nd Year' ? 'selected' : ''}>2nd Year</option>
                                        <option value="3rd Year" ${profile.academicYear == '3rd Year' ? 'selected' : ''}>3rd Year</option>
                                        <option value="Final Year (4th Year)" ${profile.academicYear == 'Final Year (4th Year)' ? 'selected' : ''}>Final Year (4th Year)</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small">Contact Phone Number</label>
                                    <input type="text" class="form-control" name="phone" value="${profile.phone}" placeholder="+1-555-012-3344">
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label fw-semibold small">Technical & Professional Skills</label>
                                    <input type="text" class="form-control" name="skills" value="${profile.skills}" placeholder="e.g. Java, Spring Boot, MySQL, REST APIs, Git, Docker">
                                    <span class="text-muted small">Separate multiple skills with commas.</span>
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label fw-semibold small">Upload Resume (PDF / DOC / DOCX)</label>
                                    <input type="file" class="form-control" name="resumeFile" accept=".pdf,.doc,.docx">
                                    <c:if test="${not empty profile.resumePath}">
                                        <div class="mt-2 small text-success">
                                            <i class="bi bi-file-earmark-check-fill me-1"></i> Current Resume:
                                            <a href="${pageContext.request.contextPath}/uploads/${profile.resumePath}" target="_blank" class="fw-semibold text-decoration-none">
                                                View Uploaded Document
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="mt-4 pt-3 border-top">
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="bi bi-check-lg me-1"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Info Card -->
                <div class="col-lg-4">
                    <div class="card card-custom p-4 bg-light border">
                        <h5 class="fw-bold mb-3"><i class="bi bi-shield-check text-primary me-2"></i>Profile Verification</h5>
                        <p class="text-muted small">
                            Your academic records and department affiliation are tied to college registration.
                        </p>
                        <hr>
                        <div class="small mb-2">
                            <strong>Role:</strong> <span class="badge bg-primary">STUDENT</span>
                        </div>
                        <div class="small mb-2">
                            <strong>Account Status:</strong> <span class="badge bg-success">ACTIVE</span>
                        </div>
                        <div class="small">
                            <strong>Enrolled Since:</strong> ${user.createdAt.toLocalDate()}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
