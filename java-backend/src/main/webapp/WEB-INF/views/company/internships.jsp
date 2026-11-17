<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Internship Listings - InternTrack" />
<c:set var="activePage" value="internships" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Company Internship Listings</h2>
                    <p class="text-muted small mb-0">Track listing status, review faculty decisions, and update opportunities</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/company/internships/create" class="btn btn-warning text-dark fw-semibold">
                        <i class="bi bi-plus-circle-fill me-1"></i> Post New Internship
                    </a>
                </div>
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

            <div class="card card-custom">
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty internships}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-briefcase fs-1 d-block mb-3 text-secondary"></i>
                                <h5>No internships posted yet</h5>
                                <p class="small mb-3">Create your first internship listing to receive Python assessment and faculty verification.</p>
                                <a href="${pageContext.request.contextPath}/company/internships/create" class="btn btn-warning text-dark fw-semibold btn-sm">
                                    Post An Internship
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Role Title</th>
                                            <th>Mode</th>
                                            <th>Stipend</th>
                                            <th>Duration</th>
                                            <th>Python Completeness</th>
                                            <th>Faculty Review Status</th>
                                            <th>Applicants</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${internships}" var="item">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${item.title}</div>
                                                    <span class="text-muted small"><i class="bi bi-geo-alt me-1"></i>${item.location} &middot; ${item.vacancies} Pos.</span>
                                                </td>
                                                <td><span class="badge bg-light text-dark border">${item.workMode}</span></td>
                                                <td><span class="fw-semibold text-success">${item.stipend}</span></td>
                                                <td>${item.duration}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.assessment != null}">
                                                            <span class="badge ${item.assessment.score >= 80 ? 'bg-success' : item.assessment.score >= 50 ? 'bg-warning text-dark' : 'bg-danger'} px-2 py-1">
                                                                <i class="bi bi-cpu me-1"></i> ${item.assessment.score}/100
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.reviewStatus == 'APPROVED'}">
                                                            <span class="badge-status badge-approved">Approved</span>
                                                        </c:when>
                                                        <c:when test="${item.reviewStatus == 'PENDING_REVIEW'}">
                                                            <span class="badge-status badge-pending">Pending Review</span>
                                                        </c:when>
                                                        <c:when test="${item.reviewStatus == 'REJECTED'}">
                                                            <span class="badge-status badge-rejected">Rejected</span>
                                                            <button class="btn btn-link btn-sm text-danger p-0 ms-1" type="button" data-bs-toggle="modal" data-bs-target="#reasonModal${item.id}">
                                                                <i class="bi bi-info-circle"></i> Reason
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status badge-closed">Closed</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/company/applicants?internshipId=${item.id}" class="badge bg-primary text-decoration-none px-2 py-1">
                                                        ${item.applications.size()} Applicants
                                                    </a>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/company/internships/edit/${item.id}" class="btn btn-sm btn-outline-primary" title="Edit & Resubmit">
                                                        <i class="bi bi-pencil-square"></i> Edit
                                                    </a>
                                                </td>
                                            </tr>

                                            <!-- Rejection Reason Modal -->
                                            <c:if test="${item.reviewStatus == 'REJECTED'}">
                                                <div class="modal fade" id="reasonModal${item.id}" tabindex="-1" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header bg-danger text-white">
                                                                <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-triangle-fill me-2"></i>Faculty Feedback: ${item.title}</h5>
                                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body p-4">
                                                                <p class="text-muted small mb-2">Faculty reviewed this listing and provided the following feedback for required revision:</p>
                                                                <div class="p-3 bg-light rounded border text-danger fw-semibold">
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.reviews}">
                                                                            "${item.reviews[0].reason}"
                                                                            <div class="mt-2 text-muted small fw-normal">
                                                                                Reviewed by: ${item.reviews[0].faculty.name} on ${item.reviews[0].reviewedAt}
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Feedback details unavailable.
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="alert alert-info mt-3 small mb-0">
                                                                    <i class="bi bi-info-circle-fill me-1"></i> You can edit this listing to address the faculty comments. When saved, the status will automatically reset to <strong>PENDING_REVIEW</strong> for faculty re-evaluation.
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                                <a href="${pageContext.request.contextPath}/company/internships/edit/${item.id}" class="btn btn-primary btn-sm">Edit Now</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
