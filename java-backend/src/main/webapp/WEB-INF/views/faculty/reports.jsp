<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Academic Reports - InternTrack" />
<c:set var="activePage" value="reports" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1">Academic Internship Reports & Analytics</h2>
                <p class="text-muted small mb-0">Aggregate statistics on department participation, company partnerships, and student outcomes</p>
            </div>

            <div class="row g-4 mb-4">
                <!-- Department Distribution -->
                <div class="col-lg-6">
                    <div class="card card-custom h-100 p-4">
                        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-diagram-3-fill text-primary me-2"></i>Department-Wise Student Applications</h5>
                        <div class="list-group list-group-flush">
                            <c:forEach items="${deptApplications}" var="entry">
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-3 border-bottom">
                                    <span class="fw-semibold text-secondary">${entry.key}</span>
                                    <span class="badge bg-primary rounded-pill px-3 py-2 fs-6">${entry.value} Applications</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Company-Wise Postings -->
                <div class="col-lg-6">
                    <div class="card card-custom h-100 p-4">
                        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-building-fill text-warning me-2"></i>Company-Wise Opportunities Posted</h5>
                        <div class="list-group list-group-flush">
                            <c:forEach items="${companyPostings}" var="entry">
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-3 border-bottom">
                                    <span class="fw-semibold text-secondary">${entry.key}</span>
                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-2 fs-6">${entry.value} Listings</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Recruitment Outcomes -->
                <div class="col-lg-12">
                    <div class="card card-custom p-4">
                        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-pie-chart-fill text-success me-2"></i>Overall Recruitment Distribution</h5>
                        <div class="row g-3 text-center">
                            <c:forEach items="${statusDistribution}" var="entry">
                                <div class="col-sm-6 col-md-4 col-lg-2">
                                    <div class="p-3 bg-light rounded-3 border">
                                        <div class="h3 fw-bold text-dark mb-1">${entry.value}</div>
                                        <div class="small fw-semibold text-uppercase text-muted">${entry.key}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
