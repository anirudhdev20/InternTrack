<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Review: ${internship.title} - InternTrack" />
<c:set var="activePage" value="reviews" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/faculty/reviews" class="text-decoration-none">Review Queue</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${internship.title}</li>
                </ol>
            </nav>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <span class="badge bg-warning bg-opacity-25 text-warning-emphasis fw-semibold px-2 py-1 mb-2">
                        <i class="bi bi-hourglass-split me-1"></i> Awaiting Faculty Quality Decision
                    </span>
                    <h2 class="fw-bold text-dark mb-1">${internship.title}</h2>
                    <p class="text-muted small mb-0">Posted by <strong>${internship.company.name}</strong> on ${internship.createdAt.toLocalDate()}</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/faculty/reviews" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-arrow-left me-1"></i> Back to Queue
                    </a>
                </div>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- PYTHON COMPLETENESS ASSESSMENT REPORT CARD -->
            <div class="card card-custom p-4 mb-4 border-primary border-2 shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="d-flex align-items-center gap-2">
                        <div class="p-2 bg-primary bg-opacity-10 text-primary rounded">
                            <i class="bi bi-cpu-fill fs-4"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold text-dark mb-0">Python Microservice Completeness Assessment Report</h5>
                            <span class="text-muted small">Automated rule-based quality evaluation</span>
                        </div>
                    </div>
                    <span class="badge bg-light text-secondary border">Status: ${assessment != null ? assessment.assessmentStatus : 'Pending'}</span>
                </div>

                <div class="row align-items-center g-4">
                    <div class="col-md-3 text-center border-end">
                        <c:set var="scoreClass" value="${assessment.score >= 80 ? 'score-high' : assessment.score >= 50 ? 'score-medium' : 'score-low'}" />
                        <div class="score-circle ${scoreClass} mb-2">
                            <span>${assessment != null ? assessment.score : 0}</span>
                            <span style="font-size: 0.7rem; font-weight: normal; margin-top: -5px;">/100</span>
                        </div>
                        <div class="fw-bold small text-dark">Completeness Score</div>
                    </div>

                    <div class="col-md-9">
                        <div class="p-3 bg-light rounded-3 mb-3">
                            <div class="fw-semibold text-dark small mb-1"><i class="bi bi-chat-quote-fill text-primary me-1"></i> System Recommendation:</div>
                            <div class="text-secondary small">${assessment != null ? assessment.recommendation : 'No assessment data available.'}</div>
                        </div>

                        <div class="row g-2">
                            <div class="col-md-6">
                                <div class="p-2 border rounded bg-white small">
                                    <strong class="text-danger"><i class="bi bi-exclamation-circle me-1"></i> Missing Details:</strong>
                                    <div class="text-muted mt-1">
                                        ${assessment != null && not empty assessment.missingDetails ? assessment.missingDetails : 'None flagged. All required sections present.'}
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="p-2 border rounded bg-white small">
                                    <strong class="text-warning text-dark"><i class="bi bi-shield-exclamation me-1"></i> Quality Warnings:</strong>
                                    <div class="text-muted mt-1">
                                        ${assessment != null && not empty assessment.warnings ? assessment.warnings : 'None. Specification satisfies standards.'}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert alert-light border small text-muted mt-3 mb-0">
                    <i class="bi bi-info-circle text-primary me-1"></i>
                    <strong>Academic Policy Note:</strong> The Python assessment is an automated decision-support metric. It does not replace human faculty discretion or approve/reject listings automatically. Faculty judgment is final.
                </div>
            </div>

            <!-- INTERNSHIP SPECIFICATIONS -->
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card card-custom p-4 mb-4">
                        <h5 class="fw-bold text-dark mb-3">Internship Job Description</h5>
                        <p class="text-secondary" style="line-height: 1.7; white-space: pre-line;">${internship.description}</p>

                        <h5 class="fw-bold text-dark mt-4 mb-2">Required Skills</h5>
                        <div class="d-flex flex-wrap gap-2 mb-3">
                            <c:forEach items="${internship.requiredSkills.split(',')}" var="s">
                                <span class="badge bg-secondary bg-opacity-10 text-secondary border px-3 py-2">${s.trim()}</span>
                            </c:forEach>
                        </div>

                        <h5 class="fw-bold text-dark mt-4 mb-2">Academic Eligibility</h5>
                        <p class="text-secondary">${not empty internship.eligibility ? internship.eligibility : 'N/A'}</p>
                        <c:if test="${not empty internship.departmentPreference}">
                            <div class="small text-muted mb-3">
                                <strong>Department Preference:</strong> ${internship.departmentPreference}
                            </div>
                        </c:if>

                        <h5 class="fw-bold text-dark mt-4 mb-2">Mentorship Plan</h5>
                        <div class="p-3 bg-light rounded border text-secondary small">
                            ${not empty internship.mentorshipDetails ? internship.mentorshipDetails : 'No mentorship details specified by company.'}
                        </div>
                    </div>
                </div>

                <!-- Right Sidebar Details & Decision Form -->
                <div class="col-lg-4">
                    <!-- Key Parameters -->
                    <div class="card card-custom p-4 mb-4">
                        <h6 class="fw-bold text-dark mb-3">Offering Parameters</h6>
                        <ul class="list-unstyled small mb-0">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Work Mode:</span>
                                <strong>${internship.workMode}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Location:</span>
                                <strong>${internship.location}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Monthly Stipend:</span>
                                <strong class="text-success">${internship.stipend}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Duration:</span>
                                <strong>${internship.duration}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Vacancies:</span>
                                <strong>${internship.vacancies} positions</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2">
                                <span class="text-muted">Application Deadline:</span>
                                <strong class="text-danger">${internship.deadline != null ? internship.deadline : 'Open'}</strong>
                            </li>
                        </ul>
                    </div>

                    <!-- Faculty Decision Card -->
                    <div class="card card-custom p-4 border-2 border-primary shadow">
                        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-shield-check text-primary me-2"></i>Faculty Review Decision</h5>

                        <!-- Approve Form -->
                        <form action="${pageContext.request.contextPath}/faculty/reviews/${internship.id}/decide" method="post" class="mb-3">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="decision" value="APPROVED"/>
                            <button type="submit" class="btn btn-success btn-lg w-100 shadow-sm" onclick="return confirmAction('Approve listing &quot;${internship.title}&quot;? It will immediately become visible to all eligible students.');">
                                <i class="bi bi-check-circle-fill me-1"></i> Approve Internship
                            </button>
                        </form>

                        <hr>

                        <!-- Reject Form -->
                        <form action="${pageContext.request.contextPath}/faculty/reviews/${internship.id}/decide" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="decision" value="REJECTED"/>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-danger">Rejection Reason / Feedback *</label>
                                <textarea class="form-control" name="reason" rows="3" placeholder="Explain missing elements or academic shortcomings for company revision..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-outline-danger w-100" onclick="return confirmAction('Reject this listing and send feedback to the company?');">
                                <i class="bi bi-x-circle-fill me-1"></i> Reject & Request Revision
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
