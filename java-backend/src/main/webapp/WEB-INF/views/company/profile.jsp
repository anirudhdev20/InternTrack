<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Company Profile - InternTrack" />
<c:set var="activePage" value="profile" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1">Company Profile</h2>
                <p class="text-muted small mb-0">Update company identity, website, and recruitment contact information</p>
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
                        <form action="${pageContext.request.contextPath}/company/profile" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-muted">Account Representative</label>
                                    <input type="text" class="form-control bg-light" value="${user.name}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small text-muted">Account Email</label>
                                    <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small">Company Name *</label>
                                    <input type="text" class="form-control" name="companyName" value="${profile.companyName}" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small">Official Website</label>
                                    <input type="url" class="form-control" name="website" value="${profile.website}" placeholder="https://example.com">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold small">Contact Phone Number</label>
                                    <input type="text" class="form-control" name="contactNumber" value="${profile.contactNumber}" placeholder="+1-555-019-2831">
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label fw-semibold small">Company Overview</label>
                                    <textarea class="form-control" name="description" rows="4" placeholder="Overview of company products, engineering domains, and work environment...">${profile.description}</textarea>
                                </div>
                            </div>

                            <div class="mt-4 pt-3 border-top">
                                <button type="submit" class="btn btn-warning text-dark fw-semibold px-4">
                                    <i class="bi bi-check-lg me-1"></i> Update Profile
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-custom p-4 bg-light border">
                        <h5 class="fw-bold mb-3"><i class="bi bi-patch-check-fill text-warning me-2"></i>Partner Verification</h5>
                        <p class="text-muted small">
                            Company profiles are visible to faculty during the internship review process and to students applying for approved listings.
                        </p>
                        <hr>
                        <div class="small mb-2">
                            <strong>Role:</strong> <span class="badge bg-warning text-dark">COMPANY</span>
                        </div>
                        <div class="small mb-2">
                            <strong>Account Status:</strong> <span class="badge bg-success">ACTIVE</span>
                        </div>
                        <div class="small">
                            <strong>Registered Since:</strong> ${user.createdAt.toLocalDate()}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
