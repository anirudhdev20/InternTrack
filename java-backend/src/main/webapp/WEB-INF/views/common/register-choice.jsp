<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Choose Registration - InternTrack" />
<jsp:include page="header.jsp" />

<div class="container py-5 my-auto">
    <div class="text-center mb-5">
        <h2 class="fw-bold text-dark">Join the InternTrack Platform</h2>
        <p class="text-muted">Select your user role to create an account</p>
    </div>

    <div class="row justify-content-center g-4">
        <!-- Student Option -->
        <div class="col-md-5 col-lg-4">
            <div class="card card-custom h-100 p-4 text-center hover-shadow border">
                <div class="feature-icon-circle bg-primary bg-opacity-10 text-primary mx-auto mb-3">
                    <i class="bi bi-mortarboard-fill fs-2"></i>
                </div>
                <h4 class="fw-bold text-dark">Student</h4>
                <p class="text-muted small mb-4">
                    Register as a college student to explore faculty-approved internships, submit resumes, track applications, and verify completion certificates.
                </p>
                <a href="${pageContext.request.contextPath}/register/student" class="btn btn-primary mt-auto">
                    Register as Student <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

        <!-- Company Option -->
        <div class="col-md-5 col-lg-4">
            <div class="card card-custom h-100 p-4 text-center hover-shadow border">
                <div class="feature-icon-circle bg-warning bg-opacity-10 text-warning mx-auto mb-3">
                    <i class="bi bi-building fs-2"></i>
                </div>
                <h4 class="fw-bold text-dark">Company</h4>
                <p class="text-muted small mb-4">
                    Register as an enterprise partner to post internships, receive automated quality assessments, gain faculty approval, and recruit talented candidates.
                </p>
                <a href="${pageContext.request.contextPath}/register/company" class="btn btn-warning text-dark mt-auto">
                    Register as Company <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
    </div>

    <div class="text-center mt-5">
        <span class="text-muted small">Faculty and Admin accounts are provisioned by College IT. Already registered?</span>
        <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary small text-decoration-none ms-1">Log in here</a>
    </div>
</div>

<jsp:include page="footer.jsp" />
