<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Progress & Completion - InternTrack" />
<c:set var="activePage" value="progress" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1">Internship Progress & Completion</h2>
                <p class="text-muted small mb-0">Submit periodic work logs and upload completion certificates for academic faculty verification</p>
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

            <c:choose>
                <c:when test="${empty selectedApplications}">
                    <div class="card card-custom p-5 text-center text-muted">
                        <i class="bi bi-award fs-1 d-block mb-3 text-secondary"></i>
                        <h5>No Active or Selected Internships</h5>
                        <p class="small mb-3">Progress reporting and certificate submission are enabled once a company marks your recruitment status as <strong>SELECTED</strong>.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-primary btn-sm">Check Application Status</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach items="${selectedApplications}" var="app">
                            <div class="col-lg-6">
                                <div class="card card-custom h-100 p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <span class="badge bg-success mb-1">SELECTED CANDIDATE</span>
                                            <h4 class="fw-bold text-dark mb-0">${app.internship.title}</h4>
                                            <span class="text-muted small">${app.internship.company.name}</span>
                                        </div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${app.progress.completionStatus == 'VERIFIED'}">
                                                    <span class="badge bg-success p-2"><i class="bi bi-patch-check-fill me-1"></i> Verified by Faculty</span>
                                                </c:when>
                                                <c:when test="${app.progress.completionStatus == 'SUBMITTED'}">
                                                    <span class="badge bg-warning text-dark p-2"><i class="bi bi-hourglass-split me-1"></i> Pending Verification</span>
                                                </c:when>
                                                <c:when test="${app.progress.completionStatus == 'IN_PROGRESS'}">
                                                    <span class="badge bg-info text-dark p-2"><i class="bi bi-arrow-repeat me-1"></i> In Progress</span>
                                                </c:when>
                                                <c:when test="${app.progress.completionStatus == 'COMPLETION_REJECTED'}">
                                                    <span class="badge bg-danger p-2"><i class="bi bi-x-circle me-1"></i> Revision Required</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary p-2">Not Started</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <hr>

                                    <!-- Progress Submission Form -->
                                    <form action="${pageContext.request.contextPath}/student/progress" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="applicationId" value="${app.id}"/>

                                        <div class="mb-3">
                                            <label class="form-label fw-semibold small">Progress Log / Work Summary</label>
                                            <textarea class="form-control" name="progressDescription" rows="4" placeholder="Detail your sprint contributions, technologies used, problems solved..." required>${app.progress != null ? app.progress.progressDescription : ''}</textarea>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-semibold small">Upload Completion Certificate (PDF/PNG/JPG)</label>
                                            <input type="file" class="form-control" name="certificateFile" accept=".pdf,.png,.jpg,.jpeg">
                                            <c:if test="${app.progress != null && not empty app.progress.certificatePath}">
                                                <div class="mt-2 small text-success">
                                                    <i class="bi bi-file-earmark-check-fill me-1"></i> Uploaded Certificate:
                                                    <a href="${pageContext.request.contextPath}/uploads/${app.progress.certificatePath}" target="_blank" class="fw-semibold text-decoration-none">
                                                        View Certificate Document
                                                    </a>
                                                </div>
                                            </c:if>
                                        </div>

                                        <c:if test="${app.progress != null && app.progress.verifiedBy != null}">
                                            <div class="alert alert-light border small text-muted mb-3">
                                                <i class="bi bi-shield-check text-success me-1"></i>
                                                Verified by: <strong>${app.progress.verifiedBy.name}</strong> on ${app.progress.verifiedAt}
                                            </div>
                                        </c:if>

                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="bi bi-cloud-arrow-up-fill me-1"></i> Submit Progress Update
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
