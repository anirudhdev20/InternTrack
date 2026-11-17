# InternTrack – System Architecture & Technical Design

## 1. Executive Architecture Overview

**InternTrack** is designed as a centralized, college-integrated internship management system connecting **Students**, **Companies**, and **College Faculty** under **Administrative** governance.

The platform employs a **hybrid decoupled architecture**:
1. **Core Enterprise Web Application**: Built on **Spring Boot 3.4.x / 3.5.x**, **Spring MVC**, **Spring Security 6**, and **JSP (JavaServer Pages)** styled with **Bootstrap 5**, deployed as a **WAR archive** on **Apache Tomcat 10.1**.
2. **Quality & Completeness Microservice**: Built on **Python 3 Flask**, providing transparent rule-based analysis of internship opportunities via REST APIs prior to faculty review.
3. **Relational Persistence Layer**: **MySQL 8.x** with normalized tables, foreign key constraints, cascading behaviors, and Hibernate JPA mappings.

---

## 2. System Architecture Diagram

```mermaid
flowchart TD
    subgraph ClientLayer["Frontend Client Layer (JSP + Bootstrap 5)"]
        S_UI["Student Portal (JSP)"]
        C_UI["Company Portal (JSP)"]
        F_UI["Faculty Portal (JSP)"]
        A_UI["Admin Portal (JSP)"]
    end

    subgraph AppServer["Java Web Application (Apache Tomcat 10.1 / Spring Boot 3.4.x WAR)"]
        direction TB
        SEC["Spring Security 6 (BCrypt / RBAC FilterChain)"]
        CTRL["Spring MVC Controllers (@Controller)"]
        SVC["Business Service Layer (@Service)"]
        REPO["Data Access Layer (Spring Data JPA)"]
        CLIENT["REST HTTP Client (Java 17 HttpClient)"]

        SEC --> CTRL
        CTRL --> SVC
        SVC --> REPO
        SVC --> CLIENT
    end

    subgraph Microservice["Python 3 Microservice (Flask on Port 5000)"]
        FLASK["Flask REST API (app.py)"]
        ENGINE["Rule-Based Assessment Engine (assessor.py)"]
        FLASK --> ENGINE
    end

    subgraph DatabaseLayer["Relational Database (MySQL 8.x)"]
        MYSQL[("MySQL 8.x Database: interntrack")]
    end

    subgraph StorageLayer["File System Storage"]
        FILES["Uploads Directory (/resumes, /certificates)"]
    end

    ClientLayer --> SEC
    CLIENT -- "POST /api/assess (JSON)" --> FLASK
    FLASK -- "Completeness Score & Advice (JSON)" --> CLIENT
    REPO --> MYSQL
    SVC --> FILES
```

---

## 3. Workflow Diagrams

### 3.1 Internship Approval & Quality Control Workflow

```mermaid
sequenceDiagram
    autonumber
    actor Company as Company Representative
    participant Java as Java Spring Boot Backend
    participant Python as Python Flask Microservice
    participant DB as MySQL Database
    actor Faculty as College Faculty Member
    actor Student as College Student

    Company->>Java: Create Internship Listing (Title, Skills, Stipend, Mentorship)
    Java->>DB: Save listing with ReviewStatus = PENDING_REVIEW
    Java->>Python: POST /api/assess with internship specifications
    Python-->>Java: Return score (0-100), warnings, missing details, recommendation
    Java->>DB: Persist assessment report in internship_assessments
    Java->>DB: Emit review notification to Faculty
    Faculty->>Java: View pending review queue & inspect Python assessment report
    alt Faculty Approves Listing
        Faculty->>Java: Approve listing
        Java->>DB: Set ReviewStatus = APPROVED, record review history
        Java->>DB: Send approval notification to Company
        Student->>Java: Browse & discover approved listing
    else Faculty Rejects Listing
        Faculty->>Java: Reject listing with mandatory revision reason
        Java->>DB: Set ReviewStatus = REJECTED, store feedback
        Java->>DB: Send revision feedback notification to Company
        Company->>Java: Edit listing to address feedback and resubmit
    end
```

### 3.2 Student Recruitment & Academic Completion Workflow

```mermaid
sequenceDiagram
    autonumber
    actor Student as Student
    participant Java as Java Backend
    participant DB as MySQL Database
    actor Company as Company
    actor Faculty as Faculty

    Student->>Java: Apply for approved internship (Resume submitted)
    Java->>DB: Check for duplicate application (Unique constraint enforced)
    Java->>DB: Save application with status = APPLIED
    Company->>Java: Review student profile, academic year, and resume
    Company->>Java: Transition status: SHORTLISTED -> INTERVIEW_SCHEDULED -> SELECTED
    Java->>DB: Update application status and log application_status_history
    Java->>DB: Notify student of recruitment milestone
    Student->>Java: Submit periodic work log & upload completion certificate
    Java->>DB: Save progress log with status = SUBMITTED
    Faculty->>Java: Inspect certificate and work summary
    Faculty->>Java: Verify academic completion (Status = VERIFIED)
    Java->>DB: Award verified academic internship credit
```

---

## 4. Software Layering & Design Principles

The Java application strictly adheres to the layered enterprise architectural pattern:

| Package | Layer Responsibilities |
|---|---|
| `com.interntrack.config` | Spring context configuration, `WebMvcConfigurer` resource handlers for uploads, and `DataInitializer` database seeder. |
| `com.interntrack.security` | Spring Security 6 `SecurityFilterChain`, `CustomUserDetails`, `CustomUserDetailsService`, and `CustomAuthenticationSuccessHandler` for role-based dashboard redirection. |
| `com.interntrack.controller` | Spring MVC controllers handling HTTP requests, form bindings, and returning JSP views (`HomeController`, `StudentController`, `CompanyController`, `FacultyController`, `AdminController`). |
| `com.interntrack.service` | Encapsulates all transactional business operations, security validation, duplicate checks, and orchestrates Python REST API communication. |
| `com.interntrack.repository` | Spring Data JPA interfaces extending `JpaRepository` with custom JPQL queries and indexing. |
| `com.interntrack.model` | Normalized Hibernate JPA entity classes representing database tables and domain enums. |
| `com.interntrack.dto` | Data Transfer Objects representing payloads exchanged between microservices and views. |
| `com.interntrack.util` | Security and authentication helper utilities. |

---

## 5. Deployment Model: WAR Packaging & Tomcat 10.1

- **Packaging**: `<packaging>war</packaging>` configured in `pom.xml`.
- **Jakarta EE 10 Namespace**: Standardized on `jakarta.servlet.*`, `jakarta.persistence.*`, and `jakarta.validation.*`.
- **Dual Execution Capability**:
  1. **Embedded Tomcat**: Runnable directly via `java -jar interntrack.war` or `mvn spring-boot:run`.
  2. **Standalone Tomcat 10.1**: Can be deployed to any production Tomcat 10.1+ servlet container by dropping `interntrack.war` into `webapps/`.
