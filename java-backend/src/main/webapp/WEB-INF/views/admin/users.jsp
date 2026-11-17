<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="User Management - InternTrack" />
<c:set var="activePage" value="users" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">User Account Management</h2>
                    <p class="text-muted small mb-0">Control platform access, inspect credentials, and activate/deactivate accounts</p>
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

            <!-- Role Filter Bar -->
            <div class="card card-custom p-3 mb-4">
                <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-2 align-items-center">
                    <div class="col-auto">
                        <label class="fw-semibold small text-muted"><i class="bi bi-funnel me-1"></i>Filter Role:</label>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select form-select-sm" name="role" onchange="this.form.submit()">
                            <option value="ALL">All System Roles</option>
                            <option value="STUDENT" ${selectedRole == 'STUDENT' ? 'selected' : ''}>Students</option>
                            <option value="COMPANY" ${selectedRole == 'COMPANY' ? 'selected' : ''}>Companies</option>
                            <option value="FACULTY" ${selectedRole == 'FACULTY' ? 'selected' : ''}>Faculty Members</option>
                            <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Administrators</option>
                        </select>
                    </div>
                    <c:if test="${not empty selectedRole && selectedRole != 'ALL'}">
                        <div class="col-auto">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-link text-decoration-none">Reset Filter</a>
                        </div>
                    </c:if>
                </form>
            </div>

            <!-- Users Table -->
            <div class="card card-custom">
                <div class="card-custom-body p-0">
                    <div class="table-responsive">
                        <table class="table table-custom">
                            <thead>
                                <tr>
                                    <th>User Name</th>
                                    <th>Email Address</th>
                                    <th>Role</th>
                                    <th>Department</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Access Control</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${users}" var="u">
                                    <tr>
                                        <td class="fw-bold text-dark">${u.name}</td>
                                        <td>${u.email}</td>
                                        <td>
                                            <span class="badge ${u.role == 'STUDENT' ? 'bg-primary' : u.role == 'COMPANY' ? 'bg-warning text-dark' : u.role == 'FACULTY' ? 'bg-info text-dark' : 'bg-dark'} px-2 py-1">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td>${u.department != null ? u.department.departmentName : '-'}</td>
                                        <td>
                                            <span class="badge ${u.active ? 'bg-success' : 'bg-danger'} px-2 py-1">
                                                ${u.active ? 'ACTIVE' : 'DEACTIVATED'}
                                            </span>
                                        </td>
                                        <td>${u.createdAt.toLocalDate()}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/users/${u.id}/toggle" method="post" class="d-inline">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-sm ${u.active ? 'btn-outline-danger' : 'btn-outline-success'}" onclick="return confirmAction('Change account access status for ${u.name}?');">
                                                    <i class="bi ${u.active ? 'bi-lock-fill' : 'bi-unlock-fill'} me-1"></i>
                                                    ${u.active ? 'Deactivate' : 'Activate'}
                                                </button>
                                            </form>
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
