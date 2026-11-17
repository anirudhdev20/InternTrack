package com.interntrack.service;

import com.interntrack.model.Department;
import com.interntrack.repository.DepartmentRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class DepartmentService {

    private final DepartmentRepository departmentRepository;

    public DepartmentService(DepartmentRepository departmentRepository) {
        this.departmentRepository = departmentRepository;
    }

    @Transactional(readOnly = true)
    public List<Department> findAll() {
        return departmentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Department> findById(Long id) {
        return departmentRepository.findById(id);
    }

    @Transactional
    public Department save(String departmentName) {
        if (departmentRepository.existsByDepartmentName(departmentName.trim())) {
            throw new IllegalArgumentException("Department name already exists: " + departmentName);
        }
        return departmentRepository.save(new Department(departmentName.trim()));
    }

    @Transactional
    public Department update(Long id, String newName) {
        Department dept = departmentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Department not found: " + id));
        dept.setDepartmentName(newName.trim());
        return departmentRepository.save(dept);
    }
}
