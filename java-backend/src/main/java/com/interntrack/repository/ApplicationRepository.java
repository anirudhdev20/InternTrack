package com.interntrack.repository;

import com.interntrack.model.Application;
import com.interntrack.model.ApplicationStatus;
import com.interntrack.model.Internship;
import com.interntrack.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ApplicationRepository extends JpaRepository<Application, Long> {

    List<Application> findByStudentOrderByAppliedAtDesc(User student);

    List<Application> findByStudentIdOrderByAppliedAtDesc(Long studentId);

    List<Application> findByInternshipOrderByAppliedAtDesc(Internship internship);

    @Query("SELECT a FROM Application a WHERE a.internship.company.id = :companyId ORDER BY a.appliedAt DESC")
    List<Application> findByCompanyId(@Param("companyId") Long companyId);

    @Query("SELECT a FROM Application a WHERE a.internship.company.id = :companyId AND a.internship.id = :internshipId ORDER BY a.appliedAt DESC")
    List<Application> findByCompanyIdAndInternshipId(@Param("companyId") Long companyId, @Param("internshipId") Long internshipId);

    boolean existsByStudentAndInternship(User student, Internship internship);

    boolean existsByStudentIdAndInternshipId(Long studentId, Long internshipId);

    long countByStudentAndStatus(User student, ApplicationStatus status);

    long countByStudent(User student);

    long countByStatus(ApplicationStatus status);

    @Query("SELECT COUNT(a) FROM Application a WHERE a.internship.company.id = :companyId")
    long countByCompanyId(@Param("companyId") Long companyId);

    @Query("SELECT COUNT(a) FROM Application a WHERE a.internship.company.id = :companyId AND a.status = :status")
    long countByCompanyIdAndStatus(@Param("companyId") Long companyId, @Param("status") ApplicationStatus status);

    @Query("SELECT a FROM Application a WHERE a.student.department.id = :deptId ORDER BY a.appliedAt DESC")
    List<Application> findByDepartmentId(@Param("deptId") Long deptId);

    @Query("SELECT a FROM Application a WHERE a.status = :status ORDER BY a.appliedAt DESC")
    List<Application> findByStatusOrder(@Param("status") ApplicationStatus status);
}
