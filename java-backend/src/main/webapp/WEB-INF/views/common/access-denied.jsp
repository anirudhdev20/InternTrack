<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Access Denied - InternTrack" />
<jsp:include page="header.jsp" />

<div class="container py-5 text-center my-auto">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card card-custom p-5 shadow text-center">
                <i class="bi bi-shield-lock-fill text-danger" style="font-size: 4rem;"></i>
                <h2 class="fw-bold text-dark mt-3">403 - Access Denied</h2>
                <p class="text-muted mt-2">
                    You do not possess the required role permissions to access this requested resource or dashboard.
                </p>
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary px-4">
                        <i class="bi bi-house-door-fill me-1"></i> Return to Homepage
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
