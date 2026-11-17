package com.interntrack.repository;

import com.interntrack.model.Application;
import com.interntrack.model.ApplicationStatusHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ApplicationStatusHistoryRepository extends JpaRepository<ApplicationStatusHistory, Long> {
    List<ApplicationStatusHistory> findByApplicationOrderByUpdatedAtDesc(Application application);
    List<ApplicationStatusHistory> findByApplicationIdOrderByUpdatedAtDesc(Long applicationId);
}
