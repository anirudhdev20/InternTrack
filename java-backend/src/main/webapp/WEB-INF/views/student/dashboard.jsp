<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Dashboard - InternTrack" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header Welcome -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Welcome back, ${student.name}!</h2>
                    <p class="text-muted small mb-0">Track your applications, browse verified roles, and monitor selection progress</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-primary">
                        <i class="bi bi-search me-1"></i> Browse Internships
                    </a>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-1"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Stat Cards Row -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-primary">${availableInternships}</div>
                            <div class="stat-label">Available</div>
                        </div>
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-briefcase-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-secondary">${totalApplied}</div>
                            <div class="stat-label">Applied</div>
                        </div>
                        <div class="stat-icon bg-secondary bg-opacity-10 text-secondary">
                            <i class="bi bi-send-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-warning">${underReview}</div>
                            <div class="stat-label">In Review</div>
                        </div>
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-info">${shortlisted}</div>
                            <div class="stat-label">Shortlisted</div>
                        </div>
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-star-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-success">${selected}</div>
                            <div class="stat-label">Selected</div>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-trophy-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-danger">${rejected}</div>
                            <div class="stat-label">Rejected</div>
                        </div>
                        <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                            <i class="bi bi-x-circle-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Applications Table -->
            <div class="card card-custom">
                <div class="card-custom-header">
                    <h5><i class="bi bi-clock-history text-primary me-2"></i>Recent Application Activity</h5>
                    <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-sm btn-outline-primary">View All</a>
                </div>
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty recentApplications}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                <h6>No internship applications yet</h6>
                                <p class="small mb-3">Browse faculty-approved listings to find the right opportunity!</p>
                                <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-primary btn-sm">Browse Internships</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Internship</th>
                                            <th>Company</th>
                                            <th>Stipend</th>
                                            <th>Location</th>
                                            <th>Applied On</th>
                                            <th>Recruitment Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentApplications}" var="app">
                                            <tr>
                                                <td class="fw-semibold text-dark">${app.internship.title}</td>
                                                <td>${app.internship.company.name}</td>
                                                <td><span class="badge bg-light text-dark border">${app.internship.stipend}</span></td>
                                                <td>${app.internship.location}</td>
                                                <td>${app.appliedAt.toLocalDate()}</td>
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
                                                    <a href="${pageContext.request.contextPath}/student/internships/${app.internship.id}" class="btn btn-sm btn-light border">
                                                        View Details
                                                    </a>
                                                </td>
                                            </tr>
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
