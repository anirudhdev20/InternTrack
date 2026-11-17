<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Manage Applicants - InternTrack" />
<c:set var="activePage" value="applicants" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Student Applicants</h2>
                    <p class="text-muted small mb-0">Evaluate candidates, review technical skills & resumes, and update recruitment status</p>
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

            <!-- Filter by Internship -->
            <div class="card card-custom p-3 mb-4">
                <form action="${pageContext.request.contextPath}/company/applicants" method="get" class="row g-2 align-items-center">
                    <div class="col-auto">
                        <label class="fw-semibold small text-muted"><i class="bi bi-filter me-1"></i>Filter by Listing:</label>
                    </div>
                    <div class="col-md-5">
                        <select class="form-select form-select-sm" name="internshipId" onchange="this.form.submit()">
                            <option value="">All Company Internships</option>
                            <c:forEach items="${myInternships}" var="intern">
                                <option value="${intern.id}" ${selectedInternshipId == intern.id ? 'selected' : ''}>${intern.title}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <c:if test="${not empty selectedInternshipId}">
                        <div class="col-auto">
                            <a href="${pageContext.request.contextPath}/company/applicants" class="btn btn-sm btn-link text-decoration-none">Clear Filter</a>
                        </div>
                    </c:if>
                </form>
            </div>

            <!-- Applicants Table -->
            <div class="card card-custom">
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty applications}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-people fs-1 d-block mb-3 text-secondary"></i>
                                <h5>No applicants found</h5>
                                <p class="small mb-0">Student applications will appear here as they apply for your approved listings.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Student Candidate</th>
                                            <th>Academic Details</th>
                                            <th>Internship Role</th>
                                            <th>Technical Skills</th>
                                            <th>Resume</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${applications}" var="app">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${app.student.name}</div>
                                                    <span class="text-muted small">${app.student.email}</span>
                                                    <c:if test="${app.student.studentProfile != null && not empty app.student.studentProfile.phone}">
                                                        <div class="text-muted small"><i class="bi bi-telephone me-1"></i>${app.student.studentProfile.phone}</div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="small fw-semibold">${app.student.department != null ? app.student.department.departmentName : 'N/A'}</div>
                                                    <span class="badge bg-light text-secondary border small">${app.student.studentProfile != null ? app.student.studentProfile.academicYear : 'Student'}</span>
                                                </td>
                                                <td>
                                                    <span class="fw-semibold text-primary">${app.internship.title}</span>
                                                    <div class="text-muted small">Applied on ${app.appliedAt.toLocalDate()}</div>
                                                </td>
                                                <td style="max-width: 220px;">
                                                    <span class="small text-secondary">${app.student.studentProfile != null && not empty app.student.studentProfile.skills ? app.student.studentProfile.skills : 'Not specified'}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${app.student.studentProfile != null && not empty app.student.studentProfile.resumePath}">
                                                            <a href="${pageContext.request.contextPath}/uploads/${app.student.studentProfile.resumePath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                                                <i class="bi bi-file-earmark-pdf me-1"></i> View Resume
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-muted border">No Resume</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
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
                                                    <button class="btn btn-sm btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#statusModal${app.id}">
                                                        Update Status
                                                    </button>
                                                </td>
                                            </tr>

                                            <!-- Update Status Modal -->
                                            <div class="modal fade" id="statusModal${app.id}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <form action="${pageContext.request.contextPath}/company/applicants/${app.id}/status" method="post">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                                            <div class="modal-header">
                                                                <h5 class="modal-title fw-bold">Update Status - ${app.student.name}</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body p-4">
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-semibold small">Candidate Recruitment Decision *</label>
                                                                    <select class="form-select" name="newStatus" required>
                                                                        <option value="UNDER_REVIEW" ${app.status == 'UNDER_REVIEW' ? 'selected' : ''}>Under Review</option>
                                                                        <option value="SHORTLISTED" ${app.status == 'SHORTLISTED' ? 'selected' : ''}>Shortlist for Interview</option>
                                                                        <option value="INTERVIEW_SCHEDULED" ${app.status == 'INTERVIEW_SCHEDULED' ? 'selected' : ''}>Schedule Interview</option>
                                                                        <option value="SELECTED" ${app.status == 'SELECTED' ? 'selected' : ''}>Select Candidate (Hire)</option>
                                                                        <option value="REJECTED" ${app.status == 'REJECTED' ? 'selected' : ''}>Reject Application</option>
                                                                    </select>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label fw-semibold small">Notes / Remarks / Interview Details</label>
                                                                    <textarea class="form-control" name="remarks" rows="3" placeholder="e.g. Technical interview scheduled for Friday at 3:00 PM on Google Meet..."></textarea>
                                                                    <span class="text-muted small">These remarks will be visible to the student in their status timeline.</span>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary btn-sm">Confirm Update</button>
                                                            </div>
                                                        </form>
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
