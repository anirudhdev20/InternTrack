<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="System Internships - InternTrack" />
<c:set var="activePage" value="internships" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">System-Wide Internship Audit</h2>
                    <p class="text-muted small mb-0">Complete list of all internship postings across enterprise partners</p>
                </div>
            </div>

            <div class="card card-custom">
                <div class="card-custom-body p-0">
                    <div class="table-responsive">
                        <table class="table table-custom">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Role Title</th>
                                    <th>Partner Company</th>
                                    <th>Mode & Location</th>
                                    <th>Stipend</th>
                                    <th>Faculty Review Status</th>
                                    <th>Python Score</th>
                                    <th>Created</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${internships}" var="i">
                                    <tr>
                                        <td class="text-muted">#${i.id}</td>
                                        <td class="fw-bold text-dark">${i.title}</td>
                                        <td>${i.company.name}</td>
                                        <td>${i.workMode} &middot; <span class="text-muted small">${i.location}</span></td>
                                        <td><span class="badge bg-light text-dark border">${i.stipend}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${i.reviewStatus == 'APPROVED'}"><span class="badge-status badge-approved">Approved</span></c:when>
                                                <c:when test="${i.reviewStatus == 'PENDING_REVIEW'}"><span class="badge-status badge-pending">Pending Review</span></c:when>
                                                <c:when test="${i.reviewStatus == 'REJECTED'}"><span class="badge-status badge-rejected">Rejected</span></c:when>
                                                <c:otherwise><span class="badge-status badge-closed">${i.reviewStatus}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${i.assessment != null}">
                                                    <span class="badge ${i.assessment.score >= 80 ? 'bg-success' : i.assessment.score >= 50 ? 'bg-warning text-dark' : 'bg-danger'}">
                                                        ${i.assessment.score}/100
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${i.createdAt.toLocalDate()}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
