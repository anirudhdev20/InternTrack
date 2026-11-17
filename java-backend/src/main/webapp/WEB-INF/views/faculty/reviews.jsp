<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Pending Reviews - InternTrack" />
<c:set var="activePage" value="reviews" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Internship Review Queue</h2>
                    <p class="text-muted small mb-0">Evaluate company internship proposals, inspect Python completeness metrics, and make accreditation decisions</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/faculty/reviews/history" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-clock-history me-1"></i> Past Decisions History
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
                        <c:when test="${empty pendingListings}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-shield-check fs-1 text-success d-block mb-2"></i>
                                <h5>No Pending Reviews</h5>
                                <p class="small mb-0">There are currently no internship postings awaiting faculty review.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Role Title</th>
                                            <th>Company Name</th>
                                            <th>Stipend & Duration</th>
                                            <th>Mode & Location</th>
                                            <th>Python Completeness</th>
                                            <th>Recommendation</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pendingListings}" var="item">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${item.title}</div>
                                                    <span class="text-muted small">Submitted on ${item.createdAt.toLocalDate()}</span>
                                                </td>
                                                <td>${item.company.name}</td>
                                                <td>
                                                    <span class="text-success fw-semibold">${item.stipend}</span>
                                                    <div class="text-muted small">${item.duration}</div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-dark border">${item.workMode}</span>
                                                    <div class="text-muted small">${item.location}</div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.assessment != null}">
                                                            <span class="badge ${item.assessment.score >= 80 ? 'bg-success' : item.assessment.score >= 50 ? 'bg-warning text-dark' : 'bg-danger'} px-2 py-1 fs-6">
                                                                <i class="bi bi-cpu me-1"></i> ${item.assessment.score}/100
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="max-width: 250px;">
                                                    <span class="small text-secondary">
                                                        ${item.assessment != null ? item.assessment.recommendation : 'Under evaluation'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/faculty/reviews/${item.id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-shield-shaded me-1"></i> Review & Decide
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
