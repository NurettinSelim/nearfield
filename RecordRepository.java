package com.example.phoneserver.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.phoneserver.entity.Record;

public interface RecordRepository extends JpaRepository<Record, Long> {
    // Additional query methods if needed
}