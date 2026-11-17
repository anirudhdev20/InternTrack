<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Completion Verification - InternTrack" />
<c:set var="activePage" value="progress" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Internship Progress & Certificate Verification</h2>
                    <p class="text-muted small mb-0">Evaluate student work logs and grant college academic credit verification</p>
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
                        <c:when test="${empty progressList}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-patch-check fs-1 d-block mb-2 text-secondary"></i>
                                <h6>No student progress records submitted yet</h6>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Student Candidate</th>
                                            <th>Department</th>
                                            <th>Internship & Company</th>
                                            <th>Progress Summary</th>
                                            <th>Certificate Document</th>
                                            <th>Status</th>
                                            <th>Verification Decision</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${progressList}" var="p">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${p.application.student.name}</div>
                                                    <span class="text-muted small">${p.application.student.email}</span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-dark border">
                                                        ${p.application.student.department != null ? p.application.student.department.departmentName : 'N/A'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="fw-semibold text-primary">${p.application.internship.title}</div>
                                                    <span class="text-muted small">${p.application.internship.company.name}</span>
                                                </td>
                                                <td style="max-width: 250px;">
                                                    <span class="small text-secondary">
                                                        ${not empty p.progressDescription ? p.progressDescription : 'No work description logged yet.'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty p.certificatePath}">
                                                            <a href="${pageContext.request.contextPath}/uploads/${p.certificatePath}" target="_blank" class="btn btn-sm btn-outline-success">
                                                                <i class="bi bi-award me-1"></i> View Certificate
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-muted border">Not Uploaded</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.completionStatus == 'VERIFIED'}">
                                                            <span class="badge bg-success p-2">Verified</span>
                                                        </c:when>
                                                        <c:when test="${p.completionStatus == 'SUBMITTED'}">
                                                            <span class="badge bg-warning text-dark p-2">Needs Review</span>
                                                        </c:when>
                                                        <c:when test="${p.completionStatus == 'IN_PROGRESS'}">
                                                            <span class="badge bg-info text-dark p-2">In Progress</span>
                                                        </c:when>
                                                        <c:when test="${p.completionStatus == 'COMPLETION_REJECTED'}">
                                                            <span class="badge bg-danger p-2">Rejected</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary p-2">Not Started</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-1">
                                                        <form action="${pageContext.request.contextPath}/faculty/progress/${p.id}/verify" method="post">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                            <input type="hidden" name="approved" value="true"/>
                                                            <button type="submit" class="btn btn-sm btn-success" title="Approve Completion" onclick="return confirmAction('Verify and certify completion for ${p.application.student.name}?');">
                                                                <i class="bi bi-check-lg"></i> Verify
                                                            </button>
                                                        </form>
                                                        <button class="btn btn-sm btn-outline-danger" type="button" data-bs-toggle="modal" data-bs-target="#rejectProgressModal${p.id}" title="Reject Certificate">
                                                            <i class="bi bi-x-lg"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>

                                            <!-- Reject Progress Modal -->
                                            <div class="modal fade" id="rejectProgressModal${p.id}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <form action="${pageContext.request.contextPath}/faculty/progress/${p.id}/verify" method="post">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                            <input type="hidden" name="approved" value="false"/>
                                                            <div class="modal-header">
                                                                <h5 class="modal-title fw-bold">Reject Certificate - ${p.application.student.name}</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body p-4">
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-semibold small">Feedback / Reason for Student</label>
                                                                    <textarea class="form-control" name="remarks" rows="3" placeholder="Explain why the certificate is rejected (e.g. invalid signature, missing duration)..." required></textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-danger btn-sm">Confirm Rejection</button>
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
