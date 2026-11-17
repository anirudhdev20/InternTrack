<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Registration - InternTrack" />
<jsp:include page="header.jsp" />

<div class="container py-5 my-auto">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card card-custom p-4 shadow">
                <div class="text-center mb-4">
                    <div class="brand-badge d-inline-block mb-2 p-2">
                        <i class="bi bi-mortarboard-fill fs-2"></i>
                    </div>
                    <h3 class="fw-bold text-dark">Student Registration</h3>
                    <p class="text-muted small">Create your student profile to browse approved internships</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register/student" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Full Name *</label>
                            <input type="text" class="form-control" name="name" placeholder="Alex Rivera" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Student College Email *</label>
                            <input type="email" class="form-control" name="email" placeholder="alex.rivera@student.edu" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Password *</label>
                            <input type="password" class="form-control" name="password" placeholder="Minimum 6 characters" required minlength="6">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Department *</label>
                            <select class="form-select" name="departmentId" required>
                                <option value="">Select Department</option>
                                <c:forEach items="${departments}" var="dept">
                                    <option value="${dept.id}">${dept.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Academic Year *</label>
                            <select class="form-select" name="academicYear" required>
                                <option value="1st Year">1st Year</option>
                                <option value="2nd Year">2nd Year</option>
                                <option value="3rd Year">3rd Year</option>
                                <option value="Final Year (4th Year)" selected>Final Year (4th Year)</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Contact Phone</label>
                            <input type="text" class="form-control" name="phone" placeholder="+1-555-012-3344">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Key Skills</label>
                            <input type="text" class="form-control" name="skills" placeholder="Java, Spring Boot, MySQL, HTML">
                        </div>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary btn-lg shadow-sm">
                            <i class="bi bi-person-check-fill me-1"></i> Complete Registration
                        </button>
                    </div>
                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <span class="text-muted small">Already have an account?</span>
                    <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary small text-decoration-none ms-1">Log in here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
