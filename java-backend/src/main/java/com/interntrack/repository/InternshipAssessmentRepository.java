package com.interntrack.repository;

import com.interntrack.model.Internship;
import com.interntrack.model.InternshipAssessment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface InternshipAssessmentRepository extends JpaRepository<InternshipAssessment, Long> {
    Optional<InternshipAssessment> findByInternship(Internship internship);
    Optional<InternshipAssessment> findByInternshipId(Long internshipId);
}
