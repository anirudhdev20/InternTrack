<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Company Registration - InternTrack" />
<jsp:include page="header.jsp" />

<div class="container py-5 my-auto">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card card-custom p-4 shadow">
                <div class="text-center mb-4">
                    <div class="brand-badge bg-warning d-inline-block mb-2 p-2 text-dark">
                        <i class="bi bi-building fs-2"></i>
                    </div>
                    <h3 class="fw-bold text-dark">Company Partner Registration</h3>
                    <p class="text-muted small">Register to post internships and recruit vetted engineering students</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register/company" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Company Legal Name *</label>
                            <input type="text" class="form-control" name="companyName" placeholder="TechNova Solutions Ltd." required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">HR / Representative Name *</label>
                            <input type="text" class="form-control" name="name" placeholder="Johnathan Reed" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Work Email Address *</label>
                            <input type="email" class="form-control" name="email" placeholder="hr@technova.com" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Account Password *</label>
                            <input type="password" class="form-control" name="password" placeholder="Minimum 6 characters" required minlength="6">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Official Website</label>
                            <input type="url" class="form-control" name="website" placeholder="https://technova.example.com">
                        </div>

                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Contact Phone Number</label>
                            <input type="text" class="form-control" name="contactNumber" placeholder="+1-555-019-2831">
                        </div>

                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Brief Company Description</label>
                            <textarea class="form-control" name="description" rows="3" placeholder="Describe your company, engineering domains, and work culture..."></textarea>
                        </div>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-warning text-dark btn-lg shadow-sm fw-semibold">
                            <i class="bi bi-building-add me-1"></i> Register Company Account
                        </button>
                    </div>
                </form>

                <div class="text-center mt-4 pt-3 border-top">
                    <span class="text-muted small">Already registered?</span>
                    <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary small text-decoration-none ms-1">Log in here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
