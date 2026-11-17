<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="System Applications - InternTrack" />
<c:set var="activePage" value="applications" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">System-Wide Application Audit</h2>
                    <p class="text-muted small mb-0">Record of all student applications and recruitment milestones across the college</p>
                </div>
            </div>

            <div class="card card-custom">
                <div class="card-custom-body p-0">
                    <div class="table-responsive">
                        <table class="table table-custom">
                            <thead>
                                <tr>
                                    <th>App ID</th>
                                    <th>Student Candidate</th>
                                    <th>Department</th>
                                    <th>Internship Title</th>
                                    <th>Company</th>
                                    <th>Applied Date</th>
                                    <th>Recruitment Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${applications}" var="a">
                                    <tr>
                                        <td class="text-muted">#${a.id}</td>
                                        <td>
                                            <div class="fw-bold text-dark">${a.student.name}</div>
                                            <span class="text-muted small">${a.student.email}</span>
                                        </td>
                                        <td>${a.student.department != null ? a.student.department.departmentName : '-'}</td>
                                        <td class="fw-semibold text-primary">${a.internship.title}</td>
                                        <td>${a.internship.company.name}</td>
                                        <td>${a.appliedAt.toLocalDate()}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.status == 'APPLIED'}"><span class="badge-status badge-applied">Applied</span></c:when>
                                                <c:when test="${a.status == 'UNDER_REVIEW'}"><span class="badge-status badge-review">Under Review</span></c:when>
                                                <c:when test="${a.status == 'SHORTLISTED'}"><span class="badge-status badge-shortlisted">Shortlisted</span></c:when>
                                                <c:when test="${a.status == 'INTERVIEW_SCHEDULED'}"><span class="badge-status badge-interview">Interview Scheduled</span></c:when>
                                                <c:when test="${a.status == 'SELECTED'}"><span class="badge-status badge-selected">Selected</span></c:when>
                                                <c:otherwise><span class="badge-status badge-rejected">Rejected</span></c:otherwise>
                                            </c:choose>
                                        </td>
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
