<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Notifications - InternTrack" />
<jsp:include page="header.jsp" />

<div class="dashboard-wrapper">
    <jsp:include page="sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark mb-1">Notifications</h2>
                    <p class="text-muted small mb-0">System updates, review results, and recruitment alerts</p>
                </div>
            </div>

            <div class="card card-custom">
                <div class="card-custom-header">
                    <h5><i class="bi bi-bell-fill text-primary me-2"></i>Recent Alerts</h5>
                </div>
                <div class="card-custom-body p-0">
                    <c:choose>
                        <c:when test="${empty notifications}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-bell-slash fs-1 d-block mb-2 text-secondary"></i>
                                <h6>No notifications found</h6>
                                <p class="small">You're completely caught up!</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group list-group-flush">
                                <c:forEach items="${notifications}" var="n">
                                    <div class="list-group-item p-3 border-bottom d-flex align-items-start gap-3">
                                        <div class="p-2 rounded bg-light text-primary">
                                            <i class="bi bi-info-circle-fill fs-5"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="text-dark">${n.message}</div>
                                            <div class="text-muted small mt-1">
                                                <i class="bi bi-clock me-1"></i> ${n.createdAt}
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="footer.jsp" />
