"""
InternTrack - Automated End-to-End System Integration Test Suite
Verifies all 4 user roles, Spring Security, MySQL persistence,
and the Python Flask assessment microservice.
"""

import requests
import re
import sys

BASE_URL = "http://127.0.0.1:8080"


def extract_csrf(html: str) -> str:
    match = re.search(r'name="_csrf"\s+value="([^"]+)"', html)
    if not match:
        match = re.search(r'value="([^"]+)"\s+name="_csrf"', html)
    if match:
        return match.group(1)
    return ""


def test_suite():
    print("=" * 70)
    print("STARTING INTERNTRACK INTEGRATION TEST SUITE")
    print("=" * 70)

    # 1. Test Public Endpoints
    print("\n[TEST 1] Verifying Landing Page & Public Accessibility...")
    s = requests.Session()
    r = s.get(f"{BASE_URL}/")
    assert r.status_code == 200, f"Landing page returned {r.status_code}"
    assert "InternTrack" in r.text, "Landing page missing InternTrack brand"
    print(" PASS: Landing page responded with HTTP 200 and verified branding.")

    # 2. Test Student Login & Dashboard
    print("\n[TEST 2] Verifying Student Authentication & Role Redirection...")
    r = s.get(f"{BASE_URL}/login")
    csrf = extract_csrf(r.text)
    r_login = s.post(f"{BASE_URL}/login", data={
        "email": "alex.rivera@student.edu",
        "password": "password123",
        "_csrf": csrf
    }, allow_redirects=True)
    assert r_login.status_code == 200, f"Student login failed: {r_login.status_code}"
    assert "/student/dashboard" in r_login.url, f"Expected student dashboard, got {r_login.url}"
    assert "Student Portal" in r_login.text or "Welcome back" in r_login.text, "Missing student dashboard content"
    print(" PASS: Student successfully logged in and redirected to /student/dashboard.")

    # 3. Test Student Browse Internships
    print("\n[TEST 3] Verifying Student Internship Catalog & Filters...")
    r_browse = s.get(f"{BASE_URL}/student/internships")
    assert r_browse.status_code == 200, f"Browse internships returned {r_browse.status_code}"
    assert "Approved Internship Opportunities" in r_browse.text
    print(" PASS: Student successfully accessed approved internship catalog.")

    # 4. Test Company Login & Dashboard
    print("\n[TEST 4] Verifying Company Authentication & Role Redirection...")
    s_comp = requests.Session()
    r = s_comp.get(f"{BASE_URL}/login")
    csrf = extract_csrf(r.text)
    r_comp_login = s_comp.post(f"{BASE_URL}/login", data={
        "email": "hr@technova.com",
        "password": "password123",
        "_csrf": csrf
    }, allow_redirects=True)
    assert r_comp_login.status_code == 200
    assert "/company/dashboard" in r_comp_login.url
    print(" PASS: Company user successfully logged in and redirected to /company/dashboard.")

    # 5. Test Company Internship Creation & Python Assessment Trigger
    print("\n[TEST 5] Verifying Company Internship Creation with Python Assessment...")
    r_create_page = s_comp.get(f"{BASE_URL}/company/internships/create")
    csrf_create = extract_csrf(r_create_page.text)
    new_internship_data = {
        "title": "Machine Learning & AI Intern",
        "description": "Collaborate with data engineers to deploy production transformer models, build REST inference APIs, and optimize latency using PyTorch and FastAPI.",
        "requiredSkills": "Python, PyTorch, Docker, REST API, Git",
        "eligibility": "B.Tech CSE/IT pre-final or final year with 7.0+ CGPA",
        "departmentPreference": "Computer Science and Engineering",
        "duration": "3 Months",
        "stipend": "$900/month",
        "location": "Bangalore / Hybrid",
        "workMode": "HYBRID",
        "vacancies": "2",
        "deadlineStr": "2026-12-31",
        "mentorshipDetails": "Senior Lead Data Scientist provides bi-weekly architectural mentoring and hands-on code reviews.",
        "_csrf": csrf_create
    }
    r_submit = s_comp.post(f"{BASE_URL}/company/internships/create", data=new_internship_data, allow_redirects=True)
    assert r_submit.status_code == 200
    assert "Machine Learning & AI Intern" in r_submit.text
    print(" PASS: Internship created, evaluated by Python microservice, and queued for review.")

    # 6. Test Faculty Login, Review Queue, & Decision
    print("\n[TEST 6] Verifying Faculty Oversight & Internship Decision Workflow...")
    s_fac = requests.Session()
    r = s_fac.get(f"{BASE_URL}/login")
    csrf = extract_csrf(r.text)
    r_fac_login = s_fac.post(f"{BASE_URL}/login", data={
        "email": "faculty.cse@interntrack.edu",
        "password": "password123",
        "_csrf": csrf
    }, allow_redirects=True)
    assert r_fac_login.status_code == 200
    assert "/faculty/dashboard" in r_fac_login.url

    # Check reviews queue
    r_queue = s_fac.get(f"{BASE_URL}/faculty/reviews")
    assert r_queue.status_code == 200
    assert "Machine Learning & AI Intern" in r_queue.text

    # Extract the ID of the new listing (specifically matching the row for Machine Learning & AI Intern)
    match_row = re.search(r'Machine Learning & AI Intern.*?/faculty/reviews/(\d+)', r_queue.text, re.DOTALL)
    if match_row:
        listing_id = match_row.group(1)
    else:
        # Fallback search if reverse order
        match_row2 = re.search(r'/faculty/reviews/(\d+).*?Machine Learning & AI Intern', r_queue.text, re.DOTALL)
        assert match_row2, "Could not find Machine Learning listing ID in faculty review queue"
        listing_id = match_row2.group(1)

    # View review detail page
    r_detail = s_fac.get(f"{BASE_URL}/faculty/reviews/{listing_id}")
    assert r_detail.status_code == 200
    assert "Python Microservice Completeness Assessment Report" in r_detail.text
    assert "Completeness Score" in r_detail.text

    # Approve the listing
    csrf_detail = extract_csrf(r_detail.text)
    r_approve = s_fac.post(f"{BASE_URL}/faculty/reviews/{listing_id}/decide", data={
        "decision": "APPROVED",
        "reason": "Exemplary machine learning role meeting all academic project prerequisites.",
        "_csrf": csrf_detail
    }, allow_redirects=True)
    assert r_approve.status_code == 200
    print(f" PASS: Faculty successfully reviewed listing #{listing_id} with Python report and approved it.")

    # 7. Test Student Applies for Newly Approved Internship
    print("\n[TEST 7] Verifying Student Application Submission...")
    r_student_browse = s.get(f"{BASE_URL}/student/internships")
    assert "Machine Learning & AI Intern" in r_student_browse.text

    # Get student apply details
    r_details = s.get(f"{BASE_URL}/student/internships/{listing_id}")
    csrf_apply = extract_csrf(r_details.text)
    r_applied = s.post(f"{BASE_URL}/student/apply/{listing_id}", data={
        "_csrf": csrf_apply
    }, allow_redirects=True)
    assert r_applied.status_code == 200
    assert "Application submitted successfully" in r_applied.text or "/student/applications" in r_applied.url

    # Test Duplicate Application Prevention
    print("  Checking Duplicate Application Prevention...")
    # Refresh CSRF token from applications page
    csrf_dup = extract_csrf(r_applied.text)
    r_dup = s.post(f"{BASE_URL}/student/apply/{listing_id}", data={
        "_csrf": csrf_dup if csrf_dup else csrf_apply
    }, allow_redirects=True)
    if "already submitted an application" not in r_dup.text:
        alerts = [line.strip() for line in r_dup.text.splitlines() if "alert" in line.lower() or "already" in line.lower() or "error" in line.lower() or "danger" in line.lower()]
        print("DEBUG alerts found:", alerts)
    assert "already submitted an application" in r_dup.text
    print(" PASS: Application successfully registered and duplicate applications strictly prevented.")

    # 8. Test Company Applicant Management
    print("\n[TEST 8] Verifying Company Applicant Management & Recruitment Status Transitions...")
    r_applicants = s_comp.get(f"{BASE_URL}/company/applicants?internshipId={listing_id}")
    assert r_applicants.status_code == 200
    assert "Alex Rivera" in r_applicants.text

    # Extract application ID
    match_app_id = re.search(rf'/company/applicants/(\d+)/status', r_applicants.text)
    assert match_app_id, "Could not find application ID in company applicants table"
    app_id = match_app_id.group(1)
    csrf_app = extract_csrf(r_applicants.text)

    # Update status to SHORTLISTED
    r_status = s_comp.post(f"{BASE_URL}/company/applicants/{app_id}/status", data={
        "newStatus": "SHORTLISTED",
        "remarks": "Shortlisted for Round 1 Technical Interview via Google Meet.",
        "_csrf": csrf_app
    }, allow_redirects=True)
    assert r_status.status_code == 200
    assert "Applicant status updated to SHORTLISTED" in r_status.text

    # Update status to SELECTED
    r_select = s_comp.post(f"{BASE_URL}/company/applicants/{app_id}/status", data={
        "newStatus": "SELECTED",
        "remarks": "Candidate passed live coding with excellence. Offer letter dispatched.",
        "_csrf": csrf_app
    }, allow_redirects=True)
    assert r_select.status_code == 200
    assert "Applicant status updated to SELECTED" in r_select.text
    print(f" PASS: Company successfully transitioned application #{app_id} through recruitment pipeline to SELECTED.")

    # 9. Test Student Progress Submission & Faculty Verification
    print("\n[TEST 9] Verifying Student Progress Reporting & Faculty Verification...")
    r_prog_page = s.get(f"{BASE_URL}/student/progress")
    assert r_prog_page.status_code == 200
    assert "Machine Learning & AI Intern" in r_prog_page.text

    csrf_prog = extract_csrf(r_prog_page.text)
    r_prog_submit = s.post(f"{BASE_URL}/student/progress", data={
        "applicationId": app_id,
        "progressDescription": "Developed transformer model fine-tuning pipeline; achieved 92% accuracy on validation set.",
        "_csrf": csrf_prog
    }, allow_redirects=True)
    assert r_prog_submit.status_code == 200

    # Faculty monitors and verifies progress
    r_fac_prog = s_fac.get(f"{BASE_URL}/faculty/progress")
    assert r_fac_prog.status_code == 200
    assert "Alex Rivera" in r_fac_prog.text
    match_prog_id = re.search(r'Alex Rivera.*?/faculty/progress/(\d+)/verify', r_fac_prog.text, re.DOTALL)
    if not match_prog_id:
        match_prog_id = re.search(r'/faculty/progress/(\d+)/verify', r_fac_prog.text)
    assert match_prog_id, "Could not find progress record ID for verification"
    prog_id = match_prog_id.group(1)
    csrf_fac_prog = extract_csrf(r_fac_prog.text)

    r_verify = s_fac.post(f"{BASE_URL}/faculty/progress/{prog_id}/verify", data={
        "approved": "true",
        "remarks": "Project report verified by CSE Faculty Guide.",
        "_csrf": csrf_fac_prog
    }, allow_redirects=True)
    assert r_verify.status_code == 200
    print(" PASS: Progress logged by student and academic completion verified by faculty.")

    # 10. Test Admin Dashboard & Controls
    print("\n[TEST 10] Verifying Administrator Management & Platform Audit...")
    s_admin = requests.Session()
    r = s_admin.get(f"{BASE_URL}/login")
    csrf = extract_csrf(r.text)
    r_admin_login = s_admin.post(f"{BASE_URL}/login", data={
        "email": "admin@interntrack.edu",
        "password": "password123",
        "_csrf": csrf
    }, allow_redirects=True)
    assert r_admin_login.status_code == 200
    assert "/admin/dashboard" in r_admin_login.url

    # Check Admin Users Page
    r_users = s_admin.get(f"{BASE_URL}/admin/users")
    assert r_users.status_code == 200
    assert "alex.rivera@student.edu" in r_users.text

    # Check Admin Departments Page
    r_dept = s_admin.get(f"{BASE_URL}/admin/departments")
    assert r_dept.status_code == 200
    assert "Computer Science and Engineering" in r_dept.text
    print(" PASS: Administrator dashboard and platform control records verified.")

    print("\n" + "=" * 70)
    print("ALL 10 INTEGRATION TESTS COMPLETED SUCCESSFULLY WITH 100% PASS RATE!")
    print("=" * 70)


if __name__ == "__main__":
    test_suite()
