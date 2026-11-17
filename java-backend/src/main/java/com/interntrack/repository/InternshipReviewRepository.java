package com.interntrack.repository;

import com.interntrack.model.Internship;
import com.interntrack.model.InternshipReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InternshipReviewRepository extends JpaRepository<InternshipReview, Long> {
    List<InternshipReview> findByInternshipOrderByReviewedAtDesc(Internship internship);
    List<InternshipReview> findByFacultyIdOrderByReviewedAtDesc(Long facultyId);
}
