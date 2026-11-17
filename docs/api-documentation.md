# InternTrack – Python Assessment Microservice REST API Documentation

## 1. Microservice Overview

- **Service Name**: InternTrack Internship Quality and Completeness Assessment Service
- **Technology**: Python 3.11+ / Flask
- **Port**: `5000`
- **Host**: `0.0.0.0` (accessible via `http://127.0.0.1:5000`)
- **Protocol**: HTTP/1.1 REST (JSON)
- **CORS**: Enabled for cross-origin integration

The microservice provides automated rule-based evaluation of internship opportunity completeness across 8 dimensions (Total: 100 points), assisting college faculty with decision support without replacing human judgment.

---

## 2. API Endpoints

### 2.1 Health Check Endpoint

Verifies microservice availability and health.

- **URL**: `/api/health`
- **Method**: `GET`
- **Authentication**: Public
- **Headers**: None required

#### Success Response (200 OK)
```json
{
  "service": "InternTrack Internship Quality Assessment Service",
  "status": "UP",
  "version": "1.0.0"
}
```

---

### 2.2 Internship Completeness Assessment Endpoint

Analyzes incoming internship specifications and generates a quantitative score (0-100), itemized list of missing sections, quality warnings, actionable recommendations, and faculty review advice.

- **URL**: `/api/assess`
- **Method**: `POST`
- **Authentication**: Service-to-Service REST
- **Headers**: `Content-Type: application/json`

#### Request Payload Schema
| Field | Type | Required | Description |
|---|---|---|---|
| `title` | String | Yes | Internship role title |
| `description` | String | Yes | Full job description & sprint deliverables |
| `skills` | String / Array | Yes | Required technical & professional skills |
| `eligibility` | String | Yes | Degree, branch, and CGPA requirements |
| `duration` | String | Yes | Expected duration (e.g. "3 Months") |
| `stipend` | String | Yes | Compensation amount or unpaid policy |
| `mentorship` | String | Yes | Designated mentor & review structure |
| `location` | String | Yes | Base office location |
| `work_mode` | String | Yes | `ON_SITE`, `REMOTE`, or `HYBRID` |

#### Example Request Payload
```json
{
  "title": "Machine Learning & AI Intern",
  "description": "Collaborate with data engineers to deploy production transformer models, build REST inference APIs, and optimize latency using PyTorch and FastAPI.",
  "skills": ["Python", "PyTorch", "Docker", "REST API", "Git"],
  "eligibility": "B.Tech CSE/IT pre-final or final year with 7.0+ CGPA",
  "duration": "3 Months",
  "stipend": "$900/month",
  "mentorship": "Senior Lead Data Scientist provides bi-weekly architectural mentoring and hands-on code reviews.",
  "location": "Bangalore / Hybrid",
  "work_mode": "HYBRID"
}
```

#### Example Success Response (200 OK)
```json
{
  "score": 95,
  "missing_details": [],
  "warnings": [],
  "suggestions": [],
  "recommendation": "Ready for faculty review - Comprehensive and well-detailed internship posting."
}
```

#### Incomplete Listing Example Response (200 OK)
```json
{
  "score": 26,
  "missing_details": [
    "Required Skills",
    "Eligibility Requirements",
    "Internship Duration",
    "Mentorship / Supervision Details",
    "Work Mode (On-site, Remote, or Hybrid)",
    "Work Location / Office Address"
  ],
  "warnings": [
    "Internship description is very brief (less than 60 characters).",
    "Internship is listed as unpaid. College policy strongly recommends compensated internships.",
    "No designated mentor or supervision plan mentioned."
  ],
  "suggestions": [
    "Expand the description with project scope, deliverables, and technologies used.",
    "Specify technical and non-technical skills required (e.g., Java, Spring, SQL).",
    "Specify eligible degree programs, branches (e.g. CSE, IT), and minimum academic criteria.",
    "Define duration clearly (e.g., '2 Months', '6 Months').",
    "Describe mentorship arrangements, including reporting manager or frequency of review."
  ],
  "recommendation": "Needs revision - Critical internship details are missing or insufficient."
}
```

#### Error Responses
- **400 Bad Request**: When `Content-Type` is not `application/json` or payload body is empty.
  ```json
  {
    "error": "Bad Request",
    "message": "Content-Type must be application/json"
  }
  ```
- **500 Internal Server Error**: If an unexpected server-side exception occurs.
  ```json
  {
    "error": "Internal Server Error",
    "message": "Detailed error string"
  }
  ```

---

## 3. Scoring Rubric (100 Points Total)

| Dimension | Points Allocated | Evaluation Criteria |
|---|---|---|
| **1. Title** | 10 pts | Non-empty (+6 pts), length >= 5 characters and descriptive (+4 pts) |
| **2. Description** | 20 pts | Non-empty (+8 pts), length >= 60 chars (+7 pts), length >= 150 chars (+5 pts) |
| **3. Skills** | 15 pts | Non-empty (+7 pts), >= 2 distinct competencies (+8 pts) |
| **4. Eligibility** | 10 pts | Non-empty (+5 pts), comprehensive prerequisite details (+5 pts) |
| **5. Duration** | 10 pts | Stated timeframe (+10 pts) |
| **6. Stipend** | 15 pts | Defined amount (+15 pts); Unpaid penalized with warning (+8 pts max) |
| **7. Mentorship** | 10 pts | Defined supervision and guidance structure (+10 pts) |
| **8. Location & Mode** | 10 pts | Valid mode: ON_SITE / REMOTE / HYBRID (+5 pts), location stated (+5 pts) |

---

## 4. Java Backend Integration

Communication is implemented in `com.interntrack.service.AssessmentService` via Java 17's non-blocking `java.net.http.HttpClient` with configured connect and request timeouts.

### Fault Tolerance & Graceful Degradation
If the Python microservice is offline or encounters an outage:
1. The Java backend catches the `HttpConnectException` or `TimeoutException`.
2. The internship listing is still persisted safely in MySQL.
3. An `InternshipAssessment` record is created with `score = 0` and `assessment_status = "MANUAL_REVIEW_REQUIRED"`.
4. The system flags the opportunity for faculty manual inspection without blocking the company's submission workflow.
