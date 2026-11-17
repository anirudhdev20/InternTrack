package com.interntrack.repository;

import com.interntrack.model.CompanyProfile;
import com.interntrack.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CompanyProfileRepository extends JpaRepository<CompanyProfile, Long> {
    Optional<CompanyProfile> findByUser(User user);
    Optional<CompanyProfile> findByUserId(Long userId);
}
