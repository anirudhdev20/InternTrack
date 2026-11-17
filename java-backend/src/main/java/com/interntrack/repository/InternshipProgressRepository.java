package com.interntrack.repository;

import com.interntrack.model.Application;
import com.interntrack.model.CompletionStatus;
import com.interntrack.model.InternshipProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InternshipProgressRepository extends JpaRepository<InternshipProgress, Long> {
    Optional<InternshipProgress> findByApplication(Application application);
    Optional<InternshipProgress> findByApplicationId(Long applicationId);

    List<InternshipProgress> findByCompletionStatus(CompletionStatus completionStatus);
    long countByCompletionStatus(CompletionStatus completionStatus);

    @Query("SELECT p FROM InternshipProgress p WHERE p.application.student.department.id = :deptId")
    List<InternshipProgress> findByDepartmentId(@Param("deptId") Long deptId);
}
