<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Log In - InternTrack" />
<jsp:include page="header.jsp" />

<div class="container py-5 my-auto">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card card-custom p-4 shadow">
                <div class="text-center mb-4">
                    <div class="brand-badge d-inline-block mb-2 p-2">
                        <i class="bi bi-mortarboard-fill fs-2"></i>
                    </div>
                    <h3 class="fw-bold text-dark">Welcome Back</h3>
                    <p class="text-muted small">Sign in to your InternTrack portal</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show small" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold small">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-secondary"></i></span>
                            <input type="email" class="form-control border-start-0" id="email" name="email" placeholder="name@college.edu or name@company.com" required autofocus>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label fw-semibold small">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock text-secondary"></i></span>
                            <input type="password" class="form-control border-start-0" id="password" name="password" placeholder="••••••••" required>
                        </div>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary btn-lg shadow-sm">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                        </button>
                    </div>
                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <span class="text-muted small">Don't have an account?</span>
                    <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary small text-decoration-none ms-1">Register Now</a>
                </div>
            </div>

            <!-- Demo Helper Accordion -->
            <div class="accordion mt-3" id="demoAccountsAccordion">
                <div class="accordion-item border-0 bg-transparent">
                    <h2 class="accordion-header">
                        <button class="accordion-button collapsed py-2 px-3 bg-white rounded shadow-sm text-secondary small" type="button" data-bs-toggle="collapse" data-bs-target="#demoAccounts">
                            <i class="bi bi-info-circle me-2 text-primary"></i> Need demo credentials? Click here
                        </button>
                    </h2>
                    <div id="demoAccounts" class="accordion-collapse collapse" data-bs-parent="#demoAccountsAccordion">
                        <div class="accordion-body bg-white rounded shadow-sm mt-1 p-3 small">
                            <div class="mb-2"><strong>Password:</strong> <code>password123</code></div>
                            <ul class="list-unstyled mb-0">
                                <li class="mb-1"><strong>Student:</strong> <code>alex.rivera@student.edu</code></li>
                                <li class="mb-1"><strong>Company:</strong> <code>hr@technova.com</code></li>
                                <li class="mb-1"><strong>Faculty:</strong> <code>faculty.cse@interntrack.edu</code></li>
                                <li><strong>Admin:</strong> <code>admin@interntrack.edu</code></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
