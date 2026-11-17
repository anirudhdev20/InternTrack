<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Review History - InternTrack" />
<c:set var="activePage" value="review-history" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Faculty Review History</h2>
                    <p class="text-muted small mb-0">Audit log of all evaluated and accredited internship listings</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/faculty/reviews" class="btn btn-primary btn-sm">
                        <i class="bi bi-hourglass-split me-1"></i> Pending Queue
                    </a>
                </div>
            </div>

            <div class="card card-custom">
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty reviewedListings}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-clock-history fs-1 d-block mb-2 text-secondary"></i>
                                <h6>No reviewed listings found</h6>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Internship Title</th>
                                            <th>Company</th>
                                            <th>Decision</th>
                                            <th>Faculty Feedback / Remarks</th>
                                            <th>Reviewed By</th>
                                            <th>Review Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${reviewedListings}" var="item">
                                            <tr>
                                                <td class="fw-bold text-dark">${item.title}</td>
                                                <td>${item.company.name}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.reviewStatus == 'APPROVED'}">
                                                            <span class="badge-status badge-approved">Approved</span>
                                                        </c:when>
                                                        <c:when test="${item.reviewStatus == 'REJECTED'}">
                                                            <span class="badge-status badge-rejected">Rejected</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status badge-closed">${item.reviewStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="max-width: 300px;">
                                                    <span class="small text-secondary">
                                                        <c:choose>
                                                            <c:when test="${not empty item.reviews}">
                                                                "${item.reviews[0].reason}"
                                                            </c:when>
                                                            <c:otherwise>
                                                                Standard evaluation criteria met.
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="small fw-semibold text-dark">
                                                        ${not empty item.reviews ? item.reviews[0].faculty.name : 'Faculty Authority'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="small text-muted">
                                                        ${not empty item.reviews ? item.reviews[0].reviewedAt.toLocalDate() : item.updatedAt.toLocalDate()}
                                                    </span>
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
