<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="sidebar">
    <sec:authorize access="hasRole('STUDENT')">
        <div class="sidebar-title">Student Portal</div>
        <ul class="sidebar-nav">
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'internships' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/internships">
                    <i class="bi bi-search"></i> Browse Internships
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'applications' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/applications">
                    <i class="bi bi-journal-check"></i> My Applications
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'progress' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/progress">
                    <i class="bi bi-patch-check"></i> Progress & Completion
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/profile">
                    <i class="bi bi-person-badge"></i> My Profile
                </a>
            </li>
        </ul>
    </sec:authorize>

    <sec:authorize access="hasRole('COMPANY')">
        <div class="sidebar-title">Company Portal</div>
        <ul class="sidebar-nav">
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/company/dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'internships' ? 'active' : ''}" href="${pageContext.request.contextPath}/company/internships">
                    <i class="bi bi-briefcase"></i> My Listings
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'create-internship' ? 'active' : ''}" href="${pageContext.request.contextPath}/company/internships/create">
                    <i class="bi bi-plus-circle"></i> Post New Internship
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'applicants' ? 'active' : ''}" href="${pageContext.request.contextPath}/company/applicants">
                    <i class="bi bi-people"></i> Manage Applicants
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/company/profile">
                    <i class="bi bi-building"></i> Company Profile
                </a>
            </li>
        </ul>
    </sec:authorize>

    <sec:authorize access="hasRole('FACULTY')">
        <div class="sidebar-title">Faculty Oversight</div>
        <ul class="sidebar-nav">
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/reviews">
                    <i class="bi bi-shield-check"></i> Pending Review Queue
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'review-history' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/reviews/history">
                    <i class="bi bi-clock-history"></i> Review History
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'students' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/students">
                    <i class="bi bi-mortarboard"></i> Student Monitoring
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'progress' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/progress">
                    <i class="bi bi-award"></i> Completion Verification
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'reports' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/reports">
                    <i class="bi bi-bar-chart-line"></i> Academic Reports
                </a>
            </li>
        </ul>
    </sec:authorize>

    <sec:authorize access="hasRole('ADMIN')">
        <div class="sidebar-title">System Administration</div>
        <ul class="sidebar-nav">
            <li class="nav-item">
                <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-speedometer2"></i> Admin Overview
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                    <i class="bi bi-people-fill"></i> User Accounts
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'departments' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/departments">
                    <i class="bi bi-diagram-3-fill"></i> Departments
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'internships' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/internships">
                    <i class="bi bi-briefcase-fill"></i> All Internships
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'applications' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/applications">
                    <i class="bi bi-file-earmark-text-fill"></i> All Applications
                </a>
            </li>
        </ul>
    </sec:authorize>
</div>
