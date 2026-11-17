<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${internship.title} - InternTrack" />
<c:set var="activePage" value="internships" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/internships" class="text-decoration-none">Internships</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${internship.title}</li>
                </ol>
            </nav>

            <div class="row g-4">
                <div class="col-lg-8">
                    <!-- Main Card -->
                    <div class="card card-custom p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <span class="badge bg-success bg-opacity-10 text-success fw-semibold px-2 py-1 mb-2">
                                    <i class="bi bi-shield-check me-1"></i> Faculty Verified
                                </span>
                                <h2 class="fw-bold text-dark mb-1">${internship.title}</h2>
                                <div class="text-muted small">
                                    <i class="bi bi-building me-1"></i> <strong>${internship.company.name}</strong> &middot; Posted on ${internship.createdAt.toLocalDate()}
                                </div>
                            </div>
                            <span class="badge bg-light text-dark border fs-6 px-3 py-2">
                                ${internship.workMode}
                            </span>
                        </div>

                        <hr class="my-4">

                        <h5 class="fw-bold text-dark mb-3">About the Internship</h5>
                        <p class="text-secondary" style="line-height: 1.7; white-space: pre-line;">
                            ${internship.description}
                        </p>

                        <h5 class="fw-bold text-dark mt-4 mb-3">Required Technical Skills</h5>
                        <div class="d-flex flex-wrap gap-2 mb-4">
                            <c:forEach items="${internship.requiredSkills.split(',')}" var="skill">
                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-2 fs-6">
                                    ${skill.trim()}
                                </span>
                            </c:forEach>
                        </div>

                        <h5 class="fw-bold text-dark mt-4 mb-3">Academic Eligibility & Prerequisites</h5>
                        <p class="text-secondary">
                            ${not empty internship.eligibility ? internship.eligibility : "Open to all eligible engineering students."}
                        </p>
                        <c:if test="${not empty internship.departmentPreference}">
                            <div class="small text-muted mb-3">
                                <strong>Preferred Department:</strong> ${internship.departmentPreference}
                            </div>
                        </c:if>

                        <h5 class="fw-bold text-dark mt-4 mb-3">Mentorship & Supervision Structure</h5>
                        <div class="p-3 bg-light rounded-3 border">
                            <i class="bi bi-person-video3 text-primary me-2"></i>
                            <span class="text-secondary">
                                ${not empty internship.mentorshipDetails ? internship.mentorshipDetails : "Regular mentorship and technical reviews provided by senior company engineers."}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Right Sidebar Details & Application CTA -->
                <div class="col-lg-4">
                    <div class="card card-custom p-4 sticky-top" style="top: 85px;">
                        <h5 class="fw-bold mb-3 text-dark">Internship Summary</h5>

                        <ul class="list-unstyled mb-4 small">
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Monthly Stipend:</span>
                                <strong class="text-success">${internship.stipend}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Duration:</span>
                                <strong>${internship.duration}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Work Location:</span>
                                <strong>${internship.location}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Available Vacancies:</span>
                                <strong>${internship.vacancies} positions</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Application Deadline:</span>
                                <strong class="text-danger">${internship.deadline != null ? internship.deadline : "Open"}</strong>
                            </li>
                            <li class="d-flex justify-content-between py-2">
                                <span class="text-muted">Review Status:</span>
                                <span class="badge-status badge-approved">Approved</span>
                            </li>
                        </ul>

                        <c:choose>
                            <c:when test="${alreadyApplied}">
                                <div class="alert alert-info text-center small mb-0" role="alert">
                                    <i class="bi bi-info-circle-fill me-1"></i> You have already applied for this internship.
                                    <div class="mt-2">
                                        <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-sm btn-outline-info">Track Application</a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/student/apply/${internship.id}" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary btn-lg shadow-sm" onclick="return confirmAction('Submit your application for ${internship.title}?');">
                                            <i class="bi bi-send-fill me-1"></i> Apply Now
                                        </button>
                                    </div>
                                </form>
                                <div class="text-muted small text-center mt-2">
                                    Your registered profile and uploaded resume will be shared with the company.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
