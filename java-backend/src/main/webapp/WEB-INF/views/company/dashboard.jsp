<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Company Dashboard - InternTrack" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header Welcome -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">${company.name}</h2>
                    <p class="text-muted small mb-0">Manage internship opportunities, track faculty review status, and evaluate candidate applications</p>
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

            <!-- Stat Cards Row -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-primary">${totalPosted}</div>
                            <div class="stat-label">Total Listings</div>
                        </div>
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-briefcase-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-warning">${pendingReviews}</div>
                            <div class="stat-label">Pending Faculty Review</div>
                        </div>
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-success">${approved}</div>
                            <div class="stat-label">Approved & Active</div>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-danger">${rejected}</div>
                            <div class="stat-label">Revisions Requested</div>
                        </div>
                        <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                            <i class="bi bi-exclamation-octagon-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-secondary">${totalApplicants}</div>
                            <div class="stat-label">Total Applicants</div>
                        </div>
                        <div class="stat-icon bg-secondary bg-opacity-10 text-secondary">
                            <i class="bi bi-people-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-info">${shortlisted}</div>
                            <div class="stat-label">Shortlisted Candidates</div>
                        </div>
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-star-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-success">${selected}</div>
                            <div class="stat-label">Selected Hires</div>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-person-check-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Applicants -->
            <div class="card card-custom">
                <div class="card-custom-header">
                    <h5><i class="bi bi-person-lines-fill text-primary me-2"></i>Recent Student Applications</h5>
                    <a href="${pageContext.request.contextPath}/company/applicants" class="btn btn-sm btn-outline-primary">Manage All Applicants</a>
                </div>
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty recentApplicants}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                <h6>No applicants received yet</h6>
                                <p class="small mb-0">Once faculty approves your listings, eligible students can apply.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Applicant</th>
                                            <th>Department</th>
                                            <th>Internship Role</th>
                                            <th>Applied Date</th>
                                            <th>Current Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentApplicants}" var="app">
                                            <tr>
                                                <td class="fw-semibold text-dark">${app.student.name}</td>
                                                <td>${app.student.department != null ? app.student.department.departmentName : 'N/A'}</td>
                                                <td>${app.internship.title}</td>
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
                                                    <a href="${pageContext.request.contextPath}/company/applicants?internshipId=${app.internship.id}" class="btn btn-sm btn-light border">
                                                        Review Applicant
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
