<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Browse Internships - InternTrack" />
<c:set var="activePage" value="internships" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="mb-4">
                <h2 class="fw-bold text-dark mb-1">Approved Internship Opportunities</h2>
                <p class="text-muted small mb-0">Browse and search faculty-verified industry internship positions</p>
            </div>

            <!-- Filter Card -->
            <div class="card card-custom p-4 mb-4">
                <form action="${pageContext.request.contextPath}/student/internships" method="get">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Search Title</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                                <input type="text" class="form-control" name="title" value="${titleQuery}" placeholder="e.g. Java, Cloud, DevOps...">
                            </div>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Company Name</label>
                            <input type="text" class="form-control" name="company" value="${companyQuery}" placeholder="e.g. TechNova...">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Skills</label>
                            <input type="text" class="form-control" name="skills" value="${skillsQuery}" placeholder="e.g. Spring, Python, SQL...">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Work Mode</label>
                            <select class="form-select" name="workMode">
                                <option value="ALL">All Modes</option>
                                <option value="ON_SITE" ${workModeQuery == 'ON_SITE' ? 'selected' : ''}>On-Site</option>
                                <option value="REMOTE" ${workModeQuery == 'REMOTE' ? 'selected' : ''}>Remote</option>
                                <option value="HYBRID" ${workModeQuery == 'HYBRID' ? 'selected' : ''}>Hybrid</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Location</label>
                            <input type="text" class="form-control" name="location" value="${locationQuery}" placeholder="City / State...">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Department Preference</label>
                            <select class="form-select" name="department">
                                <option value="">All Departments</option>
                                <c:forEach items="${departments}" var="dept">
                                    <option value="${dept.departmentName}" ${deptQuery == dept.departmentName ? 'selected' : ''}>${dept.departmentName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2 d-flex align-items-end gap-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-funnel-fill me-1"></i> Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-outline-secondary" title="Reset Filters">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Internships Grid -->
            <c:choose>
                <c:when test="${empty internships}">
                    <div class="card card-custom p-5 text-center text-muted">
                        <i class="bi bi-briefcase fs-1 d-block mb-3 text-secondary"></i>
                        <h5>No internships match your search filters</h5>
                        <p class="small mb-3">Try adjusting your keywords or clearing selected filters.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/student/internships" class="btn btn-outline-primary btn-sm">Reset All Filters</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach items="${internships}" var="item">
                            <div class="col-md-6 col-xl-4">
                                <div class="card card-custom h-100 p-4 d-flex flex-column hover-shadow">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-primary bg-opacity-10 text-primary fw-semibold px-2 py-1">
                                            <i class="bi bi-building me-1"></i> ${item.company.name}
                                        </span>
                                        <span class="badge bg-light text-dark border">
                                            ${item.workMode}
                                        </span>
                                    </div>

                                    <h5 class="fw-bold text-dark mb-2">${item.title}</h5>

                                    <p class="text-muted small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                        ${item.description}
                                    </p>

                                    <div class="mb-3">
                                        <div class="small fw-semibold text-secondary mb-1">Required Skills:</div>
                                        <div class="d-flex flex-wrap gap-1">
                                            <c:forEach items="${item.requiredSkills.split(',')}" var="skill">
                                                <span class="badge bg-secondary bg-opacity-10 text-secondary border" style="font-size: 0.75rem;">${skill.trim()}</span>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <div class="border-top pt-3 mt-auto">
                                        <div class="row g-2 small text-muted mb-3">
                                            <div class="col-6">
                                                <i class="bi bi-cash me-1 text-success"></i> <strong>${item.stipend}</strong>
                                            </div>
                                            <div class="col-6 text-end">
                                                <i class="bi bi-clock me-1 text-primary"></i> ${item.duration}
                                            </div>
                                            <div class="col-6">
                                                <i class="bi bi-geo-alt me-1 text-danger"></i> ${item.location}
                                            </div>
                                            <div class="col-6 text-end">
                                                <i class="bi bi-people me-1 text-info"></i> ${item.vacancies} Pos.
                                            </div>
                                        </div>

                                        <div class="d-grid">
                                            <a href="${pageContext.request.contextPath}/student/internships/${item.id}" class="btn btn-outline-primary btn-sm">
                                                View Details & Apply <i class="bi bi-arrow-right ms-1"></i>
                                            </a>
                                        </div>
                                    </div>
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
