<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Monitoring - InternTrack" />
<c:set var="activePage" value="students" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Student Academic Monitoring</h2>
                    <p class="text-muted small mb-0">Oversee student internship involvement, department performance, and application distribution</p>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="card card-custom p-3 mb-4">
                <form action="${pageContext.request.contextPath}/faculty/students" method="get" class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-muted">Department</label>
                        <select class="form-select form-select-sm" name="departmentId" onchange="this.form.submit()">
                            <option value="">All Departments</option>
                            <c:forEach items="${departments}" var="d">
                                <option value="${d.id}" ${selectedDeptId == d.id ? 'selected' : ''}>${d.departmentName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-muted">Academic Year</label>
                        <select class="form-select form-select-sm" name="academicYear" onchange="this.form.submit()">
                            <option value="">All Academic Years</option>
                            <option value="1st Year" ${selectedYear == '1st Year' ? 'selected' : ''}>1st Year</option>
                            <option value="2nd Year" ${selectedYear == '2nd Year' ? 'selected' : ''}>2nd Year</option>
                            <option value="3rd Year" ${selectedYear == '3rd Year' ? 'selected' : ''}>3rd Year</option>
                            <option value="Final Year (4th Year)" ${selectedYear == 'Final Year (4th Year)' ? 'selected' : ''}>Final Year (4th Year)</option>
                        </select>
                    </div>

                    <div class="col-md-2 d-flex align-items-end">
                        <a href="${pageContext.request.contextPath}/faculty/students" class="btn btn-sm btn-outline-secondary w-100">Reset Filters</a>
                    </div>
                </form>
            </div>

            <!-- Students Table -->
            <div class="card card-custom">
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty students}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-people fs-1 d-block mb-2 text-secondary"></i>
                                <h6>No student records match the selected filter</h6>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Student Name</th>
                                            <th>College Email</th>
                                            <th>Department</th>
                                            <th>Year</th>
                                            <th>Technical Competencies</th>
                                            <th>Resume</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${students}" var="s">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${s.name}</div>
                                                    <span class="text-muted small"><i class="bi bi-telephone me-1"></i>${s.studentProfile != null ? s.studentProfile.phone : 'N/A'}</span>
                                                </td>
                                                <td>${s.email}</td>
                                                <td>
                                                    <span class="badge bg-light text-primary border">${s.department != null ? s.department.departmentName : 'Unassigned'}</span>
                                                </td>
                                                <td>${s.studentProfile != null ? s.studentProfile.academicYear : 'N/A'}</td>
                                                <td style="max-width: 250px;">
                                                    <span class="small text-secondary">${s.studentProfile != null && not empty s.studentProfile.skills ? s.studentProfile.skills : 'No skills recorded'}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${s.studentProfile != null && not empty s.studentProfile.resumePath}">
                                                            <a href="${pageContext.request.contextPath}/uploads/${s.studentProfile.resumePath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                                                <i class="bi bi-file-earmark-pdf me-1"></i> Resume
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-muted border">None</span>
                                                        </c:otherwise>
                                                    </c:choose>
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
