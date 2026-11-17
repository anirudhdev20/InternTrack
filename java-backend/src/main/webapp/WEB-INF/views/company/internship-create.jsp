<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Post New Internship - InternTrack" />
<c:set var="activePage" value="create-internship" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/company/internships" class="text-decoration-none">Internships</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Post New</li>
                </ol>
            </nav>

            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1">Create Internship Listing</h2>
                <p class="text-muted small mb-0">Listings are evaluated by the Python completeness engine and forwarded to faculty for approval</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card card-custom p-4">
                <form action="${pageContext.request.contextPath}/company/internships/create" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold small">Internship Title *</label>
                            <input type="text" class="form-control" name="title" placeholder="e.g. Full Stack Java Developer Intern" required minlength="5">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">Work Mode *</label>
                            <select class="form-select" name="workMode" required>
                                <option value="ON_SITE">On-Site</option>
                                <option value="REMOTE">Remote</option>
                                <option value="HYBRID" selected>Hybrid</option>
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Detailed Job Description & Responsibilities *</label>
                            <textarea class="form-control" name="description" rows="4" placeholder="Detail sprint responsibilities, day-to-day deliverables, tools, and technical environment..." required minlength="20"></textarea>
                            <span class="text-muted small">Higher detail scores better in the Python completeness assessment.</span>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Required Technical Skills *</label>
                            <input type="text" class="form-control" name="requiredSkills" placeholder="e.g. Java, Spring Boot, MySQL, REST API, Git" required>
                            <span class="text-muted small">Provide comma-separated skills.</span>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Eligibility Requirements *</label>
                            <input type="text" class="form-control" name="eligibility" placeholder="e.g. B.Tech CSE/IT 3rd or 4th Year with min 6.5 CGPA" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Department Preference</label>
                            <select class="form-select" name="departmentPreference">
                                <option value="All Departments">All Departments</option>
                                <c:forEach items="${departments}" var="dept">
                                    <option value="${dept.departmentName}">${dept.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Duration *</label>
                            <input type="text" class="form-control" name="duration" placeholder="e.g. 3 Months or 6 Months" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Stipend Amount *</label>
                            <input type="text" class="form-control" name="stipend" placeholder="e.g. $800/month or Negotiable" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Work Location / Base Office *</label>
                            <input type="text" class="form-control" name="location" placeholder="e.g. Calicut / Bangalore or Remote" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Available Positions *</label>
                            <input type="number" class="form-control" name="vacancies" value="1" min="1" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Application Deadline *</label>
                            <input type="date" class="form-control" name="deadlineStr" required>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label fw-semibold small">Mentorship & Supervision Details *</label>
                            <textarea class="form-control" name="mentorshipDetails" rows="2" placeholder="Describe designated mentors, supervision frequency, and weekly code review structure..." required></textarea>
                            <span class="text-muted small">Academic policy mandates designated mentorship for college credit approval.</span>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 border-top d-flex gap-2">
                        <button type="submit" class="btn btn-warning text-dark fw-semibold px-4">
                            <i class="bi bi-cloud-arrow-up-fill me-1"></i> Submit for Faculty Review
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
