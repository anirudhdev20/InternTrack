<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Dashboard - InternTrack" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header Welcome -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Faculty Oversight Portal</h2>
                    <p class="text-muted small mb-0">Welcome, ${faculty.name} &middot; Quality control, review approvals, and monitor student academic compliance</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/faculty/reviews" class="btn btn-primary position-relative">
                        <i class="bi bi-shield-check me-1"></i> Review Queue
                        <c:if test="${pendingReviews > 0}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                ${pendingReviews}
                            </span>
                        </c:if>
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
                            <div class="stat-number text-warning">${pendingReviews}</div>
                            <div class="stat-label">Pending Reviews</div>
                        </div>
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-shield-exclamation"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-success">${approvedListings}</div>
                            <div class="stat-label">Approved Listings</div>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-danger">${rejectedListings}</div>
                            <div class="stat-label">Rejected Listings</div>
                        </div>
                        <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                            <i class="bi bi-x-octagon"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-primary">${totalListings}</div>
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
                            <div class="stat-number text-info">${totalStudents}</div>
                            <div class="stat-label">Registered Students</div>
                        </div>
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-mortarboard-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-secondary">${totalApplications}</div>
                            <div class="stat-label">Student Applications</div>
                        </div>
                        <div class="stat-icon bg-secondary bg-opacity-10 text-secondary">
                            <i class="bi bi-send-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-success">${selectedStudents}</div>
                            <div class="stat-label">Selected Students</div>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-person-check-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-primary">${completedInternships}</div>
                            <div class="stat-label">Verified Completions</div>
                        </div>
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-award-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Review Queue -->
            <div class="card card-custom">
                <div class="card-custom-header">
                    <h5><i class="bi bi-hourglass-split text-warning me-2"></i>Urgent: Internships Awaiting Faculty Decision</h5>
                    <a href="${pageContext.request.contextPath}/faculty/reviews" class="btn btn-sm btn-outline-primary">View Full Queue</a>
                </div>
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty pendingQueue}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-check-circle-fill fs-1 text-success d-block mb-2"></i>
                                <h6>Review Queue is Clear!</h6>
                                <p class="small mb-0">All submitted company internship opportunities have been evaluated.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Internship Title</th>
                                            <th>Company Name</th>
                                            <th>Python Completeness</th>
                                            <th>Stipend & Duration</th>
                                            <th>Location & Mode</th>
                                            <th>Submission Date</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pendingQueue}" var="item">
                                            <tr>
                                                <td class="fw-bold text-dark">${item.title}</td>
                                                <td>${item.company.name}</td>
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
                                                <td>${item.stipend} &middot; <span class="text-muted small">${item.duration}</span></td>
                                                <td>${item.location} <span class="badge bg-light text-dark border ms-1">${item.workMode}</span></td>
                                                <td>${item.createdAt.toLocalDate()}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/faculty/reviews/${item.id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-eye me-1"></i> Review Listing
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
