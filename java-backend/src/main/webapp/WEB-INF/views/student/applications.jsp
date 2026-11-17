<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Applications - InternTrack" />
<c:set var="activePage" value="applications" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">My Submitted Applications</h2>
                    <p class="text-muted small mb-0">Track company recruitment status, interview notices, and progress logs</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-search me-1"></i> Browse More
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
                        <c:when test="${empty applications}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-3 text-secondary"></i>
                                <h5>No applications found</h5>
                                <p class="small mb-3">You have not submitted any internship applications yet.</p>
                                <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-primary btn-sm">
                                    Browse Approved Internships
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Internship Title</th>
                                            <th>Company</th>
                                            <th>Applied Date</th>
                                            <th>Stipend</th>
                                            <th>Location</th>
                                            <th>Recruitment Status</th>
                                            <th>Timeline & Details</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${applications}" var="app">
                                            <tr>
                                                <td class="fw-semibold text-dark">${app.internship.title}</td>
                                                <td>${app.internship.company.name}</td>
                                                <td>${app.appliedAt.toLocalDate()}</td>
                                                <td><span class="badge bg-light text-dark border">${app.internship.stipend}</span></td>
                                                <td>${app.internship.location}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${app.status == 'APPLIED'}"><span class="badge-status badge-applied">Applied</span></c:when>
                                                        <c:when test="${app.status == 'UNDER_REVIEW'}"><span class="badge-status badge-review">Under Review</span></c:when>
                                                        <c:when test="${app.status == 'SHORTLISTED'}"><span class="badge-status badge-shortlisted">Shortlisted</span></c:when>
                                                        <c:when test="${app.status == 'INTERVIEW_SCHEDULED'}"><span class="badge-status badge-interview">Interview Scheduled</span></c:when>
                                                        <c:when test="${app.status == 'SELECTED'}"><span class="badge-status badge-selected">Selected</span></c:when>
                                                        <c:otherwise><span class="badge-status badge-rejected">Rejected</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-secondary" type="button" data-bs-toggle="modal" data-bs-target="#historyModal${app.id}">
                                                        <i class="bi bi-clock-history me-1"></i> View History
                                                    </button>

                                                    <c:if test="${app.status == 'SELECTED'}">
                                                        <a href="${pageContext.request.contextPath}/student/progress" class="btn btn-sm btn-success ms-1">
                                                            <i class="bi bi-patch-check me-1"></i> Submit Progress
                                                        </a>
                                                    </c:if>
                                                </td>
                                            </tr>

                                            <!-- History Modal -->
                                            <div class="modal fade" id="historyModal${app.id}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title fw-bold">Status History - ${app.internship.title}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body p-4">
                                                            <div class="timeline">
                                                                <c:choose>
                                                                    <c:when test="${empty app.statusHistory}">
                                                                        <p class="text-muted small">Application received. No status transitions recorded yet.</p>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <ul class="list-group list-group-flush">
                                                                            <c:forEach items="${app.statusHistory}" var="h">
                                                                                <li class="list-group-item px-0 py-2 border-bottom">
                                                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                                                        <span class="badge bg-primary text-uppercase">${h.newStatus}</span>
                                                                                        <span class="text-muted small">${h.updatedAt}</span>
                                                                                    </div>
                                                                                    <div class="small text-secondary">
                                                                                        <strong>Updated By:</strong> ${h.updatedBy.name}
                                                                                    </div>
                                                                                    <c:if test="${not empty h.remarks}">
                                                                                        <div class="p-2 bg-light rounded mt-1 small text-dark">
                                                                                            <em>"${h.remarks}"</em>
                                                                                        </div>
                                                                                    </c:if>
                                                                                </li>
                                                                            </c:forEach>
                                                                        </ul>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
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
