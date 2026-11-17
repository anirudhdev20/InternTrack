package com.interntrack.repository;

import com.interntrack.model.Role;
import com.interntrack.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    List<User> findByRole(Role role);
    List<User> findByRoleAndActive(Role role, boolean active);
    long countByRole(Role role);
    List<User> findByDepartmentIdAndRole(Long departmentId, Role role);
}
