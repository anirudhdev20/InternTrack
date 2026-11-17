<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Edit Internship - InternTrack" />
<c:set var="activePage" value="internships" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/company/internships" class="text-decoration-none">Internships</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Edit Listing</li>
                </ol>
            </nav>

            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1">Edit & Resubmit Internship</h2>
                <p class="text-muted small mb-0">Updating this listing will re-run the Python assessment and return the opportunity to faculty review</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${internship.reviewStatus == 'REJECTED' && not empty internship.reviews}">
                <div class="alert alert-danger mb-4 shadow-sm">
                    <h6 class="fw-bold mb-1"><i class="bi bi-exclamation-triangle-fill me-1"></i> Faculty Revision Requested</h6>
                    <p class="mb-1 small"><strong>Feedback:</strong> "${internship.reviews[0].reason}"</p>
                    <span class="small text-muted">Reviewed by: ${internship.reviews[0].faculty.name}</span>
                </div>
            </c:if>

            <div class="card card-custom p-4">
                <form action="${pageContext.request.contextPath}/company/internships/edit/${internship.id}" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold small">Internship Title *</label>
                            <input type="text" class="form-control" name="title" value="${internship.title}" required minlength="5">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">Work Mode *</label>
                            <select class="form-select" name="workMode" required>
                                <option value="ON_SITE" ${internship.workMode == 'ON_SITE' ? 'selected' : ''}>On-Site</option>
                                <option value="REMOTE" ${internship.workMode == 'REMOTE' ? 'selected' : ''}>Remote</option>
                                <option value="HYBRID" ${internship.workMode == 'HYBRID' ? 'selected' : ''}>Hybrid</option>
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Detailed Job Description & Responsibilities *</label>
                            <textarea class="form-control" name="description" rows="4" required minlength="20">${internship.description}</textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Required Technical Skills *</label>
                            <input type="text" class="form-control" name="requiredSkills" value="${internship.requiredSkills}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Eligibility Requirements *</label>
                            <input type="text" class="form-control" name="eligibility" value="${internship.eligibility}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Department Preference</label>
                            <select class="form-select" name="departmentPreference">
                                <option value="All Departments">All Departments</option>
                                <c:forEach items="${departments}" var="dept">
                                    <option value="${dept.departmentName}" ${internship.departmentPreference == dept.departmentName ? 'selected' : ''}>${dept.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Duration *</label>
                            <input type="text" class="form-control" name="duration" value="${internship.duration}" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Stipend Amount *</label>
                            <input type="text" class="form-control" name="stipend" value="${internship.stipend}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Work Location / Base Office *</label>
                            <input type="text" class="form-control" name="location" value="${internship.location}" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Available Positions *</label>
                            <input type="number" class="form-control" name="vacancies" value="${internship.vacancies}" min="1" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Application Deadline *</label>
                            <input type="date" class="form-control" name="deadlineStr" value="${internship.deadline}" required>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Mentorship & Supervision Details *</label>
                            <textarea class="form-control" name="mentorshipDetails" rows="2" required>${internship.mentorshipDetails}</textarea>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 border-top d-flex gap-2">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-arrow-repeat me-1"></i> Resubmit for Faculty Review
                        </button>
                        <a href="${pageContext.request.contextPath}/company/internships" class="btn btn-outline-secondary">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
