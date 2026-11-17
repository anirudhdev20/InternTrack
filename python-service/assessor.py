"""
InternTrack - Internship Quality and Completeness Assessment Engine
Rule-based scoring microservice for evaluating internship listings
prior to academic faculty review.
"""

from typing import Dict, Any, List


class InternshipAssessor:
    """
    Transparent, rule-based assessor that evaluates internship posting
    completeness across 8 critical dimensions (Total 100 points).
    """

    @staticmethod
    def assess(data: Dict[str, Any]) -> Dict[str, Any]:
        score = 0
        missing_details: List[str] = []
        warnings: List[str] = []
        suggestions: List[str] = []

        title = str(data.get("title", "")).strip()
        description = str(data.get("description", "")).strip()
        skills = data.get("skills", "")
        eligibility = str(data.get("eligibility", "")).strip()
        duration = str(data.get("duration", "")).strip()
        stipend = str(data.get("stipend", "")).strip()
        mentorship = str(data.get("mentorship", "")).strip()
        location = str(data.get("location", "")).strip()
        work_mode = str(data.get("work_mode", "")).strip().upper()

        # 1. Title Evaluation (10 points)
        if not title:
            missing_details.append("Internship Title")
            suggestions.append("Provide a clear and specific internship title (e.g., 'Full Stack Java Intern').")
        elif len(title) < 5:
            score += 4
            warnings.append("Internship title is too short or ambiguous.")
            suggestions.append("Use a recognizable industry role title.")
        else:
            score += 10

        # 2. Description Evaluation (20 points)
        if not description:
            missing_details.append("Internship Description")
            suggestions.append("Add a detailed description outlining day-to-day duties and learning outcomes.")
        elif len(description) < 60:
            score += 8
            warnings.append("Internship description is very brief (less than 60 characters).")
            suggestions.append("Expand the description with project scope, deliverables, and technologies used.")
        elif len(description) < 150:
            score += 15
        else:
            score += 20

        # 3. Required Skills Evaluation (15 points)
        skills_count = 0
        if isinstance(skills, list):
            skills_count = len([s for s in skills if str(s).strip()])
        elif isinstance(skills, str) and skills.strip():
            # comma-separated
            skills_count = len([s for s in skills.split(",") if s.strip()])

        if skills_count == 0:
            missing_details.append("Required Skills")
            suggestions.append("Specify technical and non-technical skills required (e.g., Java, Spring, SQL).")
        elif skills_count < 2:
            score += 7
            warnings.append("Only one skill was specified. Academic internships typically require multiple skills.")
            suggestions.append("List at least 2-3 specific technical competencies.")
        else:
            score += 15

        # 4. Eligibility Evaluation (10 points)
        if not eligibility:
            missing_details.append("Eligibility Requirements")
            suggestions.append("Specify eligible degree programs, branches (e.g. CSE, IT), and minimum academic criteria.")
        elif len(eligibility) < 10:
            score += 5
            warnings.append("Eligibility description is vague.")
        else:
            score += 10

        # 5. Duration Evaluation (10 points)
        if not duration:
            missing_details.append("Internship Duration")
            suggestions.append("Define duration clearly (e.g., '2 Months', '6 Months').")
        else:
            score += 10

        # 6. Stipend Information Evaluation (15 points)
        if not stipend:
            missing_details.append("Stipend Information")
            suggestions.append("Specify stipend details (e.g. amount per month or explicit unpaid policy).")
        else:
            stipend_lower = stipend.lower()
            if "unpaid" in stipend_lower or "0" in stipend_lower:
                score += 8
                warnings.append("Internship is listed as unpaid. College policy strongly recommends compensated internships.")
                suggestions.append("Consider providing a travel allowance or performance stipend.")
            else:
                score += 15

        # 7. Mentorship or Supervision (10 points)
        if not mentorship:
            missing_details.append("Mentorship / Supervision Details")
            warnings.append("No designated mentor or supervision plan mentioned.")
            suggestions.append("Describe mentorship arrangements, including reporting manager or frequency of review.")
        elif len(mentorship) < 20:
            score += 5
            warnings.append("Mentorship information is very brief.")
        else:
            score += 10

        # 8. Work Location & Work Mode (10 points)
        if not work_mode or work_mode not in ["ON_SITE", "REMOTE", "HYBRID"]:
            missing_details.append("Work Mode (On-site, Remote, or Hybrid)")
        else:
            score += 5

        if not location:
            missing_details.append("Work Location / Office Address")
            suggestions.append("Specify company office city or state even if work mode is remote.")
        else:
            score += 5

        # Recommendation Generation
        if score >= 80:
            recommendation = "Ready for faculty review - Comprehensive and well-detailed internship posting."
        elif score >= 50:
            recommendation = "Faculty review with caution - Moderate completeness; key sections need review."
        else:
            recommendation = "Needs revision - Critical internship details are missing or insufficient."

        return {
            "score": score,
            "missing_details": missing_details,
            "warnings": warnings,
            "suggestions": suggestions,
            "recommendation": recommendation
        }
