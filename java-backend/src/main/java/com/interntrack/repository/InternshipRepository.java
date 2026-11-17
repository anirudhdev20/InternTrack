package com.interntrack.repository;

import com.interntrack.model.Internship;
import com.interntrack.model.ReviewStatus;
import com.interntrack.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InternshipRepository extends JpaRepository<Internship, Long> {

    List<Internship> findByCompanyOrderByCreatedAtDesc(User company);

    List<Internship> findByCompanyIdOrderByCreatedAtDesc(Long companyId);

    List<Internship> findByReviewStatusOrderByCreatedAtDesc(ReviewStatus reviewStatus);

    long countByReviewStatus(ReviewStatus reviewStatus);

    long countByCompanyAndReviewStatus(User company, ReviewStatus reviewStatus);

    long countByCompany(User company);

    @Query("SELECT i FROM Internship i WHERE i.reviewStatus = :status " +
           "AND (:title IS NULL OR LOWER(i.title) LIKE LOWER(CONCAT('%', :title, '%'))) " +
           "AND (:companyName IS NULL OR LOWER(i.company.name) LIKE LOWER(CONCAT('%', :companyName, '%'))) " +
           "AND (:skills IS NULL OR LOWER(i.requiredSkills) LIKE LOWER(CONCAT('%', :skills, '%'))) " +
           "AND (:location IS NULL OR LOWER(i.location) LIKE LOWER(CONCAT('%', :location, '%'))) " +
           "AND (:workMode IS NULL OR i.workMode = :workMode) " +
           "AND (:dept IS NULL OR LOWER(i.departmentPreference) LIKE LOWER(CONCAT('%', :dept, '%'))) " +
           "ORDER BY i.createdAt DESC")
    List<Internship> searchApprovedInternships(
            @Param("status") ReviewStatus status,
            @Param("title") String title,
            @Param("companyName") String companyName,
            @Param("skills") String skills,
            @Param("location") String location,
            @Param("workMode") com.interntrack.model.WorkMode workMode,
            @Param("dept") String dept
    );
}
