<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : "InternTrack - College-Integrated Internship Management"}</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Custom Stylesheet -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

<!-- Top Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top py-2">
    <div class="container-fluid px-4">
        <a class="navbar-brand navbar-brand-custom" href="${pageContext.request.contextPath}/">
            <span class="brand-badge"><i class="bi bi-mortarboard-fill"></i></span>
            <span>Intern<strong>Track</strong></span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#topNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="topNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                <sec:authorize access="!isAuthenticated()">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#how-it-works">How It Works</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/#roles">Roles</a>
                    </li>
                </sec:authorize>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <sec:authorize access="!isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary px-3">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Log In
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary px-3">
                        <i class="bi bi-person-plus-fill me-1"></i> Get Started
                    </a>
                </sec:authorize>

                <sec:authorize access="isAuthenticated()">
                    <!-- Notifications Link -->
                    <a href="${pageContext.request.contextPath}/notifications" class="btn btn-light position-relative p-2 rounded-circle" title="Notifications">
                        <i class="bi bi-bell fs-5 text-secondary"></i>
                    </a>

                    <!-- User Profile Dropdown / Info -->
                    <div class="dropdown">
                        <button class="btn btn-light border d-flex align-items-center gap-2 dropdown-toggle px-3 py-1 rounded-pill" type="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle fs-5 text-primary"></i>
                            <span class="fw-semibold text-dark"><sec:authentication property="principal.name"/></span>
                            <span class="badge bg-secondary text-uppercase ms-1" style="font-size: 0.65rem;">
                                <sec:authentication property="principal.authorities[0].authority" />
                            </span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                            <sec:authorize access="hasRole('STUDENT')">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2"></i>My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/applications"><i class="bi bi-journal-check me-2"></i>Applications</a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('COMPANY')">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/company/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/company/profile"><i class="bi bi-building me-2"></i>Company Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/company/internships"><i class="bi bi-briefcase me-2"></i>My Listings</a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('FACULTY')">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/faculty/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/faculty/reviews"><i class="bi bi-shield-check me-2"></i>Review Queue</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/faculty/students"><i class="bi bi-people me-2"></i>Students</a></li>
                            </sec:authorize>
                            <sec:authorize access="hasRole('ADMIN')">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Admin Dashboard</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people-fill me-2"></i>User Management</a></li>
                            </sec:authorize>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <form action="${pageContext.request.contextPath}/logout" method="post" class="px-2">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="dropdown-item text-danger rounded">
                                        <i class="bi bi-box-arrow-right me-2"></i>Sign Out
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </div>
</nav>
