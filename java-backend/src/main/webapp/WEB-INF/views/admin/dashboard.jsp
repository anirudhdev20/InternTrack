<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard - InternTrack" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header Welcome -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">System Administration Dashboard</h2>
                    <p class="text-muted small mb-0">Platform overview, user management, and infrastructure health monitoring</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge ${pythonHealthy ? 'bg-success' : 'bg-danger'} p-2">
                        <i class="bi ${pythonHealthy ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill'} me-1"></i>
                        Python Microservice: ${pythonHealthy ? 'ONLINE (Port 5000)' : 'UNREACHABLE'}
                    </span>
                </div>
            </div>

            <!-- Stat Cards Row -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-dark">${totalUsers}</div>
                            <div class="stat-label">Total Users</div>
                        </div>
                        <div class="stat-icon bg-dark bg-opacity-10 text-dark">
                            <i class="bi bi-people-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-primary">${totalStudents}</div>
                            <div class="stat-label">Students</div>
                        </div>
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-mortarboard-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-warning">${totalCompanies}</div>
                            <div class="stat-label">Companies</div>
                        </div>
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-building"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-info">${totalFaculty}</div>
                            <div class="stat-label">Faculty</div>
                        </div>
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-person-badge-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-success">${totalInternships}</div>
                            <div class="stat-label">Internships</div>
                        </div>
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-briefcase-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-number text-secondary">${totalApplications}</div>
                            <div class="stat-label">Applications</div>
                        </div>
                        <div class="stat-icon bg-secondary bg-opacity-10 text-secondary">
                            <i class="bi bi-file-earmark-text-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Registered Users Table -->
            <div class="card card-custom">
                <div class="card-custom-header">
                    <h5><i class="bi bi-person-lines-fill text-primary me-2"></i>Platform Users Overview</h5>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-primary">Manage Users</a>
                </div>
                <div class="card-custom-body p-0">
                    <div class="table-responsive">
                        <table class="table table-custom">
                            <thead>
                                <tr>
                                    <th>User Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Department</th>
                                    <th>Account Status</th>
                                    <th>Registered On</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${recentUsers}" var="u">
                                    <tr>
                                        <td class="fw-semibold text-dark">${u.name}</td>
                                        <td>${u.email}</td>
                                        <td>
                                            <span class="badge ${u.role == 'STUDENT' ? 'bg-primary' : u.role == 'COMPANY' ? 'bg-warning text-dark' : u.role == 'FACULTY' ? 'bg-info text-dark' : 'bg-dark'} px-2 py-1">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td>${u.department != null ? u.department.departmentName : '-'}</td>
                                        <td>
                                            <span class="badge ${u.active ? 'bg-success' : 'bg-danger'} px-2 py-1">
                                                ${u.active ? 'Active' : 'Deactivated'}
                                            </span>
                                        </td>
                                        <td>${u.createdAt.toLocalDate()}</td>
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
