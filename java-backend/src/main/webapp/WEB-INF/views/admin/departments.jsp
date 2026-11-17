<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Department Management - InternTrack" />
<c:set var="activePage" value="departments" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Academic Departments</h2>
                    <p class="text-muted small mb-0">Manage college engineering branches and academic units</p>
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

            <div class="row g-4">
                <!-- Add Department Form -->
                <div class="col-lg-4">
                    <div class="card card-custom p-4">
                        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-plus-circle text-primary me-2"></i>Add Department</h5>
                        <form action="${pageContext.request.contextPath}/admin/departments" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small">Department Name *</label>
                                <input type="text" class="form-control" name="departmentName" placeholder="e.g. Chemical Engineering" required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-save me-1"></i> Create Department
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Existing Departments List -->
                <div class="col-lg-8">
                    <div class="card card-custom">
                        <div class="card-custom-header">
                            <h5><i class="bi bi-diagram-3-fill text-primary me-2"></i>Existing College Departments</h5>
                        </div>
                        <div class="card-custom-body p-0">
                            <div class="table-responsive">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Department Name</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${departments}" var="d">
                                            <tr>
                                                <td class="text-muted">${d.id}</td>
                                                <td class="fw-bold text-dark">${d.departmentName}</td>
                                                <td><span class="badge bg-success">Active</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp" />
